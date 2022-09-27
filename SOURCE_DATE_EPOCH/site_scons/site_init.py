import os
import SCons.Environment


old_init = SCons.Environment.Base.__init__

def new_init(self, **kw):
    print("In my custom init")
    old_init(self, **kw)
    if 'SOURCE_DATE_EPOCH' in os.environ:
        self._dict['ENV']['SOURCE_DATE_EPOCH'] = os.environ['SOURCE_DATE_EPOCH']


SCons.Environment.Base.__init__ = new_init


