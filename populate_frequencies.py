from collections import defaultdict
import pandas as pd

def populate():
    freq_dict = {}
    with open('wordlist.txt', 'r') as in_file:
        for word in in_file:
            for i, char in enumerate(word.strip()):
                if char in freq_dict:
                    if i in freq_dict[char]:
                        freq_dict[char][i] += 1
                    else:
                        freq_dict[char][i] = 1
                else:
                    freq_dict[char] = {i: 1}

    df = pd.DataFrame.from_dict(freq_dict, orient='columns')

    df.to_csv('word_freq_with_pos.csv')

            

    # with open("word_freq_with_pos.txt", "w") as out_file:
    #     for letter in sorted(freq_dict.keys()):
    #         to_write = letter
    #         for i in range(5):
    #             if i in freq_dict[letter]:
    #                 to_write += f' {freq_dict[letter][i]}'
    #             else:
    #                 to_write += ' 0'

    #         out_file.write(to_write + '\n')

            


if __name__ == "__main__":
    populate()
    