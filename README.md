<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [What is k6](https://k6.readme.io/docs#section-what-is-k6)
- [Build Docker image from Dockerfile](#build-docker-image-from-dockerfile)
- [Running k6 command directly from this image](#running-k6-command-directly-from-this-image)
    - [Example for dummies](#example-for-dummies)
    - [A more useful example](#a-more-useful-example)
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
Unlike k6 [official doc](https://k6.readme.io/docs/running-k6), there's no entrypoint in our [Dockerfile](./Dockerfile). So you need to specify the **k6** command in the docker run command.

#### Example for dummies

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
#### A more useful example
 - ```docker run -v $(pwd)/samples:/opt/k6/samples```, bind [samples](./samples) folder into container.
 - ```k6 run /opt/k6/samples/http_get.js```, the command you wanna run in container. This is exactly the same as [running k6 binary](https://k6.readme.io/docs/running-k6#section-running-k6-the-first-time) without Docker.

```
$> docker run -v $(pwd)/samples:/opt/k6/samples dqa-k6 k6 run /opt/k6/samples/http_get.js

          /\      |‾‾|  /‾‾/  /‾/
     /\  /  \     |  |_/  /  / /
    /  \/    \    |      |  /  ‾‾\
   /          \   |  |‾\  \ | (_) |
  / __________ \  |__|  \__\ \___/ .io

  execution: local--------------------------------------------------]   servertor
     output: -
     script: /opt/k6/samples/http_get.js

    duration: -, iterations: 1
         vus: 1, max: 1

    init [----------------------------------------------------------] starting
time="2018-07-31T09:30:45Z" level=info msg="Test finished" i=1 t=859.3238ms
    data_received..............: 1.4 kB 1.6 kB/s
    data_sent..................: 86 B   100 B/s
    http_req_blocked...........: avg=449.79ms min=449.79ms med=449.79ms max=449.79ms p(90)=449.79ms p(95)=449.79ms
    http_req_connecting........: avg=357.06ms min=357.06ms med=357.06ms max=357.06ms p(90)=357.06ms p(95)=357.06ms
    http_req_duration..........: avg=410.75ms min=410.75ms med=410.75ms max=410.75ms p(90)=410.75ms p(95)=410.75ms
    http_req_receiving.........: avg=178µs    min=178µs    med=178µs    max=178µs    p(90)=178µs    p(95)=178µs
    http_req_sending...........: avg=262.2µs  min=262.2µs  med=262.2µs  max=262.2µs  p(90)=262.2µs  p(95)=262.2µs
    http_req_tls_handshaking...: avg=0s       min=0s       med=0s       max=0s       p(90)=0s       p(95)=0s
    http_req_waiting...........: avg=410.31ms min=410.31ms med=410.31ms max=410.31ms p(90)=410.31ms p(95)=410.31ms
    http_reqs..................: 1      1.163706/s
    iteration_duration.........: avg=860.96ms min=860.96ms med=860.96ms max=860.96ms p(90)=860.96ms p(95)=860.96ms
    iterations.................: 1      1.163706/s
    vus........................: 1      min=1 max=1
    vus_max....................: 1      min=1 max=1
```
 
 

## Set up a Jenkins job to run k6 task
- Please reference this job: https://jenkins.exosite.com/job/QA/job/k6-example/configure
