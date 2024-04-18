# SoftBound+CETS Revisited: More Than A Decade Later

This project is not maintained. It has been published as part of the following EuroSec '24 paper: 

> Benjamin Orthen, Oliver Braunsdorf, Philipp Zieris, and Julian Horsch. 2024. SoftBound+CETS Revisited: More Than a Decade Later. In Proceedings of the 17th European Workshop on Systems Security (EuroSec '24). Association for Computing Machinery, New York, NY, USA, 22–28. https://doi.org/10.1145/3642974.3652285

Note that these repositories present a prototype implementation and are not to be used in production.
However, we will most likely respond to issues or other questions you may have.

## Introduction

This repository contains the necessary information to setup and compile [LLVM 12 with the updated SoftBound+CETS compiler pass](https://github.com/Fraunhofer-AISEC/softboundcets-llvm-project.git) and runtime library.

Furthermore, it contains the configuration to run the Juliet Test Suite setup and the SPEC 2017 SPECrate© Integer C benchmarks.

## Setup

We recommend you use the Dockerfile in the `docker` folder for building and running LLVM with SoftBound+CETS.
1. Build the Docker container with `docker build ./docker --build-arg USERNAME=$(whoami) --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) -t llvm-software-dev`
2. Run the Docker container with `docker run --security-opt=seccomp:unconfined --cap-add=SYS_PTRACE -v $HOME:$HOME -it llvm-software-dev bash` (adapt the mounted directories as needed)
3. Clone the llvm-project with `git clone https://github.com/Fraunhofer-AISEC/softboundcets-llvm-project.git llvm-project`
4. Build LLVM with `./build-amd64.sh`
5. (Optional) After LLVM source code changes, rebuild with `./rebuild-amd64.sh`

## Compile Programs with SoftBound+CETS

You can use the following compile options to instrument a program with SoftBound+CETS, assuming you are in the folder of this README file. The optimization level `O0` is not obligatory.

If you want to instrument the program *without* inlining runtime calls:

```bash
$(pwd)/build/bin/clang -O0 -fuse-ld=$(pwd)/build/bin/ld.lld -flto -Wl,-mllvm=-load=$(pwd)/build/lib/LLVMSoftBoundCETSLTO.so,--whole-archive,-L$(pwd)/build/lib/clang/12.0.1/lib/linux,-Bstatic,-lclang_rt.softboundcets-x86_64,-Bdynamic,--no-whole-archive test.c
```

If you want to instrument the program *with* inlined runtime calls:

```bash
$(pwd)/build/bin/clang -O0 -fuse-ld=$(pwd)/build/bin/ld.lld -flto -Wl,-mllvm=-load=$(pwd)/build/lib/LLVMSoftBoundCETSLTO.so,-mllvm=-softboundcets-inline-rtlib-functions,--whole-archive,-L$(pwd)/build/lib/clang/12.0.1/lib/linux,-Bstatic,-lclang_rt.softboundcets_inlining-x86_64,-Bdynamic,--no-whole-archive test.c
```

If you want to instrument the program and link dynamically against the runtime library (for debugging purposes):

```bash
$(pwd)/build/bin/clang -O0 -fuse-ld=$(pwd)/build/bin/ld.lld -flto -Wl,-mllvm=-load=$(pwd)/build/lib/LLVMSoftBoundCETSLTO.so -Wl,-rpath=$(pwd)/build/lib/clang/12.0.1/lib/linux/,-L$(pwd)/build/lib/clang/12.0.1/lib/linux/,-lclang_rt.softboundcets-x86_64 test.c
```

## Sub-Object Bounds Checking

If you want to enable sub-object bounds checking, use the additional link-time argument `-Wl,-mllvm=-softboundcets-disable-gep-constant-offset-accumulation-instcombine,-mllvm=-softboundcets-check-sub-object-bounds` to instruct the compiler pass to insert the necessary additional instructions.

## Juliet Test Suite benchmarks

Run the `setup-juliet.sh` script in this folder to set up the Juliet Test Suite. 
The see the README in the [juliet test suite folder](./juliet-test-suite-c). Use the same Docker container as for building LLVM.


## SPEC 2017 CPU benchmarks

Use the configuration provided in the [benchmark folder](./SPEC-benchmark-configs/).
