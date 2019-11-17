import random

chars = 'abcdef0123456789'

def generateKey(stringLength=32):
    return ''.join(random.choice(chars) for i in range(stringLength))

