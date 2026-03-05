vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- _____ OPTIONS _____

vim.o.background = "dark"
vim.o.confirm = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.grepprg = "rg --vimgrep"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.ignorecase = true
vim.o.laststatus = 2
vim.o.list = true
vim.o.matchpairs = "(:),{:},[:],<:>"
vim.o.mouse = "a"
vim.o.number = true
vim.o.path = ".,,**"
vim.o.scrolloff = 10
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.sidescrolloff = 5
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.statuscolumn = "%s%C%l  "
vim.o.termguicolors = true
vim.o.timeoutlen = 300
vim.o.title = true
vim.o.titlestring = "Neovim"
vim.o.undofile = true
vim.o.updatetime = 500
vim.o.winborder = "rounded"
vim.o.wrap = false

vim.opt.listchars = {
  extends = "»",
  precedes = "«",
  tab = "▏ ",
  trail = "·",
}

if vim.fn.executable("wl-copy") == 1 then
  vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
  end)
else
  error("ERR: wl-clipboard is not installed.")
end

-- _____ PLUGINS _____

require("mini.icons").setup()

do
  local onedark = require("onedark")
  onedark.setup({
    style = "warm",
  })
  onedark.load()

  vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
end

require("lz.n").load({
  {
    "blink.cmp",
    event = { "BufNewFile", "BufRead" },
    after = function()
      require("blink.cmp").setup({
        completion = { documentation = { auto_show = true } },
        signature = { enabled = true },
      })
    end,
  },
  {
    "conform.nvim",
    event = { "BufNewFile", "BufRead" },
    after = function()
      require("conform").setup({
        formatters_by_ft = {
          c = { "clang-format" },
          lua = { "stylua" },
          nix = { "nixfmt" },
          ["*"] = { "trim_newlines", "trim_whitespace" },
        },
        format_on_save = {
          lsp_format = "fallback",
          timeout_ms = 500,
        },
      })
    end,
  },
  {
    "mini.clue",
    event = "DeferredUIEnter",
    after = function()
      require("mini.clue").setup({
        triggers = {
          { mode = "n", keys = "<leader>" },
          { mode = "x", keys = "<leader>" },
        },
        clues = {
          { mode = "n", keys = "<leader>b", desc = "+Buffers" },
          { mode = "n", keys = "<leader>c", desc = "+Code" },
          { mode = "n", keys = "<leader>d", desc = "+Diagnostics" },
          { mode = "n", keys = "<leader>f", desc = "+File" },
          { mode = "n", keys = "<leader>h", desc = "+Help" },
          { mode = "n", keys = "<leader>l", desc = "+LSP" },
          { mode = "n", keys = "<leader>n", desc = "+Notes" },
          { mode = "n", keys = "<leader>t", desc = "+Terminal" },
          { mode = "n", keys = "<leader>v", desc = "+Vim" },
          { mode = "n", keys = "<leader>w", desc = "+Window" },
        },
        window = { delay = vim.o.timeoutlen },
      })
    end,
  },
  {
    "nvim-autopairs",
    event = "InsertEnter",
    after = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    after = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "oil.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        float = {
          padding = 0,
          max_width = 0.5,
          max_height = 0.5,
        },
        keymaps = {
          ["<C-p>"] = "actions.preview",
          ["<C-r>"] = { "actions.refresh", mode = "n" },
          ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-v>"] = { "actions.select", opts = { vertical = true } },
          ["<CR>"] = "actions.select",
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g?"] = { "actions.show_help", mode = "n" },
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              Detail = not Detail
              if Detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
            mode = "n",
          },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gt"] = { "actions.toggle_trash", mode = "n" },
          ["gx"] = "actions.open_external",
          ["h"] = { "actions.parent", mode = "n" },
          ["l"] = "actions.select",
          ["q"] = { "actions.close", mode = "n" },
        },
      })
    end,
  },
})

require("nvim-treesitter.configs").setup({
  auto_install = false,
  highlight = { enable = true, disable = { "xml" } },
})

-- _____ KEYBINDS _____

