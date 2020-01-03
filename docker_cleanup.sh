#!/bin/bash

docker_space_before () {

	echo "#####################################################################" 
	echo "Current Docker Space:"
	echo "#####################################################################" 
	docker system df

}

docker_find () {

	echo "#####################################################################" 
	echo "Finding images which is build 14 days ago"
	echo "#####################################################################"

	REMOVEIMAGES=`docker images | grep " [months|weeks]* ago" | awk '{print $3}'`

	echo "---------------------------------------------------------------------"
	echo "Listing images that needs to be cleaned up"
	echo "---------------------------------------------------------------------"

	docker images | grep " [months|weeks]* ago" | awk '{print $3}'

	echo "#####################################################################" 
	echo "Finding Created containers, but it has never been started."
	echo "#####################################################################"

	CREATED=`docker ps -q -f status=created`

	echo "---------------------------------------------------------------------"
	echo "Listing Created containers, but it has never been started."
	echo "---------------------------------------------------------------------"

	docker ps -f status=created

	echo "#####################################################################" 
	echo "Finding exited containers"
	echo "#####################################################################"

	EXITED=`docker ps -q -f status=exited`

	echo "---------------------------------------------------------------------"
	echo "Listing exited containers that needs to be cleaned up"
	echo "---------------------------------------------------------------------"

	docker ps -f status=exited

	echo "#####################################################################" 
	echo "Finding dangle images"
	echo "#####################################################################"

	DANGLE=`docker images -q -f dangling=true`

	echo "---------------------------------------------------------------------"
	echo "Listing dangling images that needs to be cleaned up"
	echo "---------------------------------------------------------------------"

	docker images -f dangling=true

	echo "#####################################################################" 
	echo "Finding dangle volumes"
	echo "#####################################################################"

	DANGLEVOLUMES=`docker volume ls -q -f dangling=true`

	echo "---------------------------------------------------------------------"
	echo "Listing dangling volumes that needs to be cleaned up"
	echo "---------------------------------------------------------------------"

	docker volume ls -f dangling=true

}

docker_cleanup () {

    echo "#####################################################################"
	echo "Removing Created containers"
	echo "#####################################################################"

	docker rm ${CREATED}

    echo "#####################################################################"
	echo "Removing exited containers"
	echo "#####################################################################"

	docker rm ${EXITED}

	echo "#####################################################################"
	echo "Cleaning images"
	echo "#####################################################################"

	docker rmi ${REMOVEIMAGES}

	echo "#####################################################################"
	echo "Removing dangling images"
	echo "#####################################################################"

	docker rmi ${DANGLE}

	echo "#####################################################################"
	echo "Removing dangling volumes"
	echo "#####################################################################"

	docker volume rm ${DANGLEVOLUMES}

}

docker_space_after () {

	echo "#####################################################################" 
	echo "Current Docker Space, after clean up:"
	echo "#####################################################################" 

	docker system df
}

docker_space_before
docker_find
docker_cleanup
docker_space_after
