Definition is Work-in-Progress

A container image providing an environment to build TordyOS

You can build using 
```
$ docker run -it -e MACHINE=<machine-id> <image_name>
```

After the build is finished, copy the image to your local computer
```
$ docker cp <container_name>:/home/user/torizon/build-torizon/deploy .
```
