#!/bin/bash

DURATION=${1:-336}

declare -a arr=('image' 'container' 'volume' 'network')

docker_space () {

	echo "#####################################################################" 
	echo "Docker Space ${1} cleanup:"
	echo "#####################################################################" 

	docker system df

}

docker_cleanup () {

    echo "#####################################################################"
	echo "Removing unused $1"
	echo "#####################################################################"

	docker $1 prune $2 $3 $4

}

while true; do

    echo "******************************************************************************************************************************************"
    read -p "Do you wish to remove unused images, stopped containers, unused volumes and unused network which is older than $DURATION hour ? (Y/N): " yn
    echo "******************************************************************************************************************************************"

    case $yn in
        [Yy]* ) docker_space "before";

                for i in ${arr[@]}; do

                	if [ $i = 'image' ]; then
                		docker_cleanup $i --all --filter "until=${DURATION}h"; 
                	fi

                	if [ $i = 'container' -o $i = 'network' ]; then
                		docker_cleanup $i --filter "until=${DURATION}h"; 
                	fi

                	if [ $i = 'volume' ]; then
                		docker_cleanup $i; 
                	fi

                done;

                docker_space "after";

                break;;

        [Nn]* ) break;;

        * ) echo "Please answer in yes(y) or no(n)";;

    esac

done
