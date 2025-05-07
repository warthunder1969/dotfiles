#!/bin/bash
while :; do
  read -p "Enter a number between 700 and 3000: " number
  [[ $number =~ ^[700-3000]+$ ]] || { echo "Enter a valid number"; continue; }
  if ((number >= 700 && number <= 3000)); then
    echo "xsct set to $number"
    xsct $number
    exit 0
    break
  else
    echo "number out of range, try again"
    exit 0
  fi
done

