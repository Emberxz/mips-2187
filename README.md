# mips-2187

2048 in base 3, written in MIPS assembly for MARS. Two equal tiles merge into one tile worth 3× as much (3 + 3 → 9, 9 + 9 → 27, …), and reaching 2187 (3^7) wins.

## Layout

| Folder | Owner | What's in it |
| --- | --- | --- |
| `graphics/` | Person 5 | All drawing for the MARS Bitmap Display |

Persons 1–4 will add their own folders for the Python version and the game logic.

## Running the graphics

1. Open `graphics/graphics_test.asm` in MARS.
2. Under **Settings**, check **Assemble all files in directory** and **Initialize Program Counter to global 'main' if defined**.
3. Open **Tools → Bitmap Display** and use these settings:
   - Unit width and height in pixels: 4
   - Display width and height: 512
   - Base address: 0x10040000 (heap)
4. Click **Connect to MIPS**, then Assemble and Run.

`graphics_test.asm` has a sample board, score and high scores. Change those values to test different screens. `graphics.asm` holds the drawing routines; each one is an empty stub with a comment saying what it takes and what it should draw.

## Shared data

Tiles are stored as exponents, not values: 0 = empty, 1 = 3, 2 = 9, … 7 = 2187. The board is 16 words, row by row, so the cell at row r, column c is word `r * 4 + c`. The graphics only read `matrix`, `score`, `theme` and `high_scores`; they never change them.
