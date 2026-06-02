{ utils, ... }:
let
  inherit (utils) mkMap;
in
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
    (mkMap "n" "<leader>cg" "<cmd>CMakeGenerate<CR>" "CMake generate")
    (mkMap "n" "<leader>cb" "<cmd>CMakeBuild<CR>" "CMake build")
    (mkMap "n" "<leader>cr" "<cmd>CMakeRun<CR>" "CMake run")
  ];
}
