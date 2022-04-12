#!/usr/bin/env bash
#

BEEP='ogg123 -q /usr/share/sounds/Yaru/stereo/battery-low.oga'
UEVENT=/sys/class/power_supply/BAT0/uevent
MIN=5
MAX=80

source $UEVENT
if [ "$POWER_SUPPLY_CAPACITY" -gt $MIN ] && [ "$POWER_SUPPLY_CAPACITY" -lt $MAX ]; then
    $BEEP
else
    BEEP_DELAY=20
    STATUS=$POWER_SUPPLY_STATUS
    until [ "$POWER_SUPPLY_STATUS" != $STATUS ]; do
        $BEEP
        sleep $BEEP_DELAY
        source $UEVENT
    done
fi

