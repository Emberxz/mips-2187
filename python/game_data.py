# --------------------------------- 
# This stores global vars
# Imported into each file as gd
# Access vars using gd.theVariable
# ---------------------------------

# ---- gd.matrix ----
# "What it holds: The board, flat. Cell at row r, column c is gd.matrix[r * 4 + c]"
matrix = list(range(16))

# ---- gd.score ----
 # "What it holds: The board, flat. Cell at row r, column c is gd.matrix[r * 4 + c]"
score = 0 

# ---- gd.theme ----
# "What it holds: Current color theme", initialized to 0. 0 is Home Game theme, 1 is Away Game theme.
theme = 0  

# ---- high_scores ----
#"What it holds: Top 5 scores, highest first". Initilized to all 0's. Descending order must be maintained
high_scores = list(range(5)) 

# ---- gd.pow3 ----
 # "What it holds: index to value conversion - so points never need a power function".
 # To get the value of a cell in memory, do gd.pow3[cellVal] ---> ex: gd.pow3[3] = 3^3 = 27 
pow3 = [0, 3, 9, 27, 81, 243, 729, 2187]

# --------- Constants ---------

# Key input directions (enumeration where gd.LEFT=0, gd.RIGHT=1, gd.UP=2, gd.DOWN=3)
LEFT = 0
RIGHT = 1
UP = 2
DOWN = 3

# These are the game states - results of check_mat(),  (eunmeration where gd.CONTINUE=0, gd.WIN=1, gd.LOSS=2)
CONTINUE = 0
WIN = 1
LOSS = 2
