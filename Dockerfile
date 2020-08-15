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
    cmake

# GTEST installation for labs
WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt
RUN make
RUN cp *.a /usr/lib
RUN mkdir -p /usr/local/lib/gtest/
RUN ln -s /usr/lib/libgtest.a /usr/local/lib/gtest/libgtest.a
RUN ln -s /usr/lib/libgtest_main.a /usr/local/lib/gtest/libgtest_main.a

# Grading
RUN apt-get install -y \
    git \
    acl \
    python3.7 \
    python3.7-dev \
    python3-pip
RUN python3.7 -m pip install curricula curricula-shell

VOLUME ["/work"]
WORKDIR /work
