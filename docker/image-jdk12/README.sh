Drifter Base Image
===

# Building
```sh
build.sh
```

# Running
Start the container:
```sh
docker run -it --rm --name drifter-jdk12 -p 22:22 -e DIND_HOST=localhost obsidiandynamics/drifter-jdk12
```

Connect to the image:
```sh
ssh root@localhost -i ~/.vagrant.d/insecure_private_key
```