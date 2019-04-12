FROM alpine:3.8

# Container
RUN apk update
RUN apk add --no-cache bash
COPY files/.bashrc /root
COPY files/praise /bin

# C++
RUN apk add --no-cache build-base
RUN apk add --no-cache python3 python3-dev
RUN apk add --no-cache valgrind gdb

# Grading
RUN apk add --no-cache git
RUN python3 -m pip install --upgrade pip
# RUN python3 -m pip install git+https://github.com/csci104/grade.git
