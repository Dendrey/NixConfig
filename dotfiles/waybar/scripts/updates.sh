#!/bin/bash

count=$(checkupdates | wc -l)
echo "{\"text\":\"$count\"}"

