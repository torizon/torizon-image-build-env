### There are several ways to build torizon:

1. You can build using 
```
$ docker run -it -e MACHINE=<machine-id> <image_name>
```
And copy the image to host after the build is finished
```
$ docker cp <container_name>:/home/user/torizon/build-torizon/deploy .
```

2. Create a docker volume to sync with the container's files
```
$ docker volume create <volume>
$ docker run -it -v <volume>:/home/user/torizon -e MACHINE=<machine-id> <image_name>
```

3. It is possible to share folders between containers, such as:
```
docker run -it -v /path/to/downloads:/home/user/torizon/downloads -v /path/to/sstate-cache:/home/user/torizon/sstate-cache -v /path/to/deploy:/home/user/torizon/build-torizon/deploy -e MACHINE=<target> <image_name>
```

### Building other images

If you want to build images other than torizon-core-docker, pass the variable `-e TARGET=torizon-...` when running the container