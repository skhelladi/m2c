# This module relies on PETSc_DIR and PETSc_ARCH being set in CMake or
# PETSC_DIR and PETSC_ARCH being set in the environment

# Set default PETSc paths
if(NOT DEFINED PETSC_DIR)
    set(PETSC_DIR "../external/petsc-3.23.3")
endif()

if(NOT DEFINED PETSC_ARCH)
    set(PETSC_ARCH "arch-linux-c-opt")
endif()

# Find the headers.
find_path(PETSc_INCLUDE_DIR petsc.h
          HINTS ${PETSC_DIR}/include
                ${PETSC_DIR}/${PETSC_ARCH}/include)

# Find the libraries. 
find_library(PETSc_LIBRARY
             NAMES petsc
             HINTS ${PETSC_DIR}/lib
                   ${PETSC_DIR}/${PETSC_ARCH}/lib)

# Find PETSc version.
if(PETSc_INCLUDE_DIR)
    set(HEADER "${PETSc_INCLUDE_DIR}/petscversion.h")
    if(EXISTS "${HEADER}")
        file(STRINGS "${HEADER}" major REGEX "define +PETSC_VERSION_MAJOR")
        file(STRINGS "${HEADER}" minor REGEX "define +PETSC_VERSION_MINOR")
        file(STRINGS "${HEADER}" patch REGEX "define +PETSC_VERSION_SUBMINOR")
        string(REGEX MATCH "#define PETSC_VERSION_MAJOR *([0-9]*)" _ ${major})
        set(major ${CMAKE_MATCH_1})
        string(REGEX MATCH "#define PETSC_VERSION_MINOR *([0-9]*)" _ ${minor})
        set(minor ${CMAKE_MATCH_1})
        string(REGEX MATCH "#define PETSC_VERSION_SUBMINOR *([0-9]*)" _ ${patch})
        set(patch ${CMAKE_MATCH_1})
        string(STRIP "${major}" major)
        string(STRIP "${minor}" minor)
        string(STRIP "${patch}" patch)
        set(PETSc_VERSION "${major}.${minor}.${patch}")
    endif()
endif()

# Set variables.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PETSc
        REQUIRED_VARS PETSc_LIBRARY PETSc_INCLUDE_DIR
        VERSION_VAR PETSc_VERSION)

mark_as_advanced(PETSc_INCLUDE_DIR PETSc_LIBRARY PETSc_VERSION PETSc_FOUND)

set(PETSc_LIBRARIES ${PETSc_LIBRARY})
set(PETSc_INCLUDE_DIRS ${PETSc_INCLUDE_DIR})

# Also include the arch-specific include directory
if(EXISTS "${PETSC_DIR}/${PETSC_ARCH}/include")
    list(APPEND PETSc_INCLUDE_DIRS "${PETSC_DIR}/${PETSC_ARCH}/include")
endif()
