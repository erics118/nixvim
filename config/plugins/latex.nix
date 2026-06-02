{
  globals.tex_flavor = "latex";

  filetype.extension.tex = "tex";

  plugins.vimtex = {
    enable = true;

    texlivePackage = null;

    lazyLoad.settings.ft = [
      "tex"
    ];
    mupdfPackage = null;
    pstreePackage = null;
    settings = {
      compiler_method = "latexmk";
      quickfix_mode = 0;
      view_method = "sioyek";
    };
  };

  plugins.cmp-vimtex = {
    enable = true;
    lazyLoad.settings.ft = [
      "tex"
    ];
  };
}
