#!/bin/bash

#Challenge
today=$(date +%Y-%m-%d)
challenge_length=30 #this should be the length in days
challenge=$(echo "$challenge_length days")
start=2024-12-03 # should be in YYYY-MM-DD format
end=$(date -d "$start + $challenge_length days" '+%Y-%m-%d')
progress=$(( ($(date -d "$start" +%s) - $(date -d "$today" +%s)) / (60*60*24) ))
left=$(( ($(date -d "$end" +%s) - $(date -d "$today" +%s)) / (60*60*24) ))


#Main Output
echo -e "\033[33m┌─────────────────────── Challenge ──────────────────┐\033[m"
echo -ne "\033[33mChallenge Length: \033[m"
echo $challenge
echo -ne "\033[33m ├Start: \033[m"
echo $start
echo -ne "\033[33m ├Today: \033[m"
echo $today
echo -ne "\033[33m ├End: \033[m"
echo $end
echo -ne "\033[33m ├Progress: \033[m"
echo $progress days
echo -ne "\033[33m └Left: \033[m"
echo $left days

echo -e "\033[33m└────────────────────────────────────────────────────┘\033[m"

