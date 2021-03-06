from collections import defaultdict
import math
import pandas as pd

def get_recommendation(poss_words, freq_df):
    high_score, best_word = 0, ''
    for word in poss_words:
        seen = set()
        score = 0
        for i, letter in enumerate(word):
            if letter not in seen:
                score += freq_df[letter][i]
                seen.add(letter)

        if score > high_score:
            best_word = word
            high_score = score



    return best_word, high_score

def good_word(word, guess, result):
    for i, letter in enumerate(guess):
        # If the letter is green
        if result[i] == 'g' and letter != word[i]:
            return False

        # If the letter is yellow
        elif result[i] == 'y' and (word[i] == letter or letter not in word):
            return False

        # If letter is grey
        elif result[i] == '0' and letter in word:
            return False

    return True
        

def wordle_solver():
    # Import set of possible words
    word_set = set()
    with open('wordlist.txt', 'r') as word_file:
        for line in word_file.readlines():
            word_set.add(line.strip())

    # Import the frequency dictionary
    df = pd.read_csv('word_freq_with_pos.csv', index_col=0)
    df.fillna(0, inplace=True)


    # Play the game
    while True:
        print(f'The recommended word is {get_recommendation(word_set, df)}')

        user_word = input('Input your guess:')
        result = input('Input the result (g for green, y for yellow, 0 for grey, nothing for win):')

        if result == '':
            break

        word_set = set(filter(lambda x: good_word(x, user_word, result), word_set))





if __name__ == "__main__":
    wordle_solver()