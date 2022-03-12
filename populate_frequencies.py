from collections import defaultdict

def populate():
    freq_dict = defaultdict(int)
    with open('wordlist.txt', 'r') as in_file:
        for word in in_file:
            for char in word.strip():
                freq_dict[char] += 1

    with open("word_freq.txt", "w") as out_file:
        for letter, count in freq_dict.items():
            out_file.write(f'{letter} {count}\n')

            


if __name__ == "__main__":
    populate()
    