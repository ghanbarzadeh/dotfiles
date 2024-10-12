-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	"tpope/vim-sleuth",
	require("themes"),
	-- INFO: Git related plugins
	{
		"lewis6991/gitsigns.nvim", -- Similar to fugitive, but adds additiona functionality
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
		end,
	},

	-- INFO: Enhance Editor Experience
	"mg979/vim-visual-multi", -- Enable multicursor
	"nvim-tree/nvim-web-devicons", -- Add fancy icons
	{
		"nvim-tree/nvim-tree.lua", -- File tree
		config = function()
			-- Config needed for nvim-tree
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				view = {
					cursorline = false,
					width = 40,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
					git_ignored = false,
				},
			})
		end,
	},
	{
		"folke/todo-comments.nvim", -- Fancy TODOs/FIXMEs
		dependencies = "nvim-lua/plenary.nvim",
		opts = { signs = false },
	},
	{
		"folke/which-key.nvim", -- Popup with possible keybindings of the command you started to type
		opts = {
			spec = {
				{ "<leader>d", group = "[D]iagnostics" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>l", group = "[L]ist ROS2" },
				{ "<leader>c", group = "Qui[C]k fix list" },
			},
			sort = { "group", "local", "order", "alphanum", "mod" },
		},
	},
	{
		"nvim-lualine/lualine.nvim", -- Fancier statusline
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = "|",
					section_separators = "",
					disabled_filetypes = { "NvimTree" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	{
		"nvim-pack/nvim-spectre", -- Advance Search and Replace
		opts = {},
	},
	{
		"goolord/alpha-nvim", -- Greeter dashboard
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
				"                                                     ",
			}
			dashboard.section.buttons.val = {
				dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "  > Find file", ":cd $HOME/Projects| Telescope find_files<CR>"),
				dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
				dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
			}

			local handle = io.popen("fortune")
			local fortune = handle:read("*a")
			handle:close()
			dashboard.section.footer.val = fortune

			dashboard.config.opts.noautocmd = true

			vim.cmd([[autocmd User AlphaReady echo 'ready']])
			-- vim.cmd([[
			--     autocmd FileType alpha setlocal nofoldenable
			-- ]])
			alpha.setup(dashboard.config)
		end,
	},
	{
		"romgrk/barbar.nvim", -- Tabline plugin that improves buffers and tabs
		-- event = "BufEnter",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = false,
			insert_at_start = false,
			sidebar_filetypes = {
				NvimTree = true,
				undotree = {
					text = "undotree",
					align = "center",
				},
				["neo-tree"] = { event = "BufWipeout" },
				Outline = { event = "BufWinLeave", text = "symbols-outline", align = "right" },
			},
		},
		version = "^1.0.0",
	},
	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		-- Optional dependency
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
		config = function()
			require("dressing").setup({
				input = {
					get_config = function()
						return {
							title_pos = "center",
							win_options = {
								sidescrolloff = 10,
							},
							insert_only = false,
						}
					end,
				},
			})
		end,
	},

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"benfowler/telescope-luasnip.nvim", -- Allows to search the available snippet
			"nvim-telescope/telescope-live-grep-args.nvim", -- Enable passing arguments to ripgrep
		},
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = "🔍 ",
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--follow",
					},
					path_display = {
						truncate = 3,
					},
				},
				pickers = {
					find_files = {
						find_command = {
							"rg",
							"--files",
							"--hidden",
							"-g",
							"!.git",
						},
						follow = true,
					},
					lsp_document_symbols = {
						show_line = true,
					},
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("luasnip")
			require("telescope").load_extension("live_grep_args")
		end,
	},

	--
	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP
			{
				"j-hui/fidget.nvim",
				config = function()
					require("fidget").setup({
						-- Options related to notification subsystem
						notification = {
							-- Options related to the notification window and buffer
							window = {
								normal_hl = "Comment", -- Base highlight group in the notification window
								border = "rounded", -- Border around the notification window
								zindex = 45, -- Stacking priority of the notification window
								max_width = 0, -- Maximum width of the notification window
								max_height = 0, -- Maximum height of the notification window
								x_padding = 1, -- Padding from right edge of window boundary
								y_padding = 0, -- Padding from bottom edge of window boundary
								align = "bottom", -- How to align the notification window
								relative = "editor", -- What the notification window position is relative to
							},
						},
					})
				end,
			},
		},
		config = function()
			-- INFO: LSP Settings
			-- This contains the configuration of several components related to LSPs
			-- - luasnip
			-- - mason
			-- - mason-lspconfig
			-- - nvim-cmp
			-- - nvim-lspconfig

			-- PERF:
			-- ====================================================
			-- LSP Keymaps
			-- ====================================================

			--  This function gets run when an LSP connects to a particular buffer.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("personal-lsp-attach", { clear = true }),
				callback = function(event)
					-- Create a wrapper function to simplify keymaps creation
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					--  Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-T>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					-- map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					-- -- Fuzzy find all the symbols in your current workspace
					-- --  Similar to document symbols, except searches over your whole project.
					-- map(
					-- 	"<leader>ws",
					-- 	require("telescope.builtin").lsp_dynamic_workspace_symbols,
					-- 	"[W]orkspace [S]ymbols"
					-- )

					-- -- Rename the variable under your cursor
					-- --  Most Language Servers support renaming across files, etc.
					-- map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					-- -- Execute a code action, usually your cursor needs to be on top of an error
					-- -- or a suggestion from your LSP for this to activate.
					-- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
					-- NOTE: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header

					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- PERF:
			-- ====================================================
			-- LSP Servers
			-- ====================================================
			local servers = {
				clangd = {
					cmd = {
						-- see clangd --help-hidden
						"clangd",
						"--background-index",
						-- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
						-- to add more checks, create .clang-tidy file in the root directory
						-- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
						"--clang-tidy",
						"--completion-style=bundled",
						"--cross-file-rename",
						"--header-insertion=iwyu",
					},
				},
				pyright = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							reportDuplicateImport = true,
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			-- PERF:
			-- ====================================================
			-- capabilities Configuratioon
			-- ====================================================

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.offsetEncoding = { "utf-16" }
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Enable folding (for nvim-ufo)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			-- PERF:
			-- ====================================================
			-- Mason Configuratioon
			-- ====================================================

			-- Setup mason so it can manage external tooling
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})

			-- mason-lspconfig configurations
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
			require("mason-tool-installer").setup({

				-- List of all DAP, Linter and Formatters to install
				ensure_installed = {
					-- LSPs
					"clangd",
					"lua_ls",
					"pyright",
					"ruff",

					-- DAP
					"codelldb",
					"cpptools",

					-- Linter
					"cpplint",

					-- Formatters
					"stylua",
					"prettier",
				},

				-- if set to true this will check each tool for updates. If updates
				-- are available the tool will be updated. This setting does not
				-- affect :MasonToolsUpdate or :MasonToolsInstall.
				-- Default: false
				auto_update = false,

				-- automatically install / update on startup. If set to false nothing
				-- will happen on startup. You can use :MasonToolsInstall or
				-- :MasonToolsUpdate to install tools and check for updates.
				-- Default: true
				run_on_start = true,

				-- set a delay (in ms) before the installation starts. This is only
				-- effective if run_on_start is set to true.
				-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
				-- Default: 0
				start_delay = 3000, -- 3 second delay

				-- Only attempt to install if 'debounce_hours' number of hours has
				-- elapsed since the last time Neovim was started. This stores a
				-- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
				-- This is only relevant when you are using 'run_on_start'. It has no
				-- effect when running manually via ':MasonToolsInstall' etc....
				-- Default: nil
				debounce_hours = 5, -- at least 5 hours between attempts to install/update
			})

			-- PERF:
			-- ====================================================
			-- nvim-cmp configuration
			-- ====================================================

			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				-- performance = {
				--   max_view_entries = 20,
				-- },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp", max_item_count = 10 },
					{ name = "luasnip" },
					{ name = "path", max_item_count = 5 },
					{ name = "buffer", max_item_count = 5 },
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})

			-- Suggested approach to cancel snippet session after going back to normal mode
			-- Taken from https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1011938524
			function leave_snippet()
				if
					((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
					and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
					and not require("luasnip").session.jump_active
				then
					require("luasnip").unlink_current()
				end
			end

			-- stop snippets when you leave to normal mode
			vim.api.nvim_command([[ autocmd ModeChanged * lua leave_snippet() ]])

			-- Custom command to disable completion
			local cmp_enabled = true
			vim.api.nvim_create_user_command("ToggleAutoComplete", function()
				if cmp_enabled then
					require("cmp").setup.buffer({ enabled = false })
					cmp_enabled = false
				else
					require("cmp").setup.buffer({ enabled = true })
					cmp_enabled = true
				end
			end, {})

			-- Configure cmp-cmdline
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			-- PERF:
			-- ====================================================
			-- LSP related UI Configurations
			-- ====================================================

			-- Add bordered to LSP info
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- INFO: Configure LSP textDocuments
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- -- Diagnostic signs
			-- local diagnostic_signs = {
			--   { name = 'DiagnosticSignError', text = ' ' },
			--   { name = 'DiagnosticSignWarn', text = ' ' },
			--   { name = 'DiagnosticSignHint', text = ' ' },
			--   { name = 'DiagnosticSignInfo', text = ' ' },
			-- }
			-- Diagnostic signs
			local diagnostic_signs = {
				{ name = "DiagnosticSignError", text = "" },
				{ name = "DiagnosticSignWarn", text = "" },
				{ name = "DiagnosticSignHint", text = "" },
				{ name = "DiagnosticSignInfo", text = "" },
			}
			for _, sign in ipairs(diagnostic_signs) do
				vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
			end

			vim.diagnostic.config({
				virtual_text = {
					prefix = "●", -- Could be '■', '▎', 'x'
				},
				severity_sort = true,
				float = {
					source = "always", -- Or "if_many"
				},
				signs = true,
			})
		end,
	},
	{ -- Formatter
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					json = { "prettierd", "prettier" },
					markdown = { "prettier" },
					python = { "isort", "black" },
					yaml = { "prettier" },
				},
				ignore_errors = true,
				lang_to_ext = {
					bash = "sh",
					latex = "tex",
					markdown = "md",
					python = "py",
				},
			})
			--
			-- set up Format and <leader>f commands which should behave equivalently
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
			end, { range = true })
			vim.keymap.set("", "<leader>f", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end)
		end,
	},
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp", -- Adds LSP completion capabilities
			"hrsh7th/cmp-buffer", -- Source for buffer words
			"hrsh7th/cmp-path", -- Add source filesystem path
			"hrsh7th/cmp-cmdline", -- Source for vim's cmdline
		},
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			-- [[ Configure Treesitter ]]
			-- See `:help nvim-treesitter`
			vim.defer_fn(function()
				require("nvim-treesitter.configs").setup({
					-- Add languages to be installed here that you want installed for treesitter
					ensure_installed = {
						"bash",
						"c",
						"cpp",
						"csv",
						"dockerfile",
						"gitcommit",
						"gitignore",
						"go",
						"html",
						"json",
						"lua",
						"markdown",
						"markdown_inline",
						"python",
						"vim",
						"vimdoc",
						"xml",
						"yaml",
					},

					-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
					auto_install = true,
					highlight = {
						enable = true,
						disable = function(lang, bufnr) -- Disable in large files
							return vim.api.nvim_buf_line_count(bufnr) > 50000
						end,
						additional_vim_regex_highlighting = false,
					},
					indent = { enable = true, disable = { "python", "cpp" } },
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "<c-space>",
							node_incremental = "<c-space>",
							scope_incremental = "<c-s>",
							node_decremental = "<c-backspace>",
						},
					},
					textobjects = {
						select = {
							enable = true,
							lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
							keymaps = {
								-- You can use the capture groups defined in textobjects.scm
								["aa"] = "@parameter.outer",
								["ia"] = "@parameter.inner",
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								["ic"] = "@class.inner",
							},
						},
						move = {
							enable = true,
							set_jumps = true, -- whether to set jumps in the jumplist
							goto_next_start = {
								["]m"] = "@function.outer",
								["]]"] = "@class.outer",
							},
							goto_next_end = {
								["]M"] = "@function.outer",
								["]["] = "@class.outer",
							},
							goto_previous_start = {
								["[m"] = "@function.outer",
								["[["] = "@class.outer",
							},
							goto_previous_end = {
								["[M"] = "@function.outer",
								["[]"] = "@class.outer",
							},
						},
						swap = {
							enable = true,
							swap_next = {
								["<leader>a"] = "@parameter.inner",
							},
							swap_previous = {
								["<leader>A"] = "@parameter.inner",
							},
						},
					},
				})
			end, 0)

			-- Configure highlight group for treesittercontext
			vim.cmd([[ hi TreesitterContextBottom gui=underline guisp=#a6e3a1 ]])
		end,
	},
	-- NOTE: Here you can add additional plugins that can enhance your Neovim Journey
	{ -- ROS2 related plugin
		"ErickKramer/nvim-ros2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			autocmds = true,
			telescope = true,
			treesitter = true,
		},
	},
}, {})


