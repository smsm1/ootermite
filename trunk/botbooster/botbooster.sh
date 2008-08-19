#!/bin/sh
BOTBOOSTER_ADMIN=<adminmail>
WORKDIR=~/botbooster/

cd $WORKDIR
java -cp botbooster.jar:soap.jar:mailapi.jar:activation.jar botbooster.Main "ready for QA"
cat "bot.log" | mail -s "BotBooster Status Report" $BOTBOOSTER_ADMIN
