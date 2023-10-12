# VirtualSlate

(Work In Progress) Propositional Natural Deduction Proof Graphs in 3D Virtual Reality. In development as a capstone project for UAlbany ICSI 499. Sponsored by James Oswald (RAIR Laboratory). 

## Development

### Ubuntu-WSL Based Approach
In this setup we use ubuntu on WSL to compile the extension. This is a great option 
for windows users, as the alternate, VisualStudio is rough . 
#### Setup
We begin by installing the project on WSL, this is where we will do all of our C++ code editing. 
In the directory you wish to clone the repository into run git clone. 
It is important to use `--recuse-submodules` when cloning to ensure all submodules fully populated. 
```shell
git clone --recuse-submodules https://github.com/James-Oswald/VirtualSlate.git
```
Next we will install our dependencies, the scons buildsystem and mingw to cross compile the extension for windows.  
```shell
sudo apt-get install scons gcc-mingw-w64
```

#### Building
Now we can build the extension for windows using SCons. In the root, every time you want to rebuild the C++ extension run:
```shell
scons platform=windows
```
NOTE The first time you run this it will take longer due to the need to build `godot-cpp` on subsequent runs only modified `.cpp` files will be rebuilt, making compilation much faster.
This will place the appropriate extension binary in `/project/bin`

#### Running Godot
After building the extension binary to `/project/bin`, you may now open the project in the godot editor. The godot editor should be run on windows and the project should be opened from its location
in the WSL filesystem. The project will identify the extension and automatically load it, letting you use objects from the extension in GDScript etc. 

NOTE: different versions of windows have different paths for WSL files. On windows 11 with WSL 2 paths to the WSL filesystem from windows look like: `\\wsl.localhost\Ubuntu\........\project`.