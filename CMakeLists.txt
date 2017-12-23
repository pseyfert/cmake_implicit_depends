cmake_minimum_required(VERSION 3.9)

add_definitions(-Ddont_use_base=1)

add_custom_command(OUTPUT lines_with_foobar.txt
  COMMAND grep -i foobar base.h derived.h > ${CMAKE_CURRENT_BINARY_DIR}/lines_with_foobar.txt || true
  IMPLICIT_DEPENDS CXX ${CMAKE_CURRENT_LIST_DIR}/main.cpp
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
  COMMENT "grep for lines_with_foobar"
  )

add_custom_target(txt ALL
  DEPENDS lines_with_foobar.txt
  )

add_executable(main main.cpp)
