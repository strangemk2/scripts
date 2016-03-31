# coding: utf-8
# 自分の得意な言語で
# Let's チャレンジ！！
input_lines = int(raw_input())

def is_palindrome(word):
    for i in range(len(word) / 2):
        if word[i] != word[-1 - i]:
            return False
    return True

def find_palindrome_pair(word, words):
    reversed_word = word[::-1]
    if reversed_word in words:
        words.remove(word)
        try:
            words.remove(reversed_word)
        except:
            # self palindrome
            return None
        if word < reversed_word:
            return word
        else:
            return reversed_word
        #return word if word < reversed_word else reversed_word
    else:
        return None


def find_revive_palindrome(words):
    side_parts = []
    middle_parts = []
    work_words = words[:]
    for word in words:
        left = find_palindrome_pair(word, work_words)
        if left != None:
            side_parts.append(left)
            next
        if is_palindrome(word):
            middle_parts.append(word)

    side_parts.sort()
    middle_parts.sort()
    #print side_parts
    #print middle_parts

    left_side = "".join(side_parts)
    right_side = left_side[::-1]
    middle = ""
    if len(middle_parts) > 0:
        middle = middle_parts[0]

    return left_side + middle + right_side

words = []
for i in range(input_lines):
    words.append(raw_input())

print find_revive_palindrome(words)
