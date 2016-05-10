#!/bin/bash

set -eu

# Get pip version number
PIPVER=`pip --version | awk '{print $2}'`
ARGS=""

echo "peep.sh: Using pip $PIPVER"

# Add pip arguments that vary according to the version of pip, here:
case $PIPVER in
    1.5*|6.*)
        # Pip uses the wheel format packages by default in pip 1.5+.
        # However in pip < 6.0+ wheel support is broken, and even with pip 6.0+
        # we intentionally don't use the wheel packages, since otherwise each
        # package in the requirements files would need multiple hashes.
        echo "peep.sh: Wheel-using pip detected, so passing --no-use-wheel."
        ARGS="$ARGS --no-use-wheel"
        ;;
    7.*)
        echo "peep.sh: Binary-using pip detected, so passing --no-binary=:all:"
        ARGS="$ARGS --no-binary=:all:"
        ;;
    1.*)
        # A version of pip that won't automatically use wheels.
        ;;
    *)
        echo "peep.sh: Unrecognized version of pip: $PIPVER".
        echo "peep.sh: I don't know what to do about that."
        echo "peep.sh: Maybe try to install pip 7?"
        echo "peep.sh: \"pip install -U 'pip==7'\""
        exit 1
        ;;
esac

# Add the version specific arguments to those passed on the command line.
python ./bin/peep.py "$@" $ARGS

echo "peep.sh: Done!"
