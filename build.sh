#Build Custom Godot Into Image
podman build -t godot .
#Copy Cutom Godot out of the Image
podman create --name godot localhost/godot
podman cp godot:bin/ build
podman rm godot