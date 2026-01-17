{ lib, ... }:
let
  # Helper to create a simple keymap
  map = mode: key: action: desc: {
    inherit mode key action;
    options = {
      noremap = true;
      silent = true;
      inherit desc;
    };
  };

  # Generate Alt+N buffer keymaps (1-9 and 0 for last)
  bufferGoTo =
    lib.genList (
      i:
      let
        n = toString (i + 1);
      in
      map "n" "<A-${n}>" "<Cmd>BufferLineGoToBuffer ${n}<CR>" "Go to buffer ${n}"
    ) 9
    ++ [ (map "n" "<A-0>" "<Cmd>BufferLineGoToBuffer -1<CR>" "Go to last buffer") ];
in
{
  globals = {
    mapleader = " ";
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  keymaps =
    # Split navigation
    [
      (map "n" "<C-J>" "<C-W>j" "Move to window below")
      (map "n" "<C-K>" "<C-W>k" "Move to window above")
      (map "n" "<C-L>" "<C-W>l" "Move to window right")
      (map "n" "<C-H>" "<C-W>h" "Move to window left")
      (map "n" "<C-W>\\" ":vsplit<CR>" "Vertical split")
      (map "n" "<C-W>-" ":split<CR>" "Horizontal split")
      (map "n" "<C-W>x" ":q<CR>" "Close window")
    ]
    # Diff/merge
    ++ [
      {
        mode = "n";
        key = "gd";
        action = ":diffget";
        options.noremap = true;
        options.silent = true;
      }
      (map "n" "gdh" ":diffget //2<CR>" "Get diff from left (ours)")
      (map "n" "gdl" ":diffget //3<CR>" "Get diff from right (theirs)")
    ]
    # Terminal
    ++ [ (map "t" "<Esc>" "<C-\\><C-n>" "Exit terminal mode") ]
    # Centered scrolling/search
    ++ [
      (map "n" "<C-d>" "<C-d>zz" "Scroll down and center")
      (map "n" "<C-u>" "<C-u>zz" "Scroll up and center")
      (map "n" "n" "nzzzv" "Next search result and center")
      (map "n" "N" "Nzzzv" "Previous search result and center")
    ]
    # NvimTree
    ++ [ (map "n" "<C-b>" ":NvimTreeToggle<CR>" "Toggle file tree") ]
    # Bufferline
    ++ [
      (map "n" "<A-,>" "<Cmd>BufferLineCyclePrev<CR>" "Previous buffer")
      (map "n" "<A-.>" "<Cmd>BufferLineCycleNext<CR>" "Next buffer")
      (map "n" "<A-<>" "<Cmd>BufferLineMovePrev<CR>" "Move buffer left")
      (map "n" "<A->>" "<Cmd>BufferLineMoveNext<CR>" "Move buffer right")
    ]
    ++ bufferGoTo
    ++ [
      (map "n" "<A-p>" "<Cmd>BufferLineTogglePin<CR>" "Pin/unpin buffer")
      (map "n" "<A-x>" "<Cmd>bdelete<CR>" "Close buffer")
      (map "n" "<A-X>" "<Cmd>bdelete!<CR>" "Force close buffer")
      (map "n" "<A-c>" "<Cmd>enew<CR>" "Create new buffer")
      (map "n" "<A-space>" "<Cmd>BufferLinePick<CR>" "Pick buffer")
      (map "n" "<leader>bd" "<Cmd>BufferLineSortByDirectory<CR>" "Sort buffers by directory")
      (map "n" "<leader>bl" "<Cmd>BufferLineSortByExtension<CR>" "Sort buffers by extension")
    ];
}
