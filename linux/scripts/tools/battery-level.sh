#!/bin/bash

set -eu

BAT=BAT1
CHARGE_THRESHOLD_FILE="/sys/class/power_supply/$BAT/charge_control_end_threshold"
STATUS_FILE="/sys/class/power_supply/$BAT/status"
CHARGE_NOW_FILE="/sys/class/power_supply/$BAT/charge_now"
CHARGE_FULL_FILE="/sys/class/power_supply/$BAT/charge_full"

if [ $# -gt 1 ]
then
	echo "Usage: $0 [percentage]" >&2
	exit 1
fi

GOAL="${1-}"

CHARGE_NOW=$(<"$CHARGE_NOW_FILE")
CHARGE_FULL=$(<"$CHARGE_FULL_FILE")
CURRENT_CHARGE=$(awk "BEGIN { printf \"%.2f\", $CHARGE_NOW * 100 / $CHARGE_FULL }")
# CURRENT_CHARGE=$(( CHARGE_NOW * 100 / CHARGE_FULL ))
CURRENT_STATUS=$(<"$STATUS_FILE")

CURRENT_THRESHOLD=$(<"$CHARGE_THRESHOLD_FILE")

echo "Current threshold: $CURRENT_THRESHOLD%"
echo "Current charge:    $CURRENT_CHARGE% ($CURRENT_STATUS)"

if [ -n "$GOAL" ]
then
	echo "$GOAL" | sudo tee "$CHARGE_THRESHOLD_FILE" >/dev/null
	echo "Goal:    $GOAL%"
fi

