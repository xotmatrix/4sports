#!/bin/bash

# run from project root directory

cat res/GAMES.CONF |
    grep "," |
    grep -v "^#" |
    cut -d"," -f2 |
    cut -d"=" -f1 | \
    while read game; do
        # initialize attract mode configuration file for this game
        echo -e "#\n# Attract mode for $game\n# This file is automatically generated\n#\n" > /tmp/g

        # add box art, if any
        cat res/SS/SHR*.CONF |
            tr -d "\r" |
            egrep "(^|=)""$game""$" |
            cut -d"=" -f1 |
            sed -e "s/$/=C/g" |
            sort |
            uniq >> /tmp/g

        # add DHGR action screenshots, if any
        cat res/SS/ACTDHGR*.CONF |
            tr -d "\r" |
            egrep "(^|=)""$game""$" |
            cut -d"=" -f1 |
            sed -e "s/$/=B/g" |
            sort |
            uniq >> /tmp/g

        # add HGR action screenshots, if any
        for f in $(ls res/SS/ACT*.CONF | grep -v ACTDHGR | grep -v ACTGR); do
            cat "$f";
        done > /tmp/hgr
        cat /tmp/hgr |
            egrep "(^|=)""$game""$" |
            cut -d"=" -f1 |
            sed -e "s/$/=A/g" |
            sort |
            uniq >> /tmp/g

        # add GR action screenshots, if any
        cat res/SS/ACTGR*.CONF |
            egrep "(^|=)""$game""$" |
            cut -d"=" -f1 |
            sed -e "s/$/=D/g" |
            sort |
            uniq >> /tmp/g

        # add self-running demo, if any
        cat res/ATTRACT.CONF |
            grep "^$game=0" >> /tmp/g

        # add eof
        echo -e "\n[eof]" >> /tmp/g

        cat /tmp/g > res/ATTRACT/"$game"

        # clean up
        rm /tmp/g
        rm /tmp/hgr
    done
