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
RUN apk add --no-cache build-base
RUN apk add --no-cache python3 python3-dev
RUN apk add --no-cache valgrind gdb
RUN apk add --no-cache clang llvm

# Grading
RUN apk add --no-cache git
RUN python3 -m pip install --upgrade pip
# RUN python3 -m pip install git+https://github.com/csci104/grade.git
