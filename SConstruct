env = Environment()
env.Append(LIBPATH=["path1/sub1","path1/sub2"])
lst = env.Flatten(env.subst_list("$LIBPATH"))
print( [type(i) for i in lst])
for i in lst:
    env.Dir(i)

