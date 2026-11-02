# Jacob & Phillip
import game_data as gd

# Jacob's part

#gd.matrix[r * 4 + c]
def move(direction):
    points = 0
    did_work = False
    for i in range(4):
        line = get_line(i, direction, [])
        line_points = slide_merge_line(line)
        if line_points != -1:
            did_work = True
            points += line_points
        set_line(i, direction, line)

    return points if did_work > 0 else -1


def _line_positions(i, direction):
    match direction:
        case gd.UP:
            return [(3 - row) * 4 + i for row in range(4)]
        case gd.DOWN:
            return [row * 4 + i for row in range(4)]
        case gd.LEFT:
            return [i * 4 + (3 - column) for column in range(4)]
        case gd.RIGHT:
            return [i * 4 + column for column in range(4)]
        case _:
            return []


def get_line(i,direction,line):
    line[:] = [gd.matrix[position] for position in _line_positions(i, direction)]
    return line


def set_line(i,direction,line):
    for position, value in zip(_line_positions(i, direction), line):
        gd.matrix[position] = value


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
