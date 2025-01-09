import random

def main():
    # initialize the game grid and list of available moves
    grid = get_grid()
    inputs = list(grid.keys())
    game_in_progress = True
    while game_in_progress:
        # player's move
        need_player_move = True
        while need_player_move:
            player_move = input('Make your move (x,y): ')
            if player_move in inputs:
                inputs.remove(player_move) # remove the move from available inputs
                need_player_move = False
            else: 
                print('Cannot make this move.')
        
        # update grid with player's move and check if the player has won
        grid = update_grid(grid, player_move, 'X')
        player_won = check_win(grid, 'X')
        if player_won:
            print_grid(grid)
            print('You won.')
            break
        
        # check for tie before the computer's move
        if len(inputs) == 0:
            print_grid(grid)
            print('Tie.')
            break
        
        # computer's move
        pc_move = random.choice(inputs)
        inputs.remove(pc_move)
        update_grid(grid, pc_move, 'O')
        pc_won = check_win(grid, 'O')
        if pc_won:
            print_grid(grid)
            print('PC won.')
            break
        else:
            print_grid(grid)


def get_grid():
    # initialize the grid with empty spaces
    return {
        '0,0':' ', '1,0':' ', '2,0':' ', 
        '0,1':' ', '1,1':' ', '2,1':' ', 
        '0,2':' ', '1,2':' ', '2,2':' '
        }

def update_grid(grid, move, symbol):
    # update the grid with the player's or computer's move
    grid[move] = symbol
    return grid

def print_grid(grid):
    # print the current state of the grid
    nums = ' ' * 2 + '0' + ' ' * 3 + '1' + ' ' * 3 + '2'
    row_0 = f"0 {grid['0,0']} | {grid['1,0']} | {grid['2,0']}"
    row_1 = f"1 {grid['0,1']} | {grid['1,1']} | {grid['2,1']}"
    row_2 = f"2 {grid['0,2']} | {grid['1,2']} | {grid['2,2']}"
    line = ' ' + '-' * 11
    grid_str = nums + '\n' + row_0 + '\n' + line + '\n' + row_1 + '\n' + line + '\n' + row_2
    print(grid_str)
    
def check_win(grid, symbol):
    # define all possible winning combinations
    winning_combinations = [
        # horizontal
        ['0,0', '1,0', '2,0'],
        ['0,1', '1,1', '2,1'],
        ['0,2', '1,2', '2,2'],
        # vertical
        ['0,0', '0,1', '0,2'],
        ['1,0', '1,1', '1,2'],
        ['2,0', '2,1', '2,2'],
        # diagonal
        ['0,0', '1,1', '2,2'],
        ['2,0', '1,1', '0,2']
    ]
    # check if any winning combination is met
    for combination in winning_combinations:
        if all(grid[cell] == symbol for cell in combination):
            return True
    return False

# start the game
main()