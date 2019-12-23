I would like to have my status on Slack reflecting my iCal schedule. Thus, if there is an event scheduled on my calendar, my status should change automatically to "Busy" or "In a meeting" and be cleared otherwise.
I am aware that some App exists for this purpose but they require the user to share/broadcast one's calendar with an external company, driving the automation. I am not comfortable with this step, so I wrote a simple bash script (to be launched by cron every minute) run locally:

'#!/usr/bin/env bash

title=$(icalBuddy -ea -nc -iep title eventsNow)

if [ -z "$title" ]
then
	  slack status clear > /dev/null
else
	  slack status edit "In a meeting" :spiral_calendar_pad: > /dev/null

	  if [[ $title == *"Lunch"* ]]; then
       	  slack status edit "Out for lunch" :hamburger: > /dev/null
		  echo "Lunch break!"
      fi
fi'

It works after (brew) installing two utilities:
- iCalBuddy (https://hasseg.org/icalBuddy)
- slack-cli (https://github.com/rockymadden/slack-cli)

I hope someone else finds this interesting or inspiring for another application.
