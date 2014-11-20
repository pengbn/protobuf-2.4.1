set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
include(CheckIncludeFiles)
include(CheckCxxHashset)
include(CheckCxxHashmap)

check_include_files("pthread.h" HAVE_PTHREAD)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  include(CheckIncludeFileCXX)
  set(CMAKE_REQUIRED_FLAGS "-std=c++11")
  check_include_file_cxx("unordered_map" HAVE_UNORDERED_MAP)
  check_include_file_cxx("tr1/unordered_map" HAVE_TR1_UNORDERED_MAP)
  set(CMAKE_REQUIRED_FLAGS )

  if(HAVE_UNORDERED_MAP)
    add_definitions("-std=c++11") # For unordered_map
    set(HASH_MAP_H "<unordered_map>")
    set(HASH_MAP_CLASS "unordered_map")
    set(HASH_NAMESPACE "std")
    set(HAVE_HASH_MAP 1)
  elseif(HAVE_TR1_UNORDERED_MAP)
    add_definitions("-std=c++11") # For unordered_map
    set(HASH_MAP_H "<tr1/unordered_map>")
    set(HASH_MAP_CLASS "unordered_map")
    set(HASH_NAMESPACE "std::tr1")
    set(HAVE_HASH_MAP 1)
  else()
    CHECK_HASHMAP()
    if(HAVE_GNU_EXT_HASH_MAP)
      set(HASH_MAP_H "<ext/hash_map>")
      set(HASH_NAMESPACE "__gnu_cxx")
      set(HASH_MAP_CLASS "hash_map")
      set(HAVE_HASH_MAP 1)
    elseif(HAVE_STD_EXT_HASH_MAP)
      set(HASH_MAP_H "<ext/hash_map>")
      set(HASH_NAMESPACE "std")
      set(HASH_MAP_CLASS "hash_map")
      set(HAVE_HASH_MAP 1)
    elseif(HAVE_GLOBAL_HASH_MAP)
      set(HASH_MAP_H "<ext/hash_map>")
      set(HASH_NAMESPACE "")
      set(HASH_MAP_CLASS "hash_map")
      set(HAVE_HASH_MAP 1)
    else()
      set(HAVE_HASH_MAP 0)
    endif()
  endif()

  set(CMAKE_REQUIRED_FLAGS "-std=c++11")
  check_include_file_cxx("unordered_set" HAVE_UNORDERED_SET)
  check_include_file_cxx("tr1/unordered_set" HAVE_TR1_UNORDERED_SET)
  set(CMAKE_REQUIRED_FLAGS )

  if(HAVE_UNORDERED_SET)
    set(HASH_SET_H "<unordered_set>")
    set(HASH_SET_CLASS "unordered_set")
    set(HAVE_HASH_SET 1)
  elseif(HAVE_TR1_UNORDERED_SET)
    add_definitions("-std=c++11")
    set(HASH_SET_H "<tr1/unordered_set>")
    set(HASH_SET_CLASS "unordered_set")
    set(HAVE_HASH_SET 1)
  else()
    CHECK_HASHSET()
    if(HAVE_GNU_EXT_HASH_SET)
      set(HASH_SET_H "<ext/hash_set>")
      set(HASH_NAMESPACE "__gnu_cxx")
      set(HASH_SET_CLASS "hash_set")
      set(HAVE_HASH_SET 1)
    elseif(HAVE_STD_EXT_HASH_SET)
      set(HASH_SET_H "<ext/hash_set>")
      set(HASH_NAMESPACE "std")
      set(HASH_SET_CLASS "hash_set")
      set(HAVE_HASH_SET 1)
    elseif(HAVE_GLOBAL_HASH_SET)
      set(HASH_SET_H "<hash_set>")
      set(HASH_NAMESPACE "")
      set(HASH_SET_CLASS "hash_set")
      set(HAVE_HASH_SET 1)
    else()
      set(HAVE_HASH_SET 0)
    endif()
  endif()
endif()

add_definitions("-D_GNU_SOURCE=1")
configure_file("config.h.cmake.in" "config.h")
