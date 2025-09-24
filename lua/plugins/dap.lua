return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            -- nvim-dap-ui 依赖 nio
            dependencies = {
                "nvim-neotest/nvim-nio",
            },
            config = function()
                -- 在调试会话开始和结束时自动打开/关闭 DAP UI
                local dap, dapui = require("dap"), require("dapui")
                dapui.setup()
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end,
        },
        { "mason-org/mason.nvim" },
        {
            "jay-babu/mason-nvim-dap.nvim",
            opts = {
                ensure_installed = {
                    -- 添加 codelldb
                    "codelldb",
                },
            },
        },
    },
    config = function()
        local dap = require("dap")

        -- Keymappings for DAP
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "调试：开关断点" })
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "调试：继续" })
        vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "调试：步过" })
        vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "调试：步进" })
        vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "调试：步出" })
        vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "调试：结束" })
        vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
        vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP: Run Last" })
        vim.keymap.set("n", "<Leader>dp", function()
            dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end)

        -- 在这里配置调试器
        dap.adapters.codelldb = {
            type = "server",
            port = "${port}", -- DAP 会自动替换为可用端口
            executable = {
                -- ‼️ 如果你手动安装，请确保这里的 'codelldb' 在你的 PATH 中 ‼️
                -- 如果使用 mason.nvim，它会自动处理路径，无需修改
                command = "codelldb",
                args = { "--port", "${port}" },
                detached = false,
            },
        }

        dap.configurations.rust = {
            {
                -- 这个名字可以自定义，方便你区分
                name = "Launch",
                type = "codelldb", -- ‼️ 关键：使用我们上面定义的 'codelldb' 适配器
                request = "launch",
                program = function()
                    -- 0. 运行'cargo build'生成二进制目标文件
                    vim.fn.system("cargo build")
                    -- 1. 运行 'cargo metadata' 并获取 JSON 输出
                    local cargo_metadata_json = vim.fn.system("cargo metadata --no-deps --format-version 1")
                    if vim.v.shell_error ~= 0 then
                        vim.notify("Error running 'cargo metadata': " .. cargo_metadata_json, vim.log.levels.ERROR)
                        return nil
                    end
                    -- 2. 解析 JSON
                    local cargo_metadata = vim.fn.json_decode(cargo_metadata_json)
                    -- 3. 直接从元数据中获取项目根目录
                    local project_root = cargo_metadata.workspace_root
                    -- 4. 寻找二进制目标文件的名字
                    local executable_name = nil
                    -- 我们只关心工作区的成员包
                    for _, member_id in ipairs(cargo_metadata.workspace_members) do
                        for _, package in ipairs(cargo_metadata.packages) do
                            if package.id == member_id then
                                for _, target in ipairs(package.targets) do
                                    -- 找到第一个 kind 为 "bin" 的目标
                                    if target.kind[1] == "bin" then
                                        executable_name = target.name
                                        break
                                    end
                                end
                            end
                            if executable_name then
                                break
                            end
                        end
                        if executable_name then
                            break
                        end
                    end
                    if not executable_name then
                        vim.notify("没有找到可执行文件，请手动输入路径", vim.log.levels.ERROR)
                        return vim.fn.input("Path to executable: ", "../target/debug/", "file")
                    end
                    -- 5. 构建并返回最终路径
                    local exec_path = vim.fs.joinpath(project_root, "target", "debug", executable_name)
                    vim.notify("DAP launching: " .. exec_path, vim.log.levels.INFO)
                    return exec_path
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                -- 如果需要传递命令行参数，可以取消注释
                -- args = function()
                --   local new_args = vim.split(vim.fn.input("Arguments: "), " ")
                --   return new_args
                -- end,
            },
        }
        -- ===================================================================
        -- ‼️ NEW: 定义自定义的 DAP 图标 ‼️
        -- ===================================================================
        local sign = vim.fn.sign_define
        sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        sign("DapBreakpointCondition", { text = "󰃤", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        sign("DapLogPoint", { text = "󰌑", texthl = "DapLogPoint", linehl = "", numhl = "" })
        sign("DapRejectedBreakpoint", { text = "󰚦", texthl = "DapRejectedBreakpoint", linehl = "", numhl = "" })
        sign("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
        -- ===================================================================
    end,
}
