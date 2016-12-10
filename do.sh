#!/bin/bash                                                                              


operation=$1
mode=$2
opt=$3

function print_help() {
	echo "Usage: do OPERATION MODE [OPTIONS]"
	echo ""
	echo "  OPERATION:  build   - to build the configuration"
	echo "              run     - to run the configuration"
	echo ""
	echo "  MODE:       dev     - development mode; frontend & services"
	echo "                      served from within ./data/dev subdirectories"
	echo "              prod    - production mode; frontend & services"
	echo "                      served from the container"
	echo ""
	echo "  OPTIONS:    --no-cache - ignore cache while building the configuration"
	echo "                         (for build operation only)"
	echo ""
	echo "! NOTE: for production configuration(for any modes) some environment variables must be set!"
	echo "!! NOTE2: you MUST build configuration before running it"
}

function is_operation_valid() {
	case "$operation" in
		"build"|"run" )
			let $1=1;;
		*)
			let $1=0;;
	esac
}

function is_mode_valid() {
	case "$mode" in
		"dev"|"prod" )
			let $1=1;;
		*)
			let $1=0;;
	esac
}

is_operation_valid operation_vaild
is_mode_valid mode_valid
all_ok=$(($operation_vaild+$mode_valid))


if [ "$all_ok" != "2" ]
then
	print_help
	exit
fi

# everything is okay

function check_env_vars() {
	expected_env_variables=(ACCOUNTS_VERSION INNOPOINTS_VERSION FRONTEND_VERSION BOT_VERSION)

	flag=1

	for v in "${expected_env_variables[@]}"
	do
	  if [ -z "${!v}" ]
	  then
	    echo "[!] environment variable is not set: $v"
	    flag=0
	  fi
	done

	if [ $flag -eq 0 ]
	then
	  echo ">> Some of environment variables were not set so can't proceed"
	  return 0;
  	else
  	  return 1;
	fi
}

if [ $operation == "build" ]
then
	check_env_vars
	vars_ok=$?

	if [ "$vars_ok" == "0" ]
	then
		echo "Can not proceed.. Take a closer look at NOTE2 in help."
		print_help
		exit
	fi

	if [ $mode == "dev" ]
	then
		echo ">> building development version.."
		echo ""
		docker-compose -f base.yml -f dev.yml build $opt # can be --no-cache
		echo ""
		echo ">> Done!"
		exit
	fi

	if [ $mode == "prod" ]
	then
		echo ">> building production version.."
		echo ""
		docker-compose -f base.yml -f prod.yml build $opt # can be --no-cache
		echo ""
		echo ">> Done!"
		exit
	fi
fi

if [ $operation == "run" ]
then
	if [ $mode == "dev" ]
	then
		echo ">> running development version.."
		echo ""
		docker-compose -f base.yml -f dev.yml up
		echo ""
		echo ">> Done!"
		exit
	fi

	if [ $mode == "prod" ]
	then
		echo ">> running production version.."
		echo ""
		docker-compose -f base.yml -f prod.yml up
		echo ""
		echo ">> Done!"
		exit
	fi
fi