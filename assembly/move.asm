.data
    .align 2
    gd_matrix: .space 64          # 16 words (4x4 board)

    .eqv UP    0
    .eqv DOWN  1
    .eqv LEFT  2
    .eqv RIGHT 3

.text
.globl move

# ==============================================================================
# int move(int direction)
#   $a0 = direction
#   Returns: points in $v0 (or -1 if no tiles moved/merged)
# ==============================================================================
move_direction:
    addi $sp, $sp, -40
    sw   $ra, 36($sp)
    sw   $s0, 32($sp)             # $s0 = direction
    sw   $s1, 28($sp)             # $s1 = points
    sw   $s2, 24($sp)             # $s2 = did_work (0 or 1)
    sw   $s3, 20($sp)             # $s3 = loop counter i (0..3)
    # 0($sp)..15($sp) reserved for local int line[4]

    move $s0, $a0
    li   $s1, 0                   # points = 0
    li   $s2, 0                   # did_work = False
    li   $s3, 0                   # i = 0

move_loop:
    bge  $s3, 4, move_end_loop

    # get_line(i, direction, line)
    move $a0, $s3
    move $a1, $s0
    addi $a2, $sp, 0              # &line[0]
    jal  get_line

    # line_points = slide_merge_line(line)
    addi $a0, $sp, 0              # &line[0]
    jal  slide_merge_line         # returns line_points in $v0

    beq  $v0, -1, move_skip_add   # if line_points != -1:
    li   $s2, 1                   #     did_work = True
    add  $s1, $s1, $v0            #     points += line_points

move_skip_add:
    # set_line(i, direction, line)
    move $a0, $s3
    move $a1, $s0
    addi $a2, $sp, 0              # &line[0]
    jal  set_line

    addi $s3, $s3, 1
    j    move_loop

move_end_loop:
    beq  $s2, $zero, move_no_work
    move $v0, $s1                 # return points
    j    move_exit

move_no_work:
    li   $v0, -1                  # return -1

move_exit:
    lw   $s3, 20($sp)
    lw   $s2, 24($sp)
    lw   $s1, 28($sp)
    lw   $s0, 32($sp)
    lw   $ra, 36($sp)
    addi $sp, $sp, 40
    jr   $ra


# ==============================================================================
# void _line_positions(int i, int direction, int positions[4])
#   $a0 = i, $a1 = direction, $a2 = base address of positions[4]
#   Populates positions[0..3] with board indices (0..15)
# ==============================================================================
_line_positions:
    li   $t0, 0                   # $t0 = k (row or column index, 0..3)

    beq  $a1, UP,    pos_up
    beq  $a1, DOWN,  pos_down
    beq  $a1, LEFT,  pos_left
    beq  $a1, RIGHT, pos_right
    jr   $ra                      # default case: return immediately

pos_up:
    # [(3 - row) * 4 + i for row in range(4)]
    bge  $t0, 4, pos_done
    li   $t1, 3
    sub  $t1, $t1, $t0            # 3 - row
    sll  $t1, $t1, 2              # (3 - row) * 4
    add  $t1, $t1, $a0            # + i
    sll  $t2, $t0, 2              # byte offset = k * 4
    add  $t2, $a2, $t2
    sw   $t1, 0($t2)
    addi $t0, $t0, 1
    j    pos_up

pos_down:
    # [row * 4 + i for row in range(4)]
    bge  $t0, 4, pos_done
    sll  $t1, $t0, 2              # row * 4
    add  $t1, $t1, $a0            # + i
    sll  $t2, $t0, 2
    add  $t2, $a2, $t2
    sw   $t1, 0($t2)
    addi $t0, $t0, 1
    j    pos_down

pos_left:
    # [i * 4 + (3 - column) for column in range(4)]
    bge  $t0, 4, pos_done
    sll  $t1, $a0, 2              # i * 4
    li   $t3, 3
    sub  $t3, $t3, $t0            # 3 - column
    add  $t1, $t1, $t3            # i * 4 + (3 - column)
    sll  $t2, $t0, 2
    add  $t2, $a2, $t2
    sw   $t1, 0($t2)
    addi $t0, $t0, 1
    j    pos_left

pos_right:
    # [i * 4 + column for column in range(4)]
    bge  $t0, 4, pos_done
    sll  $t1, $a0, 2              # i * 4
    add  $t1, $t1, $t0            # + column
    sll  $t2, $t0, 2
    add  $t2, $a2, $t2
    sw   $t1, 0($t2)
    addi $t0, $t0, 1
    j    pos_right

pos_done:
    jr   $ra


# ==============================================================================
# void get_line(int i, int direction, int line[4])
#   $a0 = i, $a1 = direction, $a2 = base address of line[4]
# ==============================================================================
get_line:
    addi $sp, $sp, -24
    sw   $ra, 20($sp)
    sw   $s0, 16($sp)             # save &line[0]
    # 0($sp)..15($sp) reserved for local int positions[4]

    move $s0, $a2
    addi $a2, $sp, 0              # pass &positions[0] in $a2
    jal  _line_positions

    la   $t0, gd_matrix
    li   $t1, 0                   # k = 0

get_line_loop:
    bge  $t1, 4, get_line_done
    sll  $t2, $t1, 2              # k * 4 (byte offset)

    # position = positions[k]
    add  $t3, $sp, $t2
    lw   $t4, 0($t3)

    # value = gd_matrix[position]
    sll  $t4, $t4, 2              # position * 4
    add  $t4, $t0, $t4
    lw   $t5, 0($t4)

    # line[k] = value
    add  $t3, $s0, $t2
    sw   $t5, 0($t3)

    addi $t1, $t1, 1
    j    get_line_loop

get_line_done:
    lw   $s0, 16($sp)
    lw   $ra, 20($sp)
    addi $sp, $sp, 24
    jr   $ra


# ==============================================================================
# void set_line(int i, int direction, int line[4])
#   $a0 = i, $a1 = direction, $a2 = base address of line[4]
# ==============================================================================
set_line:
    addi $sp, $sp, -24
    sw   $ra, 20($sp)
    sw   $s0, 16($sp)             # save &line[0]
    # 0($sp)..15($sp) reserved for local int positions[4]

    move $s0, $a2
    addi $a2, $sp, 0              # pass &positions[0] in $a2
    jal  _line_positions

    la   $t0, gd_matrix
    li   $t1, 0                   # k = 0

set_line_loop:
    bge  $t1, 4, set_line_done
    sll  $t2, $t1, 2              # k * 4 (byte offset)

    # position = positions[k]
    add  $t3, $sp, $t2
    lw   $t4, 0($t3)

    # value = line[k]
    add  $t3, $s0, $t2
    lw   $t5, 0($t3)

    # gd_matrix[position] = value
    sll  $t4, $t4, 2              # position * 4
    add  $t4, $t0, $t4
    sw   $t5, 0($t4)

    addi $t1, $t1, 1
    j    set_line_loop

set_line_done:
    lw   $s0, 16($sp)
    lw   $ra, 20($sp)
    addi $sp, $sp, 24
    jr   $ra