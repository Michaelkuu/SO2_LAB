def print_board(board):
    for row in board:
        print(" | ".join(row))
        print("-" * 9)
    print("\t")


def new_board():
    return [['.' for _ in range(3)] for _ in range(3)]


def is_game_over(board):
    lines = (
        board[0], board[1], board[2],
        [board[0][0], board[1][0], board[2][0]], [board[0][1], board[1][1], board[2][1]],
        [board[0][2], board[1][2], board[2][2]],
        [board[0][0], board[1][1], board[2][2]], [board[0][2], board[1][1], board[2][0]]
    )
    for line in lines:
        if line[0] == line[1] == line[2] and line[0] != '.':
            return line[0]
    return None


def announce_outcome(board, players_move):
    winner = is_game_over(board)
    print_board(board)
    if winner:
        print(f"Gracz {winner} wygrywa")
    else:
        print("REMIS")
