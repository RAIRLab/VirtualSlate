# VirtualSlate (Work In Progress)

VirtualState is a 3D, VR, Hypergraphical, Natural-Deduction (ND) Interactive Theorem Prover (ITP). 
It belongs to the Slate Family (Slate, Hyperslate, Lazyslate) of Hypergraphical ND ITPs.

## Building
The source is split into two parts, A godot `module` in C++ interfacing and a godot `project` containing the scene. 
Module contains the code for the Godot Module. 

### Building Godot With The Module
We use a container to build godot with our module in a reporducable enviornment. 
For this we use [podman](https://podman.io/) but you could also easily use [docker](https://www.docker.com/).
First install Podman, if you're on Windows, do this on [WSL](https://learn.microsoft.com/en-us/windows/wsl/). 
```bash
sudo apt install podman
```
Run the container to build godot using our module, it will install all the
required dependancies in the container and output the compiled executable.
```bash
podman build .
```
