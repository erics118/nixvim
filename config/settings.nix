{
  # respect .editorconfig files
  editorconfig.enable = true;

  opts = {
    # enable mouse support
    mouse = "a";

    # show line numbers
    number = true;
    relativenumber = true;

    # use system clipboard
    clipboard = "unnamedplus";

    # scroll offsets
    scrolloff = 5;
    sidescrolloff = 15;

    # always show status
    laststatus = 3;

    # always show tab line (bufferline)
    showtabline = 0;

    # completion height
    pumheight = 15;

    # hide command line unless needed
    cmdheight = 0;

    # split directions
    splitbelow = true;
    splitright = true;
    wrap = false;
    ignorecase = true;
    smartcase = true;

    # word boundaries
    iskeyword = "@,48-57,_,192-255";

    # tab settings
    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;

    # always show 1 column of sign column (gitsigns, etc.)
    signcolumn = "yes:1";

    # true colors
    termguicolors = true;
  };

  # Custom border characters (rounded)
  extraConfigLua = ''
    vim.g.bc = {
      style = "rounded",
      vert = "│",
      vertleft = "┤",
      vertright = "├",
      horiz = "─",
      horizup = "┴",
      horizdown = "┬",
      verthoriz = "┼",
      topleft = "╭",
      topright = "╮",
      botleft = "╰",
      botright = "╯"
    }

    vim.opt.fillchars:append({
      horiz = vim.g.bc.horiz,
      horizup = vim.g.bc.horizup,
      horizdown = vim.g.bc.horizdown,
      vert = vim.g.bc.vert,
      vertright = vim.g.bc.vertright,
      vertleft = vim.g.bc.vertleft,
      verthoriz = vim.g.bc.verthoriz
    })
  '';

  # Per-filetype indentation using vimscript ftplugin
  extraConfigVim = ''
    " Disable recommended style overrides
    let g:yaml_recommended_style = 0

    " 2-space indentation for web/config languages
    augroup filetype_indent
      autocmd!
      autocmd FileType yaml,json,jsonc setlocal shiftwidth=2 tabstop=2 softtabstop=2
      autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal shiftwidth=2 tabstop=2 softtabstop=2
      autocmd FileType ocaml,html,css,scss setlocal shiftwidth=2 tabstop=2 softtabstop=2
      autocmd FileType nix,lua setlocal shiftwidth=2 tabstop=2 softtabstop=2
    augroup END
  '';
}
