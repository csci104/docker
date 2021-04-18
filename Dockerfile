FROM ubuntu:18.04

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
    cmake

# GTEST installation for labs
WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt \
    && make \
    && cp *.a /usr/lib \
    && mkdir -p /usr/local/lib/gtest/ \
    && ln -s /usr/lib/libgtest.a /usr/local/lib/gtest/libgtest.a \
    && ln -s /usr/lib/libgtest_main.a /usr/local/lib/gtest/libgtest_main.a

VOLUME ["/work"]
WORKDIR /work
