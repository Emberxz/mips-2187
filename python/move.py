# Jacob & Phillip
import game_data as gd

# Jacob's part
def move(direction):
    return 0 
def get_line(i,direction,line):
    return 0 
def set_line(i,direction,line):
    return 0 

# Phillip
def slide_merge_line(line):
    did_work = 0 
    did_work |= compress_line(line)
    points = merge_line(line)
    did_work |= points
    did_work |= compress_line(line)
    return points if did_work > 0 else -1

def compress_line(line):
    # only loop through first three, last one will never slide
    did_compress = 0 
    i = 2
    while (i >= 0):
        j = i
        while j < 3 and line[j] != 0 and line[j + 1] == 0:
            line[j + 1] = line[j]
            line[j] = 0
            did_compress = 1
            j += 1
        i -= 1
    return did_compress

def merge_line(line):
    # only loop through first three, last one will never slide
    points = 0
    i = 0
    while (i < 3):
        if line[i] != 0 and line[i] == line[i + 1]:
            line[i+1] += 1
            line[i] = 0
            points += gd.pow3[line[i + 1]]
            i += 1 # skip newly merged block
        i += 1

    return points
