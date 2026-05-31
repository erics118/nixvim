# Shortcuts

## Copy / Paste

> All yanks/pastes use the system clipboard automatically (`clipboard=unnamedplus`).

### Yank

| Key   | Action              |
|-------|---------------------|
| `yy`  | Yank line           |
| `yw`  | Yank word           |
| `yiw` | Yank inner word     |
| `y$`  | Yank to end of line |
| `Y`   | Yank to end of line |
| `yG`  | Yank to end of file |

### Paste

| Key | Action               |
|-----|----------------------|
| `p` | Paste after cursor   |
| `P` | Paste before cursor  |

### Registers

| Key    | Action                              |
|--------|-------------------------------------|
| `"ayy` | Yank line into register `a`         |
| `"ap`  | Paste from register `a`             |
| `"0p`  | Paste last yank (ignores deletes)   |
| `:reg` | Show all registers                  |



## Nvim-tree

| Key      | Action                                  |
|----------|-----------------------------------------|
| `<C-b>`  | Toggle file tree                        |
| `l`      | Open file / expand folder               |
| `h`      | Collapse folder                         |
| `<CR>`   | Open file / expand folder               |
| `v`      | Open in vertical split                  |
| `s`      | Open in horizontal split                |
| `<Tab>`  | Preview (without moving cursor)         |
| `a`      | Create file/folder (end name with `/`)  |
| `d`      | Delete                                  |
| `r`      | Rename                                  |
| `x`      | Cut                                     |
| `c`      | Copy                                    |
| `p`      | Paste                                   |
| `y`      | Copy filename                           |
| `Y`      | Copy relative path                      |
| `gy`     | Copy absolute path                      |
| `R`      | Refresh tree                            |
| `H`      | Toggle hidden files                     |
| `I`      | Toggle gitignored files                 |
| `f`      | Filter/search                           |
| `W`      | Collapse all                            |
| `q`      | Close tree                              |
| `g?`     | Show all keymaps                        |

## Treesitter

| Key         | Action                                      |
|-------------|---------------------------------------------|
| `]f` / `[f` | Next / prev function                        |
| `]c` / `[c` | Next / prev class                           |
| `af` / `if` | Around / inside function (text object)      |
| `ac` / `ic` | Around / inside class (text object)         |
| `aa` / `ia` | Around / inside parameter (text object)     |
| `ab` / `ib` | Around / inside block (text object)         |
| `zi`        | Toggle folding                              |
| `zc`        | Close fold                                  |
| `zo`        | Open fold                                   |
| `za`        | Toggle fold                                 |
| `zR`        | Open all folds                              |
| `zM`        | Close all folds                             |
| `:InspectTree` | View treesitter parse tree              |

## Jumping (flash.nvim)

| Key    | Mode            | Action                                          |
|--------|-----------------|-------------------------------------------------|
| `s`    | normal/visual/op| Jump anywhere by typing 1-2 chars + label       |
| `S`    | normal/visual/op| Jump to treesitter node                         |
| `r`    | op-pending      | Remote flash — apply operator at distant target |
| `R`    | visual/op       | Treesitter search jump                          |
| `<C-f>`| command         | Toggle flash in `/` search                      |

Labels use: `a s d f g h j k l q w e r u i o p z x c v b n m`

## General jumping

| Key          | Action                        |
|--------------|-------------------------------|
| `gg` / `G`   | Top / bottom of file          |
| `{` / `}`    | Jump between blank-line blocks |
| `<C-o>`      | Jump back in jump list        |
| `<C-i>`      | Jump forward in jump list     |
| `'.`         | Jump to last change           |
| `gi`         | Jump to last insert location  |
