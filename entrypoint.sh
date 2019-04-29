#!/bin/bash
#
# Entrypoint script--determine what it is we want to do.
#


if test "$1"
then

	if test "$1" == "--devel"
	then
		exec "/bin/bash"

# TODO: --url and urls.txt

	else 
		echo "! "
		echo "! Unknown args: $@"
		echo "! "
		echo "! Syntax: $0 ( --devel | --url URL | file.txt )"
		echo "! "
		exit 1

	fi

else
	echo "! "
	echo "! Syntax: $0 ( --devel | --url URL | file.txt )"
	echo "! "
	exit 1

fi

exit 0


if test "$1"
then
	echo "# "
	echo "# Arguments detected! "
	echo "# "
	echo "# Executing: $@"
	echo "# "

	exec "$@"

fi




