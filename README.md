# docker-images-cleanup

In this script we are going to delete all unused images, stooped containers, volumes and network

`Note: This script can't delete the running containers or the images which is used by running containers`

We just need to run the docker-cleanup.sh script file

`./docker-cleanup.sh`

### You can also use this script with ansible.

`Note: By default this script delete the data from 14 days older, If want to change the duration of delete data then you shoud speciy the duration in hour with the script`

Example:

`./docker-cleanup.sh 168   # we need to specify the duration while running the script, by default its value is 336`

The above example 168(hour) is the duration from which the data will delete.
