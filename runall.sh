rm -rf make
rm -rf ninja
cmake -H. -Bmake -G Unix\ Makefiles
cmake --build make
echo "touched nothing"
cmake --build make
touch main.cpp
echo "touched main"
cmake --build make
touch derived.h
echo "touched derived"
cmake --build make
touch base.h
echo "touched base"
cmake --build make

cmake -H. -Bninja -G Ninja
cmake --build ninja -- -v
sleep 0.4s
echo "touched nothing"
cmake --build ninja -- -v
sleep 0.4s
touch main.cpp
echo "touched main"
cmake --build ninja -- -v
sleep 0.4s
touch derived.h
echo "touched derived"
cmake --build ninja -- -v
sleep 0.4s
touch base.h
echo "touched base"
cmake --build ninja -- -v
