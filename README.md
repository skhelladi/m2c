## Prerequisites

- CMake >= 3.10
- Compilateur C++ compatible C++17
- MPI (OpenMPI ou MPICH)
- PETSc 3.23.3
- Eigen3 >= 3.3
- Boost >= 1.72

## Installation

### 1. PETSc Configuration

**⚠️ IMPORTANT: PETSc Path Configuration**

The project is configured to use PETSc from a specific external directory. You **must** update the PETSc path in the configuration files.

#### Installing PETSc from Official Repository

If you don't have PETSc installed, you can download and compile it from the official repository:

```bash
# Download PETSc
git clone -b release https://gitlab.com/petsc/petsc.git petsc
cd petsc

# Configure PETSc (basic configuration with MPI)
./configure --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 --download-fblaslapack --download-hypre --download-cmake

# Build PETSc
make PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt all

# Test installation (optional)
make PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt test
```

For optimized build (recommended for production):

```bash
./configure --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 --with-debugging=0 --COPTFLAGS='-O3 -march=native -mtune=native' --CXXOPTFLAGS='-O3 -march=native -mtune=native' --FOPTFLAGS='-O3 -march=native -mtune=native' --download-fblaslapack --download-hypre --download-cmake
make PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt all
```

After installation, note the `PETSC_DIR` (PETSc installation directory) and `PETSC_ARCH` values for the next step.

#### Option 1: Modify CMakeLists.txt (Recommended)

Edit the `CMakeLists.txt` file and modify the following line:

```cmake
set(PETSC_DIR "../external/petsc-3.23.3")
```

Replace `"../external/petsc-3.23.3"` with the absolute path to your PETSc installation.

Also modify if necessary:

```cmake
set(PETSC_ARCH "arch-linux-c-opt")
```

#### Option 2: Modify FindPETSc.cmake

Alternatively, you can edit `cmake/FindPETSc.cmake` and modify:

```cmake
if(NOT DEFINED PETSC_DIR)
    set(PETSC_DIR "../external/petsc-3.23.3")  # ← Modify this path
endif()

if(NOT DEFINED PETSC_ARCH)
    set(PETSC_ARCH "arch-linux-c-opt")  # ← Modify if necessary
endif()
```

#### Option 3: Environment Variables

You can also set environment variables:

```bash
export PETSC_DIR=/path/to/your/petsc
export PETSC_ARCH=your-petsc-arch
```

### 2. Dependencies Installation

#### On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install cmake build-essential
sudo apt install libopenmpi-dev openmpi-bin
sudo apt install libeigen3-dev
sudo apt install libboost-all-dev
```

#### On CentOS/RHEL/Fedora:

```bash
sudo yum install cmake gcc-c++
sudo yum install openmpi openmpi-devel
sudo yum install eigen3-devel
sudo yum install boost-devel
```

#### On macOS:

Using Homebrew:

```bash
brew install cmake
brew install open-mpi
brew install eigen
brew install boost
```

Using MacPorts:

```bash
sudo port install cmake
sudo port install openmpi-gcc12
sudo port install eigen3
sudo port install boost
```

**Note for macOS:** You may need to specify the compiler paths:

```bash
export CC=mpicc
export CXX=mpicxx
```

### 3. Build

1. **Clone the repository and navigate to the directory:**

```bash
git clone <repository-url>
cd m2c
```

2. **Create a build directory:**

```bash
mkdir build
cd build
```

3. **Configure with CMake:**

```bash
cmake ..
```

If you encounter path-related errors, you can specify explicitly:

```bash
cmake .. -DPETSC_DIR=/path/to/your/petsc \
         -DPETSC_ARCH=your-petsc-arch \
         -DEIGEN3_INCLUDE_DIR=/path/to/eigen3
```

4. **Build:**

```bash
make -j$(nproc)
```

### 4. Running

The `m2c` executable will be created in the `build` directory. To run with MPI:

```bash
mpirun -np <number_of_processes> ./m2c <input_file>
```

## Troubleshooting

### Common Errors

1. **"PETSc not found" error**
   - Check that the `PETSC_DIR` path is correct
   - Ensure PETSc is compiled with the architecture specified in `PETSC_ARCH`

2. **"Eigen3 not found" error**
   - Install Eigen3 or specify the path with `-DEIGEN3_INCLUDE_DIR=`

3. **MPI compilation errors**
   - Ensure `mpicc` and `mpicxx` are in your PATH
   - Check MPI installation with `mpicc --version`