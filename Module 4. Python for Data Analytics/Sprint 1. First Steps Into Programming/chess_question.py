def main():
    # initialise the chessboard
    board = get_board()
    
    # get and place the white piece on the board
    white = get_pieces(board, is_white=True)
    white_position, white_piece = next(iter(white.items())) 
    
    # get and place the black pieces on the board
    get_pieces(board, is_white=False)
    
    # determine possible moves for the white piece based on its type
    if white_piece == "♘":
        moves = get_knight_moves(white_position)
    elif white_piece == "♖":
        moves = get_rook_moves(white_position, board)
    
    # determine which black pieces can be captured in one move
    captures = [pos for pos in moves if pos in board and board[pos] in {'♟', '♜', '♞', '♝', '♛', '♚'}]
    
    # print the results
    if len(captures) == 0:
        print('The white piece cannot capture any black piece on the board in one move.')
    else:
        print("The white piece can capture the following black pieces in one move:")
        for capture in captures:
            print(f"{board[capture]} at {capture}")


def get_board():
    # create a chessboard with empty spaces
    return {
        'a8': '  ', 'b8': '  ', 'c8': '  ', 'd8': '  ', 'e8': '  ', 'f8': '  ', 'g8': '  ', 'h8': '  ',
        'a7': '  ', 'b7': '  ', 'c7': '  ', 'd7': '  ', 'e7': '  ', 'f7': '  ', 'g7': '  ', 'h7': '  ',
        'a6': '  ', 'b6': '  ', 'c6': '  ', 'd6': '  ', 'e6': '  ', 'f6': '  ', 'g6': '  ', 'h6': '  ',
        'a5': '  ', 'b5': '  ', 'c5': '  ', 'd5': '  ', 'e5': '  ', 'f5': '  ', 'g5': '  ', 'h5': '  ',
        'a4': '  ', 'b4': '  ', 'c4': '  ', 'd4': '  ', 'e4': '  ', 'f4': '  ', 'g4': '  ', 'h4': '  ',
        'a3': '  ', 'b3': '  ', 'c3': '  ', 'd3': '  ', 'e3': '  ', 'f3': '  ', 'g3': '  ', 'h3': '  ',
        'a2': '  ', 'b2': '  ', 'c2': '  ', 'd2': '  ', 'e2': '  ', 'f2': '  ', 'g2': '  ', 'h2': '  ',
        'a1': '  ', 'b1': '  ', 'c1': '  ', 'd1': '  ', 'e1': '  ', 'f1': '  ', 'g1': '  ', 'h1': '  ',
        }
    

def print_board(board):
    # print the chessboard with the current pieces
    letters = ' ' * 3 + 'a' + ' ' * 4 + 'b' + ' ' * 4 + 'c' + ' ' * 4 + 'd' + ' ' * 4 + 'e' + ' ' * 4 + 'f' + ' ' * 4 + 'g' + ' ' * 3 + 'h'
    row_8 = f"8 {board['a8']} | {board['b8']} | {board['c8']} | {board['d8']} | {board['e8']} | {board['f8']} | {board['g8']} | {board['h8']} 8"
    row_7 = f"7 {board['a7']} | {board['b7']} | {board['c7']} | {board['d7']} | {board['e7']} | {board['f7']} | {board['g7']} | {board['h7']} 7"
    row_6 = f"6 {board['a6']} | {board['b6']} | {board['c6']} | {board['d6']} | {board['e6']} | {board['f6']} | {board['g6']} | {board['h6']} 6"
    row_5 = f"5 {board['a5']} | {board['b5']} | {board['c5']} | {board['d5']} | {board['e5']} | {board['f5']} | {board['g5']} | {board['h5']} 5"
    row_4 = f"4 {board['a4']} | {board['b4']} | {board['c4']} | {board['d4']} | {board['e4']} | {board['f4']} | {board['g4']} | {board['h4']} 4"
    row_3 = f"3 {board['a3']} | {board['b3']} | {board['c3']} | {board['d3']} | {board['e3']} | {board['f3']} | {board['g3']} | {board['h3']} 3"
    row_2 = f"2 {board['a2']} | {board['b2']} | {board['c2']} | {board['d2']} | {board['e2']} | {board['f2']} | {board['g2']} | {board['h2']} 2"
    row_1 = f"1 {board['a1']} | {board['b1']} | {board['c1']} | {board['d1']} | {board['e1']} | {board['f1']} | {board['g1']} | {board['h1']} 1"
    line = '  ' + '-' * 37
    print(letters, row_8, line, row_7, line, row_6, line, row_5, line, row_4, line, row_3, line, row_2, line, row_1, letters, sep='\n')