vim.keymap.set("i", "jk", "<esc>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Window" })
vim.keymap.set("n", "<leader>ff", "<cmd>Oil --float<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", ":grep! ", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fq", "<cmd>quit<cr>", { desc = "Quit File" })
vim.keymap.set("n", "<leader>fs", "<cmd>update<cr>", { desc = "Save File" })
vim.keymap.set("n", "<leader>hh", ":help ", { desc = "Help" })
vim.keymap.set("n", "<leader>hm", ":Man ", { desc = "Man Pages" })
vim.keymap.set("n", "<leader>ve", "<cmd>edit $MYVIMRC<cr>", { desc = "Edit Config File" })
vim.keymap.set(
  "n",
  "<leader>vr",
  "<cmd>update<cr><cmd>source $MYVIMRC<cr>",
  { desc = "Reload Config File" }
)
vim.keymap.set("n", "<leader>vq", "<cmd>quitall<cr>", { desc = "Exit Neovim" })
vim.keymap.set("n", "<leader>wm", "<cmd>only<cr>", { desc = "Maximise Window" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>wh", "<C-w><S-h>", { desc = "Move Left" })
vim.keymap.set("n", "<leader>wj", "<C-w><S-j>", { desc = "Move Down" })
vim.keymap.set("n", "<leader>wk", "<C-w><S-k>", { desc = "Move Up" })
vim.keymap.set("n", "<leader>wl", "<C-w><S-l>", { desc = "Move Right" })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { noremap = true })

-- _____ AUTO COMMANDS _____

vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "ledger" },
  callback = function()
    vim.bo.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "ledger",
  callback = function(args)
    vim.keymap.set(
      "n",
      "<leader>cf",
      "<cmd>LedgerAlignBuffer<cr>",
      { desc = "Format File", buffer = args.buf }
    )
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- TERMINAL

local terminal = {
  buf = -1,
  win = -1,
}

local function toggle_terminal()
  if not vim.api.nvim_buf_is_valid(terminal.buf) then
    terminal.buf = vim.api.nvim_create_buf(false, true)
  end

  if not vim.api.nvim_win_is_valid(terminal.win) then
    terminal.win = vim.api.nvim_open_win(terminal.buf, true, {
      height = math.floor(vim.o.lines * 0.25),
      split = "below",
    })

    if vim.bo[terminal.buf].buftype ~= "terminal" then
      vim.cmd.term()
      vim.cmd.startinsert()
    end
  else
    vim.api.nvim_win_close(terminal.win, false)
  end
end

vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Toggle Terminal" })

-- _____ NOTES _____

vim.keymap.set(
  "n",
  "<leader>na",
  "<cmd>edit $HOME/documents/gtd/areas<cr>",
  { desc = "Areas Folder" }
)
vim.keymap.set(
  "n",
  "<leader>ni",
  "<cmd>edit $HOME/documents/gtd/inbox.md<cr>",
  { desc = "Inbox File" }
)
vim.keymap.set(
  "n",
  "<leader>nl",
  "<cmd>edit $HOME/documents/gtd/logs<cr>",
  { desc = "Logs Folder" }
)
vim.keymap.set(
  "n",
  "<leader>nn",
  "<cmd>edit $HOME/documents/gtd/next.md<cr>",
  { desc = "Next File" }
)
vim.keymap.set(
  "n",
  "<leader>np",
  "<cmd>edit $HOME/documents/gtd/projects<cr>",
  { desc = "Projects Folder" }
)
vim.keymap.set(
  "n",
  "<leader>ns",
  "<cmd>edit $HOME/documents/gtd/someday<cr>",
  { desc = "Someday Folder" }
)

-- _____ LSP _____

vim.diagnostic.config({
  signs = false,
  severity_sort = true,
  virtual_text = true,
})

do
  local sign = function(opts)
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = "",
    })
  end

  sign({ name = "DiagnosticSignError", text = "󰅙" })
  sign({ name = "DiagnosticSignWarn", text = "" })
  sign({ name = "DiagnosticSignInfo", text = "󰋼" })
  sign({ name = "DiagnosticSignHint", text = "󰌵" })
end

vim.lsp.config("lua_ls", {
  settings = {
    Lua = { telemetry = { enable = false } },
  },
  on_init = function(client)
    local join = vim.fs.joinpath
    local path = client.workspace_folders[1].name

    if vim.uv.fs_stat(join(path, ".luarc.json")) or vim.uv.fs_stat(join(path, ".luarc.jsonc")) then
      return
    end

    local nvim_settings = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = {
          "MiniIcons",
          "augroup",
          "vim",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
    }

    client.config.settings.Lua =
      vim.tbl_deep_extend("force", client.config.settings.Lua, nvim_settings)
  end,
})

