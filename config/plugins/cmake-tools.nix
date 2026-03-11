{
  plugins.cmake-tools = {
    enable = true;
    lazyLoad.settings.cmd = [
      "CMakeGenerate"
      "CMakeBuild"
      "CMakeRun"
      "CMakeClose"
      "CMakeOpen"
      "CMakeSelectBuildType"
      "CMakeSelectBuildTarget"
    ];
    settings = {
      cmake_compile_commands_from_lsp = true;
      cmake_soft_link_compile_commands = false;
      cmake_regenerate_on_save = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cg";
      action = "<cmd>CMakeGenerate<CR>";
      options = {
        noremap = true;
        silent = true;
        desc = "CMake generate";
      };
    }
    {
      mode = "n";
      key = "<leader>cb";
      action = "<cmd>CMakeBuild<CR>";
      options = {
        noremap = true;
        silent = true;
        desc = "CMake build";
      };
    }
    {
      mode = "n";
      key = "<leader>cr";
      action = "<cmd>CMakeRun<CR>";
      options = {
        noremap = true;
        silent = true;
        desc = "CMake run";
      };
    }
  ];
}
