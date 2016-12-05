#!/bin/bash

# initialize
VERSION="0.0.1"

# functions

# The script version
#
# Returns:
#   string: version number
function version {
    echo "See git steps: $VERSION"
}

# main
## get options of the script
while true; do
    case "$1" in
	-V | --version ) version; exit 1; ;;
	-- ) shift; break ;;
	* ) break ;;
    esac
    shift
done
