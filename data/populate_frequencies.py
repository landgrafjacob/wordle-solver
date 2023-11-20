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

    df = pd.DataFrame.from_dict(freq_dict, orient='index')
    df = df.fillna(0)
    df = df.astype(int)
    df.to_csv('word_freq_with_pos.csv')


if __name__ == "__main__":
    populate()
    