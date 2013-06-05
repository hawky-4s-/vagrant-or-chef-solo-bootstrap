#!/usr/bin/env bash

exists()
{
    if command -v $1
    then
        echo " Yes, command :$1: was found."
        return 1
    else
        echo " No, command :$1: was NOT found."
        return 0
    fi
}
