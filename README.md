<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Build Docker image from Dockerfile](#build-docker-image-from-dockerfile)
- [Running k6 command directly from this image](#running-k6-command-directly-from-this-image)
- [Set up a Jenkins job to run k6 task](#set-up-a-jenkins-job-to-run-k6-task)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Build Docker image from [Dockerfile](./Dockerfile)
- This should only be done when you are developing or modifing Dockerfile in local environment.

```bash
$> docker build -t=dqa-k6 .
Sending build context to Docker daemon  210.9kB
Step 1/14 : FROM golang:1-alpine as builder
...
Step 14/14 : COPY --from=builder /go/bin/k6 /usr/bin/k6
 ---> e82f8c411417
Successfully built e82f8c928374
Successfully tagged dqa-k6:latest
```
- List the image just built.

```
$> docker images
REPOSITORY    TAG    IMAGE ID        CREATED    SIZE
dqa-k6     latest  e82f8c928374  8 minutes ago  22.3MB
```

## Running k6 command directly from this image
Unlike k6 [official doc](https://k6.readme.io/docs/running-k6), there's no entrypoint in our [Dockerfile](./Dockerfile). So you need to specify the **k6** command in the docker run command. e.g.

```
$> docker run dqa-k6 k6 --help
```
- ```docker run dqa-k6``` means to run a Docker container from the image just built.
- ``` k6 --help``` means run this command when the container is up.

You should see something like this in your console output:

```

          /\      |‾‾|  /‾‾/  /‾/
     /\  /  \     |  |_/  /  / /
    /  \/    \    |      |  /  ‾‾\
   /          \   |  |‾\  \ | (_) |
  / __________ \  |__|  \__\ \___/ .io

Usage:
  k6 [command]

Available Commands:
  archive     Create an archive
  cloud       Run a test on the cloud
  convert     Convert a HAR file to a k6 script
  help        Help about any command
  inspect     Inspect a script or archive
  login       Authenticate with a service
  ...
  ...
```

## Set up a Jenkins job to run k6 task
- Please reference this job: https://jenkins.exosite.com/job/QA/job/k6-example/configure
