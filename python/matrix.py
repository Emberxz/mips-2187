# Caleb

import game_data as gd
import random as random

def init_matrix():
    #should intialize the beginning matrix for the game
    #sets score to 0
    #calls spawn_tile() twice
    #returns nothing
    gd.matrix = [0] * 16
    gd.score = 0
    spawn_tile()
    spawn_tile()

def spawn_tile():
    #spawns a new tile equal to either 3 or 9, spawns a 3 9/10 times
    n = count_empty()
    #returns if there are no empty spots
    if n == 0:
        return
    
    kth_empty = rand_range(n)
    empty_count = 0
    new_tile_index = -1
    for i in range(0,16):
        if gd.matrix[i] == 0:
            if empty_count == kth_empty:
                new_tile_index = i
                break
            empty_count += 1
    
    #calulate if we insert a 3 or a 9
    if rand_range(10) < 9:
        gd.matrix[new_tile_index] = 1
    else:
        gd.matrix[new_tile_index] = 2
    
def count_empty():
    #counts numbers of cells equal to 0
    #returns int
    count = 0
    for i in range(0,16):
        if gd.matrix[i] == 0:
            count += 1

    return count 
def rand_range(n):
    #returns a random number 0 - n-1    
    rng = random.randrange(n)

    return rng