do
  local host = vim.uv.os_gethostname()
  local flake = "(builtins.getFlake \"" .. os.getenv("HOME") .. "/dotfiles\")"

  vim.lsp.config("nixd", {
    cmd = { "nixd", "--log=error" },
    settings = {
      nixd = {
        nixpkgs = {
          expr = "import " .. flake .. ".inputs.nixpkgs { }",
        },
        options = {
          nixos = {
            expr = flake .. ".nixosConfigurations." .. host .. ".options",
          },
          ["home-manager"] = {
            expr = flake
              .. ".homeConfigurations.\""
              .. os.getenv("USER")
              .. "@"
              .. host
              .. "\".options",
          },
        },
      },
    },
  })
end

vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("nixd")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local lsp = vim.lsp.buf

    vim.keymap.set("n", "<leader>lD", lsp.declaration, { desc = "Declaration", buffer = args.buf })
    vim.keymap.set("n", "<leader>la", lsp.code_action, { desc = "Code Action", buffer = args.buf })
    vim.keymap.set("n", "<leader>ld", lsp.definition, { desc = "Definition", buffer = args.buf })
    vim.keymap.set(
      "n",
      "<leader>li",
      lsp.implementation,
      { desc = "Implementation", buffer = args.buf }
    )
    vim.keymap.set("n", "<leader>lk", lsp.hover, { desc = "Documentation", buffer = args.buf })
    vim.keymap.set("n", "<leader>ln", lsp.rename, { desc = "Rename", buffer = args.buf })
    vim.keymap.set(
      "n",
      "<leader>lo",
      lsp.type_definition,
      { desc = "Type Definition", buffer = args.buf }
    )
    vim.keymap.set("n", "<leader>lr", lsp.references, { desc = "References", buffer = args.buf })
    vim.keymap.set("n", "<leader>ls", lsp.signature_help, { desc = "Signature", buffer = args.buf })

    vim.keymap.set("n", "<leader>dn", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "Next Diagnostic", buffer = args.buf })

    vim.keymap.set("n", "<leader>dp", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "Previous Diagnostic", buffer = args.buf })
  end,
})

-- _____ STATUSLINE _____

local status_hl = function(text, hl)
  return "%#" .. hl .. "#" .. text .. "%#StatusLine#"
end

local status_name = function()
  local search = ""
  local field = ""

  if vim.o.buftype == "help" then
    search = "help"
    field = "help"
  elseif vim.o.buftype == "terminal" then
    search = "bash"
    field = "terminal"
  else
    local filetype, _ = vim.filetype.match({ buf = 0 })
    if filetype then
      search = filetype
    end
    field = "%f"
  end

  local icon, hl, _ = MiniIcons.get("filetype", search)
  return " " .. status_hl(icon, hl) .. " " .. field
end

local status_modified = function()
  if vim.bo.modified then
    return status_hl("  󰷫", "Comment")
  else
    return ""
  end
end

local status_readonly = function()
  if vim.bo.readonly then
    return status_hl("  󰌾", "Comment")
  else
    return ""
  end
end

local status_lsp = function()
  local results = {
    errors = 0,
    warnings = 0,
    info = 0,
    hints = 0,
  }
  local entries = vim.diagnostic.get(0, {})

  for _, entry in ipairs(entries) do
    if entry.severity == vim.diagnostic.severity.ERROR then
      results.errors = results.errors + 1
    elseif entry.severity == vim.diagnostic.severity.WARN then
      results.warnings = results.warnings + 1
    elseif entry.severity == vim.diagnostic.severity.INFO then
      results.info = results.info + 1
    elseif entry.severity == vim.diagnostic.severity.HINT then
      results.hints = results.hints + 1
    end
  end

  local errors = ""
  local warnings = ""
  local info = ""
  local hints = ""

  if results.errors ~= 0 then
    errors = "󰅙 " .. results.errors .. " "
  end
  if results.warnings ~= 0 then
    warnings = " " .. results.warnings .. " "
  end
  if results.info ~= 0 then
    info = "󰋼 " .. results.info .. " "
  end
  if results.hints ~= 0 then
    hints = "󰌵 " .. results.hints .. " "
  end

  return errors .. warnings .. info .. hints .. "  "
end

local status_pos = function()
  return status_hl("%l:%c ", "Comment")
end

vim.api.nvim_create_autocmd(
  { "BufEnter", "BufModifiedSet", "DiagnosticChanged", "TermEnter", "WinEnter" },
  {
    callback = function()
      vim.wo.statusline = status_name()
        .. status_modified()
        .. status_readonly()
        .. "%="
        .. status_lsp()
        .. status_pos()
    end,
  }
)
