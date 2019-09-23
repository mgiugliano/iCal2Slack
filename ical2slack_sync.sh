#!/usr/bin/env bash
#
# iCal 2 Slack (status) synchronization
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# This simple bash script leverage the
# icalBuddy and the slack-cli software
# to maintain "in sync" one's status on
# Slack with the iCal schedule:
# If "right now" there is an event, the
# script updates the status, otherwise it
# clears it.
#
# If the event title contains the keyword
# "Busy" or the keyword "Lunch", the status
# is customised.
#
# August 7th, 2019 - Michele Giugliano, mgiugliano@gmail.com
#

echo "Checking the agenda... (hold on)"

# This only extracts the time of the event
var=$(icalBuddy -ea -iep datetime eventsNow)

# This extracts the substring of the ending time
til=$(echo $var | awk -F' ' '{print $4}')

# This extracts the title
title=$(icalBuddy -ea -nc -iep title eventsNow)

# It is not ideal to call twice icalBuddy (which has a
# rather long execution time). I found no other way to
# parse the event title and the datetime strings, as the
# title might contain an arbitrary number of spaces (and awk
# would fail).

echo "done!"
echo ""


echo "Setting my Slack's status accordingly..."
echo ""

if [ -z "$var" ]
then
      #echo "\$var is empty"
	  slack status clear > /dev/null
	  echo "No events: status is cleared."
else
      #echo "\$var is NOT empty"
	  slack status edit "In a meeting [until $til]" :spiral_calendar_pad: > /dev/null
	  echo "In a meeting: status is changed accordingly."

	  if [[ $title == *"Lunch"* ]]; then
       	  slack status edit "Out for lunch [until $til]" :hamburger: > /dev/null
		  echo "Lunch break!"
      fi

	  if [[ $title == *"Busy"* ]]; then
       	  slack status edit "Busy [until $til]" :tomato: > /dev/null
		  echo "Pomodoro session!"
      fi
fi
echo ""
