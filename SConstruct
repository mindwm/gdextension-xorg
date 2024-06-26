#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

# tweak this if you want to use different folders, or more folders, to store your source code in.
env["ENV"] = os.environ
env.Append(LIBS=
    [ 'X11'
    , 'X11-xcb'
    , 'xcb'
    , 'xcb-composite'
    , 'xcb-image'
    , 'xcb-randr'
    , 'xcb-xfixes'
    , "godot-cpp.linux.template_{}.x86_64.a".format(env["mode"])
    ])
sources = Glob("src/*.cpp")

if env["platform"] == "linux":
    library = env.SharedLibrary(
        "demo/bin/libxorg{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )
else:
    library = None

Default(library)
