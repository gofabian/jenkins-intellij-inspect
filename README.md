# jenkins-intellij-inspect

Run IntelliJ inspection as Jenkins build step.


## Run IntelliJ inspection manually

Build Ubuntu image with IntelliJ IDEA installed:

    $ docker build -f Dockerfile-idea -t idea .

Run `inspect` from the root of this repository:

    $ docker run --rm -v $(pwd):/prj idea sh -c 'idea.sh inspect /prj /prj/.idea/inspectionProfiles/Project_Inspections.xml /prj/target/idea_inspections -v2 -d /prj/src'


## Run Jenkins in Docker

Take the original jenkins image and add the Docker binary:

    $ docker build -f Dockerfile-jenkins -t jenkins-docker .

Enable the Jenkins container to access the Docker socket on the host.

    $ export DOCKER_SOCK_GROUP=$(stat -c '%g' /var/run/docker.sock)
    $ docker run --rm \
        --group-add $DOCKER_SOCK_GROUP \
        -e DOCKER_SOCK_GROUP \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -p 8080:8080 \
        -v jenkinsdocker:/var/jenkins_home \
        jenkins-docker


## Run IntelliJ inspection from Jenkins Pipeline

[see Jenkinsfile](Jenkinsfile)

![Result](/doc/jenkins.png)
