Definition is Work-in-Progress

A container image providing an environment to build TordyOS

You can build using 
```
$ docker run -it -e MACHINE=<machine-id> <image_name>
```
And copy the image to host after the build is finished
```
$ docker cp <container_name>:/home/user/torizon/build-torizon/deploy .
```

**or**

Create a docker volume to sync with the container's files
```
$ docker volume create <volume>
$ docker run -it -v <volume>:/home/user/torizon -e MACHINE=<machine-id> <image_name>
