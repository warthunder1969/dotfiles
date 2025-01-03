#!/bin/bash

#Challenge
today=$(date +%Y-%m-%d)
challenge_length=30 #this should be the length in days
challenge=$(echo "$challenge_length days")
start2=2024-12-03 # should be in YYYY-MM-DD format
start=$(date -d$(ls -alct / --time-style=full-iso|tail -1|awk '{print $6}') +'%Y-%m-%d')
end=$(date -d "$start + $challenge_length days" '+%Y-%m-%d')
progress=$(( ($(date -d "$today" +%s) - $(date -d "$start" +%s)) / (60*60*24) ))
left=$(( ($(date -d "$end" +%s) - $(date -d "$today" +%s)) / (60*60*24) ))


#Main Output
echo -e ""
echo -ne "\033[33mChallenge Length: \033[m"
echo $challenge
echo -ne "\033[33mStart: \033[m"
echo $start
echo -ne "\033[33mToday: \033[m"
echo $today
echo -ne "\033[33mEnd: \033[m"
echo $end
echo -ne "\033[33mProgress: \033[m"
echo $progress days
echo -ne "\033[33mLeft: \033[m"
echo $left days

echo -e ""

