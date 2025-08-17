#!/bin/bash
#How to recursively chmod a folder?
#source:https://superuser.com/questions/1325221/linux-how-to-recursively-chmod-a-folder
# Check current DPMS status
sudo find . -type d -print0 | xargs -0 chmod -R a+rwX
