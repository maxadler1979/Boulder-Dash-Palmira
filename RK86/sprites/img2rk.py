import sys
from PIL import Image

print('img2rk v. 1.0 (c) Viktor Pykhonin, 2021')

if len(sys.argv) != 2:
  print('Usage img2rk <source_image>')
  exit()

img = Image.open(sys.argv[1])

w, h = img.size

print('Succesfully loaded {0}, {1}*{2}'.format(sys.argv[1], w, h))

img = img.convert('1')
print('Converted to black & white')

add_w = w % 2
add_h = h % 2

if add_w > 0 or add_h > 0:
  img = img.crop((0, 0, w + add_w, h + add_h))
  w, h = img.size
  print('Expanded to {0}*{1}'.format(w, h))

cw = w // 2
ch = h // 2

pixels = img.load()

bin = bytearray(cw * ch)

for y in range(ch):
    for x in range(cw):
        bin[y * cw + x] = (pixels[x*2, y*2] & 1) | (pixels[x*2 + 1, y*2] & 2) | (pixels[x*2 + 1, y*2 + 1] & 4) | (pixels[x*2, y*2 + 1] & 0x10)

f = open('output.bin', 'wb')
f.write(bin)
f.close

print('Written output.bin: {0} rows, {1} chars per row.'.format(cw, ch))
