#!/usr/bin/python3

import unicodedata

for s in ['Jalapen\u0303o', 'n̂']:
  print(s)
  print(ascii(s))
  print('NFC:', ascii(unicodedata.normalize('NFC', s)))
  print('NFD:', ascii(unicodedata.normalize('NFD', s)))
  print('')

# take away: not all characters are in NFC
