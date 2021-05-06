# CSCI 104 Docker

<a href="https://hub.docker.com/repository/docker/usccsci104/docker">
  <img align="left" src="https://img.shields.io/docker/image-size/usccsci104/docker?style=flat-square" />
</a>

<a href="https://hub.docker.com/repository/docker/usccsci104/docker">
  <img align="left" src="https://img.shields.io/docker/pulls/usccsci104/docker" />
</a>

</br>

This repository contains a Dockerfile and a couple of management scripts for creating and using a virtualized Linux container capable of building, running, and debugging C++.
Using a virtualized container is preferable to a user's local machine because it guarantees consistent compilation and execution of C++ binaries.
While compilers and tooling may vary between systems, creating a sealed environment from the exact same components every time ensures that code runs the same for graders as it does students.

But why use Docker over a traditional virtual machine?
Docker is considerably less resource-intensive than installing a full virtual machine.
Instead of needing the facilities for a graphical interface, virtual file system, etc., we can mount any directory of the host machine directly in the container and use a shell to run compilation and debugging.
Development and file management may be done normally on the local machine.

The rest of this README is a quickstart for more experienced users.
Feel free to read through the [wiki](https://github.com/csci104/docker/wiki) for **a more in-depth guide on [how setup and use Docker](https://github.com/csci104/docker/wiki/Usage)** as well as [how it works](https://github.com/csci104/docker/wiki/Details).

## System Requirements

Below are the system requirements for Docker Desktop:

[Windows host](https://docs.docker.com/docker-for-windows/install/):

- Windows 10 64-bit: (Build 15063 or later)
  - Pro, Enterprise, or Education: using Hyper-V and Containers Windows features
  - Any Windows 10 version: using WSL2 container backend **(recommended)**

If you are using Windows 10 Home, you can obtain a "free" license for Windows 10 Education [here](https://viterbiit.usc.edu/services/hardware-software/microsoft-imagine-downloads/) though this is not required if you use WSL2 for containers.

[Mac host](https://docs.docker.com/docker-for-mac/install/):

- Mac hardware must be a 2010 or newer model
- macOS must be version 10.13 or newer
- 4 GB RAM minimum

If you are using Apple Silicon, you should run the setup commands in a Rosetta emulation.
See [instructions here](https://osxdaily.com/2020/11/18/how-run-homebrew-x86-terminal-apple-silicon-mac/) to run Terminal through Rosetta. However,
be aware that gdb may not work per [this Github issue](https://github.com/docker/for-mac/issues/5191#issue-775028988).

## Setting Up

First, **install Docker** desktop from [the website](https://www.docker.com/products/docker-desktop).
Once done, **clone this repository**, which contains a setup script for both Windows and Unix-based systems.
Running it will install a helper CLI (command-line tool), pull the CSCI 104 docker image and setup a virtualized environment.

**macOS/Linux**

On macOS in Terminal, run the respective setup script inside the `docker` folder:

```bash
./unix/setup.sh
```

Note: if you're not able to run `ch` after setup, you may need to run `source ~/.zprofile` or `source ~/.bash_profile` depending on your shell.

**Windows**

On Windows in PowerShell, the process is similar but you must make sure you can run PowerShell scripts:

Make sure you run this in an Admin PowerShell:

```powershell
# must execute this in admin powershell and select [A] to run scripts
Set-ExecutionPolicy RemoteSigned
```

In PowerShell, run this command in the `docker` folder:

```powershell
.\windows\setup
```

When prompted, provide the directory in your local machine you wish to be accessible from the virtual machine.
For example, if you cloned your homework directory to `/Users/username/Documents/hw-username` or `C:\Users\username\Documents\hw-username`, enter that.
**You must supply the absolute path of the directory you want to access**.
Something like `cs104/` or `../` is not sufficient, the path must start from `/` on Unix or `C:\` (or whatever disk you're working from) on Windows.

Once you've finished answering the prompts and setup script finishes, you should be ready to use `ch` to work with your csci104 environment. Remember that if `ch` isn't available, you may need to run `source ~/.zshrc` or `source ~/.bashrc` on macOS. 

## Working

The `ch` (container-helper) command-line tool allows you to create and access Docker environments.
When you ran the `setup` script, it created and pulled a Docker image made for
compiling, running and debugging C++ code in CSCI 104. To run this environment,
you can run this command (the same for both Unix and Windows systems):

```bash
ch COMMAND csci104
```

There are three commands you will regularly use:
- The first, `start`, starts the container up in the background.
  The container should continue running until you shut down your computer, exit docker, or kill the container manually.
- Next is `shell`, which simply opens a shell inside the virtual machine.
  This is where you can run standard linux commands, such as `g++` or `valgrind`. You can exit the shell with the key sequence <Ctrl+D> <Ctrl+C>.
- The last is `stop`, which manually shuts down the virtual container.

### Example

See full documentation for `ch` [here](https://github.com/camerondurham/ch).

```bash
# start your environment
ch start csci104

# get a shell into the csci104 environment
ch shell csci104

# exit the shell with key sequence <Ctrl+D> <Ctrl+C>

# stop the running environment
ch stop csci104
```

### Note: Valgrind Suppression

To determine the correct valgrind suppression in the future, refer to [this manual](https://wiki.wxwidgets.org/Valgrind_Suppression_File_Howtohttps://wiki.wxwidgets.org/Valgrind_Suppression_File_Howto).
Running it on a sufficiently complex piece of leak-free code will yield most of the necessary configurations.

### Note: Hypervisor on Windows

If you plan to using Docker and Virtual Box as a fallback, please be aware of what you will need to do to switch between the two systems. You'll have to toggle the Hypervisor:

- Docker: Hypervisor **ON**
- VirtualBox: Hypervisor **OFF**

Here's how you can do that on Windows:

1. Press Windows key + X and select `Apps and Features`.
2. Scroll down to the bottom and click Programs and Features link.
3. Then click the Turn Windows Hypervisor on or off link on the left pane.

This issue **ONLY** concerns Windows users.
