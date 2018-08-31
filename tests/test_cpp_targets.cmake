include(UnitTestHelpers)

#Sets up a dummy library
string(RANDOM random_prefix)
set(file_prefix ${CMAKE_CURRENT_SOURCE_DIR}/${random_prefix})
file(MAKE_DIRECTORY ${file_prefix})

set(a_src ${file_prefix}/a.cpp)
file(WRITE ${a_src} "int main(){return 0;}\n")

set(a_list ${file_prefix}/CMakeLists.txt)
write_top_list(${a_list}
"include(cpp_targets)
cpp_add_library(TEST1 SOURCES ${a_src})
"
)
run_sub_build(${file_prefix})
