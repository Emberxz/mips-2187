# mips-2187

2048 in base 3, written in MIPS assembly for MARS. Two equal tiles merge into one tile worth 3× as much (3 + 3 → 9, 9 + 9 → 27, …), and reaching 2187 (3^7) wins.

## Layout

| Folder | Owner | What's in it |
| --- | --- | --- |
| `graphics/` | August Basinger | All drawing for the MARS Bitmap Display |
| `xxx/` | x | x |
| `xxx/` | x | x |
| `xxx/` | x | x |
| `xxx/` | x | x |

## Shared data

Tiles are stored as exponents, not values: 0 = empty, 1 = 3, 2 = 9, … 7 = 2187. The board is 16 words, row by row, so the cell at row r, column c is word `r * 4 + c`. The graphics only read `matrix`, `score`, `theme` and `high_scores`; they never change them.
