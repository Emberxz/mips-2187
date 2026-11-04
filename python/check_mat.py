# Caleb

import game_data as gd

def check_mat():
    #checks the matrix if win/loss/ possible moves
    if has_2187():
        return gd.WIN
    if not can_move():
        return gd.LOSS
    
    return gd.CONTINUE
def has_2187():
    #checks if any cell has value 2187, returns true/false
    for i in range(16):
        if gd.matrix[i] == gd.WIN_EXP:
            return True
    return False
def can_move():
    #checks if there are any possible moves / hasn't loss
    #returns true if any cell is 0 or if anything can still be merged
    for i in range(16):
        if gd.matrix[i] == 0:
            return True
        #checking right neighbors, not checking last column since it doesn't have a right neighbor
        if i % 4 < 3:
            if gd.matrix[i] == gd.matrix[i+1]:
                return True    
        
        #checking below neighbors, not checking bottom column since it doesn't have a below neighbor
        if i < 12:
            if gd.matrix[i] == gd.matrix[i+4]:
                return True
    
    #dont need to check left or above neighbors as it would be overlapping these checks
    return False