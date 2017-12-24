# output

Let me post here the output of `./runall.sh`

## make

Let's see what happens. The generation runs

```sh
-- The C compiler identification is GNU 6.3.0
-- The CXX compiler identification is GNU 6.3.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /tmp/play_cmake/make
```

On the first build, everything needs to be done:

```
Scanning dependencies of target main
[ 33%] Building CXX object CMakeFiles/main.dir/main.cpp.o
[ 66%] Linking CXX executable main
[ 66%] Built target main
Scanning dependencies of target txt
[100%] grep for lines_with_foobar
[100%] Built target txt
```

Then I manipulate the inputs (or I don't)

```sh
touched nothing
```

As a result cmake only reports that it's done with targets

```sh
[ 66%] Built target main
[100%] Built target txt
```

Now I touch only the main source file `main.cpp`

```sh
touched main
```

cmake runs and recompiles and re-greps

```sh
Scanning dependencies of target main
[ 33%] Building CXX object CMakeFiles/main.dir/main.cpp.o
[ 66%] Linking CXX executable main
[ 66%] Built target main
Scanning dependencies of target txt
[100%] grep for lines_with_foobar
[100%] Built target txt
```

Now touch `derived.h`

```sh
touched derived
```

Everything should need rebuild

```
Scanning dependencies of target main
[ 33%] Building CXX object CMakeFiles/main.dir/main.cpp.o
[ 66%] Linking CXX executable main
[ 66%] Built target main
Scanning dependencies of target txt
[100%] grep for lines_with_foobar
[100%] Built target txt
```

Touching `base.h` is just to trick cmake, it is due to the preprocessor setting not actually included

```
touched base
```

Still cmake rebuilds everything

```sh
Scanning dependencies of target main
[ 33%] Building CXX object CMakeFiles/main.dir/main.cpp.o
[ 66%] Linking CXX executable main
[ 66%] Built target main
Scanning dependencies of target txt
[100%] grep for lines_with_foobar
[100%] Built target txt
```

## Ninja

Generation as before

```sh
-- The C compiler identification is GNU 6.3.0
-- The CXX compiler identification is GNU 6.3.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /tmp/play_cmake/ninja
```

Now a first build, three steps as expected (compile, link, grep)

```sh
[1/3] cd /tmp/play_cmake && grep -i foobar base.h derived.h > /tmp/play_cmake/ninja/lines_with_foobar.txt || true
[2/3] /usr/bin/c++  -Ddont_use_base=1   -MD -MT CMakeFiles/main.dir/main.cpp.o -MF CMakeFiles/main.dir/main.cpp.o.d -o CMakeFiles/main.dir/main.cpp.o -c ../main.cpp
[3/3] : && /usr/bin/c++    -lstdc++ -m64 -g -march=native -flto CMakeFiles/main.dir/main.cpp.o  -o main   && :
```

Touching no file …

```
touched nothing
```

leads to no work

```
ninja: no work to do.
```

Touching the main file …

```
touched main
```

… leads to redoing everything

```
[1/3] cd /tmp/play_cmake && grep -i foobar base.h derived.h > /tmp/play_cmake/ninja/lines_with_foobar.txt || true
[2/3] /usr/bin/c++  -Ddont_use_base=1   -MD -MT CMakeFiles/main.dir/main.cpp.o -MF CMakeFiles/main.dir/main.cpp.o.d -o CMakeFiles/main.dir/main.cpp.o -c ../main.cpp
[3/3] : && /usr/bin/c++    -lstdc++ -m64 -g -march=native -flto CMakeFiles/main.dir/main.cpp.o  -o main   && :
```

touching `derived.h`
```
touched derived
```

should also redo everything, except CMake ignores `IMPLICIT_DEPENDS` for Ninja

```sh
[1/2] /usr/bin/c++  -Ddont_use_base=1   -MD -MT CMakeFiles/main.dir/main.cpp.o -MF CMakeFiles/main.dir/main.cpp.o.d -o CMakeFiles/main.dir/main.cpp.o -c ../main.cpp
[2/2] : && /usr/bin/c++    -lstdc++ -m64 -g -march=native -flto CMakeFiles/main.dir/main.cpp.o  -o main   && :
```

finally, touching `base.h`

```
touched base
```

Is correctly noticed by ninja to be pointless

```
ninja: no work to do.
```
