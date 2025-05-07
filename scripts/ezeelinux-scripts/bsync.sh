#!/bin/bash

echo "Warthunder's rsync backup script'"
echo "What is the source?(Be sure to use absolute paths)"
read A1

echo "What is the destination?"
read B1
echo Source: $A1
echo Destination: $B2
echo "the command will be: 'rsync -az $A1 $B1'"

read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
sudo rsync -az $A1  $B1
else
echo "Abort Mission"
    exit 0
fi






