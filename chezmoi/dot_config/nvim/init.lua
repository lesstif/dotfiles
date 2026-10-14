-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- sets spacebar as <leader>

require("lazy").setup({

  -- Theme
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
      vim.o.background = "light"
      require("solarized").setup({})
      vim.cmd.colorscheme("solarized")
    end,
  },

  -- Neovim 0.12+ and the rewritten Treesitter API.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local languages = { "lua", "python", "javascript", "vim", "vimdoc" }
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      treesitter.install(languages)

      local filetypes = {
        lua = "lua", python = "python", javascript = "javascript",
        vim = "vim", help = "vimdoc",
      }
      vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("DotfilesTreesitter", { clear = true }),
        callback = function(args)
          local language = filetypes[vim.bo[args.buf].filetype]
          if language then
            -- Installation is asynchronous; buffers still work before a parser is ready.
            pcall(vim.treesitter.start, args.buf, language)
          end
        end,
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {})
    end,
  },

  -- LSP: mason installs the servers, lspconfig wires them into Neovim
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" }, -- add more servers here, e.g. "pyright", "ts_ls"
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = { { name = "nvim_lsp" } },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({})
    end,
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
    end,
  },

})

-- OS별 GUI 폰트: 실제 설치된 폰트 패밀리 이름으로 지정
local fonts = {
  mac = "JetBrains Mono",
  windows = "JetBrainsMono",
  linux = "JetBrains Mono",
}

local font
if vim.fn.has("macunix") == 1 then
  font = fonts.mac
elseif vim.fn.has("win32") == 1 then
  font = fonts.windows
else
  font = fonts.linux
end

local font_size = 18
vim.o.guifont = string.format("%s:h%d", font, font_size)

---- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Insert mode: Cmd/Ctrl+V to paste
vim.keymap.set("i", "<D-v>", '<C-r>+', { noremap = true, silent = true }) -- macOS Cmd+V
vim.keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true }) -- Ctrl+V fallback

-- Visual mode: Cmd/Ctrl+C to copy
vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Normal mode: Cmd+V to paste
vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true })
--
--
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {})

vim.keymap.set("n", "<space>fs", function()
  require("telescope.builtin").lsp_document_symbols()
end, {})

vim.keymap.set("n", "<space>fS", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, {})

-- Cursor color
vim.opt.termguicolors = true  -- 이게 없으면 OSC 12 자체가 안 나감

vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor",
  "i-ci-ve:ver25-Cursor",
  "r-cr:hor20-Cursor",
  "o:hor50-Cursor",
  "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
}, ",")


vim.api.nvim_set_hl(0, "Cursor", { fg = "#fdf6e3", bg = "#cb4b16" })

-- Tab
vim.opt.tabstop = 4       -- 탭 문자 하나가 화면에서 차지하는 폭
vim.opt.shiftwidth = 4    -- >>, << 같은 자동 들여쓰기 폭
vim.opt.softtabstop = 4   -- Tab/Backspace 키 누를 때 이동하는 칸 수
vim.opt.expandtab = true  -- Tab 키 입력 시 실제로는 space로 변환 (탭 문자 대신)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
  end,
})
