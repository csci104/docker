FROM alpine:3.10.1
RUN apk update

# Scripts and configuration
COPY files/root/* /root/
COPY files/bin/* /bin/

# Basic stuff
RUN apk add bash
RUN apk add nano

# C++
RUN apk add cmake
RUN apk add build-base
RUN apk add valgrind
RUN apk add gdb
RUN apk add llvm
RUN apk add clang

# Legacy gtest stuff for labs, make expected directory structure to link for lab makefiles
RUN apk add gtest gtest-dev
RUN mkdir -p /usr/local/opt/gtest/include/
RUN ln -s /usr/include/ /usr/local/opt/gtest/include/

# Grading
RUN apk add git
RUN apk add python3 python3-dev
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install git+https://github.com/csci104/curricula.git
RUN chmod +x /bin/curricula-setup && curricula-setup