-- INFO: Editor Settingss

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make line numbers default
vim.opt.number = true

-- Relative line numbers
local numtogGrp = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "FocusGained" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
	end,
	group = numtogGrp,
	desc = "Turn on relative line numbering when the buffer is entered.",
})
vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter", "FocusLost" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = false
	end,
	group = numtogGrp,
	desc = "Turn off relative line numbering when the buffer is exited.",
})

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
-- vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on
vim.wo.signcolumn = "yes"
vim.opt.signcolumn = "yes:1" -- Enable expanding signcolumn

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- vim.o.hlsearch = false

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Render the column delimiter
-- vim.opt.colorcolumn = "100"

-- Tabs of 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

--  Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})


-- INFO: Keymaps configurations
--    Make sure to change these keymaps so that they make the most sense to you

-- Improve motions
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines down" })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Inc/dec
vim.keymap.set('n', '<C-c>', '<C-a>', { noremap = true, silent = true })

-- Improve pasting
vim.keymap.set("x", "p", [["_dP]], { desc = "Preserve previous word when pasting" })
vim.keymap.set("n", "<C-y>", ":%y+<CR>", { desc = "Yank all content in file" })
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all content in file" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.enable, { desc = "[D]iagnostics [E]nable" })

-- Fix forward jump after setting <TAB>
-- https://github.com/neovim/neovim/issues/20126
vim.keymap.set("n", "<C-I>", "<C-I>", { noremap = true })

-- Editor experience
vim.keymap.set("n", "<C-s>", ":write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<C-q>", ":quitall<CR>", { desc = "Quit" })

-- ====================================================
-- Telescope searching
-- ====================================================
vim.keymap.set("n", "<leader>s/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
		sorting_strategy = "ascending",
	}))
end, { desc = "Fuzzy search in current buffer" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "In [F]iles" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "By [G]rep" })
vim.keymap.set("n", "<leader>sp", require("telescope.builtin").spell_suggest, { desc = "S[P]ell suggestion" })

