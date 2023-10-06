#This file builds Godot

FROM alpine
MAINTAINER "James Oswald <jamesoswald111@gmail.com> (jamesoswald.dev)"

RUN apk --update --no-cache add \
  git \
  scons \
  pkgconf \
  gcc \
  g++ \
  libx11-dev \
  libxcursor-dev \
  libxinerama-dev \
  libxi-dev \
  libxrandr-dev \
  mesa-dev \
  eudev-dev \
  alsa-lib-dev \
  pulseaudio-dev \
  mingw-w64-gcc

#Git clone godot so we can build
RUN git clone https://github.com/godotengine/godot.git -b 4.1.1-stable --depth 1
WORKDIR godot
RUN scons platform=windows

  



