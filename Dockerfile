FROM ubuntu:20.04

# Scripts and configuration
COPY files/root/* /root/
COPY files/bin/* /bin/

# Make sure line endings are Unix
# This changes nothing if core.autocrlf is set to input
RUN sed -i 's/\r$//' /root/.bashrc

RUN apt-get update && apt-get install -y \
    clang \
    clang-tidy \
    clang-format \
    g++ \
    make \
    valgrind \
    gdb \
    llvm \
    libgtest-dev \
    software-properties-common \
    cmake \
    curl \
    default-jre \
    pkg-config \
    wget

# GTEST installation for labs
WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt \
    && make \
    && cp ./lib/libgtest*.a /usr/lib \
    && mkdir -p /usr/local/lib/gtest/ \
    && ln -s /usr/lib/libgtest.a /usr/local/lib/gtest/libgtest.a \
    && ln -s /usr/lib/libgtest_main.a /usr/local/lib/gtest/libgtest_main.a

# Grading, curricula requires python3.9
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get install -y \
        git \
        acl \
        python3.9 \
        python3.9-dev \
        python3-pip

# Removed while we're doing CMake grading
# && python3.9 -m pip install curricula curricula-grade curricula-grade-cpp curricula-compile curricula-format watchdog

# Install xmltodict for CMake tests
RUN python3 -m pip install xmltodict

VOLUME ["/work"]
WORKDIR /work
