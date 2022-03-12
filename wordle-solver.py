from collections import defaultdict

def get_recommendation(poss_words, freq_dict):
    high_score, best_word = 0, ''
    for word in poss_words:
        seen = set()
        score = 0
        for letter in word:
            if letter not in seen:
                score += freq_dict[letter]
                seen.add(letter)

        if score >= high_score:
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
    freq_dict = defaultdict(int)
    with open('word_freq.txt', 'r') as freq_file:
        for line in freq_file:
            line_list = line.strip().split(' ')
            freq_dict[line_list[0]] = int(line_list[1])


    game_on = True

    while game_on:
        print(f'The recommended word is {get_recommendation(word_set, freq_dict)}')

        user_word = input('Input your guess:')
        result = input('Input the result (g for green, y for yellow, 0 for grey, nothing for win):')

        if result == '':
            break

        word_set = set(filter(lambda x: good_word(x, user_word, result), word_set))





if __name__ == "__main__":
    wordle_solver()