def update_board(board, position, piece):
    # update the board with a new piece at the given position
    board[position] = piece


def get_pieces(board, is_white=False):
    # function to get pieces input until "done" is entered (for black pieces) or a single piece (for white piece)
    if is_white:
        # initialise available pieces and prompt for white piece input
        available_pieces = {'white knight': 1, 'white rook': 1}
        prompt = 'Add the white piece (knight/rook): '
        print_board(board)  # print the board to show the initial state
    else:
        # initialise available pieces and prompt for black pieces input
        available_pieces = {'black pawn': 8, 'black rook': 2, 'black knight': 2, 'black bishop': 2, 'black queen': 1, 'black king': 1}
        prompt = 'Add a black piece (or type "done" to finish): '
    
    # Unicode symbols for the pieces
    unicode_pieces = {
        'black pawn': '♟', 'black rook': '♜', 'black knight': '♞',
        'black bishop': '♝', 'black queen': '♛', 'black king': '♚',
        'white knight': '♘', 'white rook': '♖'
    }

    pieces_dict = {}  # dictionary to store positions of pieces
    
    while True:
        # check if all available pieces are used up
        if not is_white and all(value == 0 for value in available_pieces.values()):
            print("No pieces left.")
            break

        user_input = input(prompt).strip().lower()
        
        # check if the input is 'done' for black pieces
        if not is_white and user_input == 'done':
            if len(pieces_dict) == 0:
                print('Add at least one black piece.')
                continue
            break
        
        try:
            # split the input into piece and position
            piece, position = user_input.split()
        except ValueError:
            print("Invalid input. Please enter in the format 'piece position' (e.g., 'knight f6').")
            continue
        
        if is_white:
            piece = f'white {piece}'  # prefix 'white' for white pieces
        else:
            piece = f'black {piece}'  # prefix 'black' for black pieces
        
        # check if the piece is valid and available
        if piece not in available_pieces or available_pieces[piece] == 0:
            print(f"Invalid piece or no more {piece}s available.")
            continue
        
        # check if the position is valid
        if position not in board:
            print("Invalid position. Please enter a valid chess board position.")
            continue
        
        # check if the position is already occupied
        if position in pieces_dict or board.get(position) != '  ':
            print(f"Position {position} is already occupied.")
            continue
        
        # add the piece to the dictionary and update the board
        pieces_dict[position] = unicode_pieces[piece]
        available_pieces[piece] -= 1
        update_board(board, position, unicode_pieces[piece])
        print_board(board)
        
        # break the loop if it is a white piece
        if is_white:
            break
    
    return pieces_dict


def get_knight_moves(position):
    # define the possible moves for a knight
    knight_moves = [
        (2, 1), (2, -1), (-2, 1), (-2, -1),
        (1, 2), (1, -2), (-1, 2), (-1, -2)
    ]
    
    # convert the position to row and column indices
    col, row = position
    row = int(row)
    col = ord(col) - ord('a') + 1
    
    possible_moves = []
    
    for move in knight_moves:
        new_row = row + move[0]
        new_col = col + move[1]
        
        # check if the new position is within the board limits
        if 1 <= new_row <= 8 and 1 <= new_col <= 8:
            new_position = chr(new_col + ord('a') - 1) + str(new_row)
            possible_moves.append(new_position)
    
    return possible_moves


def get_rook_moves(position, board):
    # convert the position to row and column indices
    col, row = position
    row = int(row)
    col = ord(col) - ord('a') + 1
    
    possible_moves = []
    
    # check horizontal moves to the right
    for new_col in range(col + 1, 9):
        new_position = chr(new_col + ord('a') - 1) + str(row)
        possible_moves.append(new_position)
        if board[new_position] != '  ':
            break

    # check horizontal moves to the left
    for new_col in range(col - 1, 0, -1):
        new_position = chr(new_col + ord('a') - 1) + str(row)
        possible_moves.append(new_position)
        if board[new_position] != '  ':
            break
    
    # check vertical moves upward
    for new_row in range(row + 1, 9):
        new_position = chr(col + ord('a') - 1) + str(new_row)
        possible_moves.append(new_position)
        if board[new_position] != '  ':
            break
    
    # check vertical moves downward
    for new_row in range(row - 1, 0, -1):
        new_position = chr(col + ord('a') - 1) + str(new_row)
        possible_moves.append(new_position)
        if board[new_position] != '  ':
            break
    
    return possible_moves


main()
