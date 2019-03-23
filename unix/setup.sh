#!/usr/bin/env bash



docker build -t csci104 -f .
# docker run -v /path/to/material/:/work/ -dt csci104 --cap-add SYS_PTRACE --security-opt seccomp=unconfined
# docker exec -it # bash
