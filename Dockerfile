FROM alpine:3.10.1

# Container
RUN apk update
RUN apk add --no-cache bash
COPY files/.bashrc /root
COPY files/praise /bin
COPY files/.valgrind.gcc.supp /root
COPY files/.valgrindrc /root

# Basic stuff
RUN apk add --no-cache nano

# C++
RUN apk add --no-cache build-base cmake
RUN apk add --no-cache python3 python3-dev
RUN apk add --no-cache valgrind gdb
RUN apk add --no-cache clang llvm

# Legacy gtest stuff for labs
RUN apk add --no-cache gtest gtest-dev

# Make expected directory structure to link for lab makefiles
RUN mkdir -p /usr/local/opt/gtest/include/
RUN ln -s /usr/include/ /usr/local/opt/gtest/include/

# Grading
RUN apk add --no-cache git
RUN python3 -m pip install --upgrade pip
# RUN python3 -m pip install git+https://github.com/csci104/grade.git
