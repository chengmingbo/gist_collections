#!/usr/bin/python3
import getopt
import sys
import os

## google drive downloading with id
## alternative
## https://github.com/wkentaro/gdown.git 

gid=""
out=""

try:
    #options,args = getopt.getopt(sys.argv[1:],"dn")
    options,args = getopt.getopt(sys.argv[1:],"i:o:")
except getopt.GetoptError:
    print("Erorr Parametes")
    sys.exit()
for name,value in options:
    if name in "-i":
        gid = value
        print("gid=", value)
    if name in "-o":
        out = value
        print("out_name=", value)

if not gid:
    print("google drive id is none")
    sys.exit(1)
if not out:
    print("out put name is none")
    sys.exit(1)


cmd = f"wget --load-cookies /tmp/cookies.txt \"https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id={gid}' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\\1\\n/p')&id={gid}\" -O {out} && rm -rf /tmp/cookies.txt"

print(cmd)
os.system(cmd)

