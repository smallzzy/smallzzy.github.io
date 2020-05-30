import glob
import piexif

for filename in glob.iglob('./**/*.JPEG', recursive=True):
    piexif.remove(filename)
