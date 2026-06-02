{
  lib,
  utils,
  isDarwin,
  ...
}:
let
  inherit (utils) mkMap;

  # On macOS Alt is consumed by the WM, so use <leader>b... for non-digit
  # bufferline ops. Digits use <C-N> on all platforms (modern terminals
  # support it via the kitty/CSI-u keyboard protocol).
  bufKey = suffix: if isDarwin then "<leader>b${suffix}" else "<A-${suffix}>";

  bufferGoTo =
    lib.genList (
      i:
      let
        n = toString (i + 1);
      in
      mkMap "n" "<C-${n}>" "<Cmd>BufferLineGoToBuffer ${n}<CR>" "Go to buffer ${n}"
    ) 9
    ++ [ (mkMap "n" "<C-0>" "<Cmd>BufferLineGoToBuffer -1<CR>" "Go to last buffer") ];
in
{
  globals = {
    mapleader = " ";
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  keymaps = [
    # Split navigation
    (mkMap "n" "<C-J>" "<C-W>j" "Move to window below")
    (mkMap "n" "<C-K>" "<C-W>k" "Move to window above")
    (mkMap "n" "<C-L>" "<C-W>l" "Move to window right")
    (mkMap "n" "<C-H>" "<C-W>h" "Move to window left")
    (mkMap "n" "<C-W>\\" ":vsplit<CR>" "Vertical split")
    (mkMap "n" "<C-W>-" ":split<CR>" "Horizontal split")
    (mkMap "n" "<C-W>x" ":q<CR>" "Close window")

    # Diff/merge
    (mkMap "n" "gdh" ":diffget //2<CR>" "Get diff from left (ours)")
    (mkMap "n" "gdl" ":diffget //3<CR>" "Get diff from right (theirs)")

    # Terminal
    (mkMap "t" "<Esc>" "<C-\\><C-n>" "Exit terminal mode")

    # Clear search highlight
    (mkMap "n" "<Esc>" ":nohlsearch<CR>" "Clear search highlight")

    # Search and replace
    (mkMap "n" "<leader>sr" "<cmd>GrugFar<CR>" "Search and replace")

    # Centered scrolling/search
    (mkMap "n" "<C-d>" "<C-d>zz" "Scroll down and center")
    (mkMap "n" "<C-u>" "<C-u>zz" "Scroll up and center")
    (mkMap "n" "n" "nzzzv" "Next search result and center")
    (mkMap "n" "N" "Nzzzv" "Previous search result and center")

    # NvimTree
    (mkMap "n" "<C-b>" ":NvimTreeToggle<CR>" "Toggle file tree")

    # Bufferline cycle / move
    (mkMap "n" (bufKey ",") "<Cmd>BufferLineCyclePrev<CR>" "Previous buffer")
    (mkMap "n" (bufKey ".") "<Cmd>BufferLineCycleNext<CR>" "Next buffer")
    (mkMap "n" (bufKey "<") "<Cmd>BufferLineMovePrev<CR>" "Move buffer left")
    (mkMap "n" (bufKey ">") "<Cmd>BufferLineMoveNext<CR>" "Move buffer right")
  ]
  ++ bufferGoTo
  ++ [
    (mkMap "n" (bufKey "p") "<Cmd>BufferLineTogglePin<CR>" "Pin/unpin buffer")
    (mkMap "n" (bufKey "x") "<Cmd>bdelete<CR>" "Close buffer")
    (mkMap "n" (bufKey "X") "<Cmd>bdelete!<CR>" "Force close buffer")
    (mkMap "n" (bufKey "c") "<Cmd>enew<CR>" "Create new buffer")
    (mkMap "n" (bufKey "<space>") "<Cmd>BufferLinePick<CR>" "Pick buffer")
    (mkMap "n" "<leader>bd" "<Cmd>BufferLineSortByDirectory<CR>" "Sort buffers by directory")
    (mkMap "n" "<leader>bl" "<Cmd>BufferLineSortByExtension<CR>" "Sort buffers by extension")
  ];
}