vim.keymap.set("n", "<leader>sl", function()
	require("telescope.builtin").live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[L]ive Grep in open files" })

-- ====================================================
-- Nvim Tree
-- ====================================================
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { desc = "NvimTree [T]oggle" })

-- ====================================================
-- Spectre
-- ====================================================
vim.keymap.set("n", "<leader>sr", require("spectre").open, { desc = "Open Search and Replace" })

-- ====================================================
-- barbar --> Tabs management
-- ====================================================
vim.keymap.set("n", "<A-p>", "<cmd>BufferPrevious<cr>", { silent = true, noremap = true, desc = "Go to previous tab" })
vim.keymap.set("n", "<A-n>", "<cmd>BufferNext<cr>", { silent = true, noremap = true, desc = "Go to next tab" })
vim.keymap.set("n", "<A-w>", "<cmd>BufferClose<cr>", { silent = true, noremap = true, desc = "Close current buffer" })
local opts = { noremap = true, silent = true }
-- Goto buffer in position...
vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)

-- ====================================================
-- Quickfix
-- ====================================================
vim.keymap.set("n", "<leader>cn", ":cnext<CR>", { desc = "Next quickfix list" })
vim.keymap.set("n", "<leader>cp", ":cprevious<CR>", { desc = "Previous quickfix list" })
-- ====================================================

-- nvim-ros2
-- ====================================================
vim.keymap.set("n", "<leader>li", ":Telescope ros2 interfaces<CR>", { desc = "[ROS 2]: List interfaces" })
vim.keymap.set("n", "<leader>ln", ":Telescope ros2 nodes<CR>", { desc = "[ROS 2]: List nodes" })
vim.keymap.set("n", "<leader>la", ":Telescope ros2 actions<CR>", { desc = "[ROS 2]: List actions" })
vim.keymap.set("n", "<leader>lt", ":Telescope ros2 topics<CR>", { desc = "[ROS 2]: List topics" })
vim.keymap.set("n", "<leader>ls", ":Telescope ros2 services<CR>", { desc = "[ROS 2]: List services" })
