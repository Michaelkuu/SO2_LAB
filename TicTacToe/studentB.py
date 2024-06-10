import random


def get_user_move(board):
    while True:
        try:
            x, y = map(int, input("Podaj ruch (wiersz kolumna): ").split())
            if board[x][y] == '.':
                board[x][y] = 'X'
                return board
            else:
                print("Pole zajęte")
        except (ValueError, IndexError):
            print("Nieprawidłowy ruch")


def ai_move(board):
    empty_positions = [(i, j) for i in range(len(board)) for j in range(len(board[i])) if board[i][j] == '.']
    x, y = random.choice(empty_positions)
    board[x][y] = 'O'
    return board


def is_player_starting():
    choice = input("Kto ma zacząć?\nUżytkownik (U) czy Komputer (K): ")
    if choice.upper() == 'U':
        return True  # zaczyna użytkownik
    else:
        return False  # zaczyna komputer
