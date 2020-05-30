import os.path as osp
from PIL import Image

def process_img(img_n):
    n = img_n.split("_")
    img_p = osp.join("train", n[0], img_n)
    img = Image.open(img_p).convert("RGB")
    img.save(img_p, 'JPEG', quality=95)


png_list = ['n02105855_2933.JPEG']
for j in png_list:
    process_img(j)

cmyk_list = ['n01739381_1309.JPEG', 'n02077923_14822.JPEG',
            'n02447366_23489.JPEG', 'n02492035_15739.JPEG',
            'n02747177_10752.JPEG', 'n03018349_4028.JPEG',
            'n03062245_4620.JPEG', 'n03347037_9675.JPEG',
            'n03467068_12171.JPEG', 'n03529860_11437.JPEG',
            'n03544143_17228.JPEG', 'n03633091_5218.JPEG',
            'n03710637_5125.JPEG', 'n03961711_5286.JPEG',
            'n04033995_2932.JPEG', 'n04258138_17003.JPEG',
            'n04264628_27969.JPEG', 'n04336792_7448.JPEG',
            'n04371774_5854.JPEG', 'n04596742_4225.JPEG',
            'n07583066_647.JPEG', 'n13037406_4650.JPEG']
for j in cmyk_list:
    process_img(j)
