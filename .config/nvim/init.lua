vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

require("lazy").setup({
	"stsewd/sphinx.nvim",
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"tpope/vim-sleuth",
	{
		"folke/neodev.nvim",
		name = "neodev",
		config = function()
			require("neodev").setup()
		end,
	},
	{
		"preservim/tagbar",
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		lazy = false,
		config = function() end,
	},
	"williamboman/mason.nvim",
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "black", "isort" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
					yaml = { "yamlfmt" },
					sh = { "shfmt" },
					json = { "fixjson" },
					cpp = { "clang-format" },
				},
			})

			require("conform").formatters.shfmt = {
				prepend_args = { "-i", "2" },
				-- The base args are { "-filename", "$FILENAME" } so the final args will be
				-- { "-i", "2", "-filename", "$FILENAME" }
			}
			-- prepend_args can be a function, just like args
			require("conform").formatters.shfmt = {
				prepend_args = function(self, ctx)
					return { "-i", "2" }
				end,
			}

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
		end,
	},
	"zapling/mason-conform.nvim",
	"mfussenegger/nvim-lint",
	{
		"neovim/nvim-lspconfig",
		-- Wrong config
		-- opts = {
		-- 	setup = {
		-- 		rust_analyzer = function()
		-- 			return true
		-- 		end,
		-- 	},
		-- },
	},
	"rshkarin/mason-nvim-lint",
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
			"folke/neodev.nvim",
		},
		config = function()
			require("mason-nvim-lint").setup({
				ensure_installed = {},
				automatic_installation = false,
				quiet_mode = false,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"rafamadriz/friendly-snippets",
		},
	},
	{ "folke/which-key.nvim",        opts = {} },
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"<leader>hp",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "Preview git hunk" }
				)
				local gs = package.loaded.gitsigns
				vim.keymap.set({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
				vim.keymap.set({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
			end,
		},
	},
	{
		"chrismccord/bclose.vim",
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
				light_style = "day", -- The theme is used when the background is set to light
				transparent = false, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark",  -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

				--  You can override specific color groups to use other groups or a hex color
				--  function will be called with a ColorScheme table
				-- @param colors ColorScheme
				on_colors = function(colors) end,

				--  You can override specific highlights to use other groups or a hex color
				--  function will be called with a Highlights and ColorScheme table
				-- @param highlights Highlights
				-- @param colors ColorScheme
				on_highlights = function(highlights, colors)
					highlights.debugPC = { bg = "#103545" }
				end,
			})
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
	},
	-- {
	-- 	'navarasu/onedark.nvim',
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require('onedark').setup {
	-- 			-- Main options --
	-- 			-- style = 'deep',      -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
	-- 			transparent = false, -- Show/hide background
	-- 			-- term_colors = true,   -- Change terminal color as per the selected theme style
	-- 			ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
	-- 			-- cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
	-- 		}
	-- 		-- vim.cmd("colorscheme onedark");
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				background = {
					dark = "macchiato",
					light = "latte",
				},
				transparent_background = false,

				custom_highlights = function(colors)
					local u = require("catppuccin.utils.colors")
					return {
						-- Cursor = { bg = colors.mantle },
						debugPC = {
							bg = u.vary_color({
								mocha = "#103545",
								macchiato = "#103545",
							}, u.darken(colors.surface0, 0.44)),
						},
					}
				end,
				-- custom_highlights = function(C)
				-- 	return {
				-- 		MsgSeparator = { bg = C.mantle },
				-- }
				-- end
			})
			-- vim.cmd("colorscheme catppuccin-latte")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		config = function()
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors) -- add/modify highlights
					return {}
				end,
				theme = "wave", -- Load "wave" theme when 'background' option is not set
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
					light = "lotus",
				},
			})

			-- setup must be called before loading
			-- vim.cmd("colorscheme kanagawa")
		end,
	},
	{
		-- Set lualine as atatusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				-- component_separators = '|',
				-- section_separators = '',
			},
			tabline = {
				lualine_a = { "buffers" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 2 } },
				lualine_x = { "%{tagbar#currenttag('[%s] ','')}", "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "▏" },
			scope = { exclude = { language = { "python" } } },
		},
	},
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"tree-sitter/tree-sitter-rust",
		},
		build = ":TSUpdate",
	},
	{
		"tree-sitter/tree-sitter-cpp",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
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
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},
	{ "mfussenegger/nvim-dap" },
	{ "liuchengxu/vista.vim" },
	{
		"fei6409/log-highlight.nvim",
		config = function()
			require("log-highlight").setup({})
		end,
	},
})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- tab stuff
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.softtabstop = 4

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
-- vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 1000
vim.o.timeoutlen = 500

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		initial_mode = "insert",
		wrap_results = true,
		path_display = {
			shorten = {
				len = 2,
				exclude = { -2, -1 },
			},
		},
		dynamic_preview_title = true,
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = require("telescope.actions").delete_buffer,
			},
			n = {
				["<C-d>"] = require("telescope.actions").delete_buffer,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>kd", vim.diagnostic.hide, { desc = "[K]ill diagnostics" })
vim.keymap.set("n", "<leader>ks", vim.diagnostic.show, { desc = "[K]ill diagnostics stop" })
vim.keymap.set("n", "<leader>ke", vim.diagnostic.enable, { desc = "[K]ill diagnostics forever disable" })
vim.keymap.set("n", "<leader>kf", vim.diagnostic.disable, { desc = "[K]ill diagnostics forever" })
vim.keymap.set("n", ",q", ":Bclose <CR>", { desc = "[B]uffer del" })
vim.keymap.set("n", ",l", ":bnext <CR>", { desc = "[B]uffer next" })
vim.keymap.set("n", ",h", ":bprev<CR>", { desc = "[B]uffer previous" })
-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
	require("nvim-treesitter.configs").setup({
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = {
			"c",
			"cpp",
			"go",
			"lua",
			"python",
			"rust",
			"tsx",
			"javascript",
			"typescript",
			"vimdoc",
			"vim",
			"bash",
			"markdown",
		},

		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = false,

		highlight = { enable = true },
		indent = { enable = false },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
				scope_incremental = "<c-s>",
				node_decremental = "<M-space>",
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
		modules = {},
		sync_install = true,
		ignore_install = {},
	})
end, 0)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local telescope_on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	-- function LSPBIWrap(tsbuiltin)
	-- 	local opts = {
	-- 		-- -- Defaults are commented
	-- 		-- include_declaration = true,
	-- 		-- include_current_file = true,
	-- 		-- fname_width = 30,
	-- 		-- show_line = true,
	-- 		-- trim_text = false,
	-- 		-- file_encoding = ?
	-- 		fname_width = 40,
	-- 	}
	-- 	return function()
	-- 		tsbuiltin(opts)
	-- 	end
	-- end

	-- Wrap these functions so that they get the fname_width and trim_text params set
	nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")
	vim.keymap.set("v", ",cf", vim.lsp.buf.format, { desc = "Format with LSP" })

-- vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function(_)
-- 	vim.lsp.buf.format()
-- end, { desc = "Format current buffer with LSP" })
end


-- document existing key chains
require("which-key").register({
	["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
	["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
	["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
	["<leader>h"] = { name = "More git", _ = "which_key_ignore" },
	["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
	["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
	["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
	["<leader>k"] = { name = "[K]ill", _ = "which_key_ignore" },
	["<leader>f"] = { name = "[f]iddle", _ = "which_key_ignore" },
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-conform").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	clangd = {
		filetypes = {
			"c",
			"cpp",
			"objc",
			"objcpp",
			"cuda",
			"proto",
		},
	},
	-- gopls = {},
	sqlls = {
		filetypes = { "sql" },
	},
	bashls = { filetypes = { "bash", "sh" } },
	-- rust_analyzer = {
	--   filetypes = {
	--     'rust',
	--   },
	-- },
	-- tsserver = {},
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },

	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
	pyright = {
		filetypes = { "python" },
	},
}

-- Setup neovim lua configuration
-- require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = telescope_on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
	["rust_analyzer"] = function() end,
	["clangd"] = function()
		require("lspconfig").clangd.setup({
			-- since cmd is a setting outisde of capabilities, on_attach, settings and filetypes
			-- I have to set it in a separate case
			cmd = {
				"clangd",
				"--background-index",
				"--completion-style=detailed",
				"--header-insertion=iwyu",
				"--all-scopes-completion",
				"--header-insertion-decorators",
				"--limit-references=0",
				"--clang-tidy",
				-- finding definitions when searching from header files, otherwise
				--  you're stuck with no def until you actually open the source for the impl
			},
			-- capabilities = capabilities,
			-- on_attach = on_attach,
			-- settings = servers['clangd'],
			-- filetypes = (servers['clangd'] or {}).filetypes,
		})
	end,
	-- ['rust_analyzer'] = function()
	--   -- Old Config, rust-tools is DEAD
	--   -- require("rust-tools").setup{}
	--   -- require('lspconfig').rust_analyzer.setup {
	--   --   rustfmt = {
	--   --     rangeFormatting = {
	--   --       enable = true,
	--   --     },
	--   --   },
	--     -- capabilities = capabilities,
	--     -- on_attach = on_attach,
	--     -- filetypes = (servers['rust_analyzer'] or {}).filetypes,
	--   -- }
	-- end,
	-- ['pyright'] = function()
	--   require('lspconfig').pyright.setup{}
	-- end
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})
-- vim.diagnostic.disable()
--
-- local dap = require('dap')
--
-- dap.adapters.gdb = {
--   type = "executable",
--   command = "gdb",
--   args = { "-i", "dap" }
-- }
--
-- dap.adapters.lldb = {
--   type = 'executable',
--   command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
--   name = 'lldb'
-- }
--
-- dap.configurations.cpp = {
--   {
--   name = 'Launch',
--   type = 'lldb',
--   request = 'launch',
--   program = function()
--     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--   end,
--   cwd = '${workspaceFolder}',
--   stopOnEntry = false,
--   args = {}
--   },
--   {
--     -- If you get an "Operation not permitted" error using this, try disabling YAMA:
--     --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
--     name = "Attach to process",
--     type = 'cpp',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
--     request = 'attach',
--     pid = require('dap.utils').pick_process,
--     args = {},
--   },
-- }
-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp
-- dap.configurations.rust = {
--   {
--     -- ... the previous config goes here ...,
--     initCommands = function()
--       -- Find out where to look for the pretty printer Python module
--       local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
--
--       local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
--       local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
--
--       local commands = {}
--       local file = io.open(commands_file, 'r')
--       if file then
--         for line in file:lines() do
--           table.insert(commands, line)
--         end
--         file:close()
--       end
--       table.insert(commands, 1, script_import)
--
--       return commands
--     end,
--     -- ...,
--   }
-- }
vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<S-F11>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<S-F12>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<F9>", function()
	require("dap").toggle_breakpoint()
end)
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

vim.opt.equalalways = false
vim.opt.wrap = true
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

vim.cmd([[
  packadd termdebug
  au User TermdebugStartPost vertical resize 50
  let g:termdebug_wide=1
]])

-- vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

vim.keymap.set("n", "<leader>fg", function()
	require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "[g]rep params" })

if vim.lsp.inlay_hint then
	vim.keymap.set("n", "<leader>uh", function()
		vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
	end, { desc = "Toggle Inlay Hints" })
end

-- vim.cmd("colorscheme tokyonight-moon")
vim.cmd("colorscheme kanagawa")

vim.g.rustaceanvim = {
	-- tools = {},
	server = {
		on_attach = telescope_on_attach,
		-- cmd = function()
		-- 	local mason_registry = require("mason-registry")
		-- 	local ra_binary = mason_registry.is_installed("rust-analyzer")
		-- 		-- This may need to be tweaked, depending on the operating system.
		-- 		and mason_registry.get_package("rust-analyzer"):get_install_path() .. "/rust-analyzer"
		-- 		or "rust-analyzer"
		-- 	return { ra_binary } -- You can add args to the list, such as '--log-file'
		-- end,
		-- default_settings = {
		-- 	-- LSP config
		-- 	["rust-analyzer"] = {},
		-- },
	},
	-- DAP configuration
	dap = {},
}
