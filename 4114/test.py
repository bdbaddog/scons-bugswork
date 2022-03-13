from fnmatch import fnmatch


dirlist = [
r"D:\work\gitee\rt-thread_ninja\bsp\beaglebone\SConscript",
r"D:\work\gitee\rt-thread_ninja\bsp\beaglebone\applications\SConscript",
r"D:\work\gitee\rt-thread_ninja\bsp\beaglebone\drivers\SConscript",
]

pattern = r'D:\work\gitee\rt-thread_ninja\bsp\beaglebone\*\SConscript'

for d in dirlist:
    matches = fnmatch(d, pattern)
    print("D[Matches:%s]:%s"%(matches,d))
