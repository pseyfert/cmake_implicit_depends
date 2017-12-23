# small study on dependency treatment in CMake

There are three files: base.h derived.h main.cpp

`base.h` is a "fake" header.  It's include is disabled through the preprocessor
options.  The executable `main` should thus be rebuilt whenever `main.cpp` or
`derived.h` get touched.

The CMake option `IMPLICIT_DEPENDS` is tested for a custom command. It is set
up to have the same depends as `main`.

## observation with make

CMake is set up to figure dependencies for C/C++ files out by itself, and
doesn't use the gcc preprocessor. It therefore misses that `base.h` is only for
confusion and rebuilds everything when `base.h` is touched.

It "correctly" applies the same dependencies for the custom command

## observation with ninja

With ninja, the compiler's dependency resolution is used instead of the CMake
dependency scan. When `base.h` is touched, no recompilation is done.

Yet, `IMPLICIT_DEPENDS` is not implemented for the ninja generator, and doesn't
recognize the need to rerun grep when `derived.h` gets touched.


### small print

In the `runall.sh` script, I added a few `sleep` commands, because `ninja` runs
too fast and the time checking doesn't realise the touch should've happened
after the build.
