#!/usr/bin/env bash
#

BEEP='ogg123 -q /usr/share/sounds/freedesktop/stereo/bell.oga'
#BEEP='beepbop short_up'

_help() {
cat <<EOF
Usage:
    $(basename $0) <option>

Options:
    sp : screen to pictures
    rp : region to pictures
    wp : window to pictures
    sc : screen to clipboard
    rc : region to clipboard
    wc : window to clipboard

Shortcuts:
    PrtSc                : screen to pictures
    PrtSc + Shift        : region to pictures
    PrtSc + Alt          : window to pictures
    PrtSc + Ctrl         : screen to clipboard
    PrtSc + Ctrl + Shift : region to clipboard
    PrtSc + Ctrl + Alt   : window to clipboard
EOF
}

case "$1" in
    sp)
        # PrtSc                : screen to pictures
        scrot    '%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'mv $f ~/docs/images/screenshots/desktop/'
        ;;
    rp)
        # PrtSc + Shift        : region to pictures
        sleep 0.3; scrot -s '%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'mv $f ~/docs/images/screenshots/desktop/'
        ;;
    wp)
        # PrtSc + Alt          : window to pictures
        scrot -u '%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'mv $f ~/docs/images/screenshots/desktop/'
        ;;
    sc)
        # PrtSc + Ctrl         : screen to clipboard
        scrot    '/tmp/%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'xclip -sel c -t image/png $f && rm $f'
        ;;
    rc)
        # PrtSc + Ctrl + Shift : region to clipboard
        sleep 0.3; scrot -s '/tmp/%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'xclip -sel c -t image/png $f && rm $f'
        ;;
    wc)
        # PrtSc + Ctrl + Alt   : window to clipboard
        Print + alt + ctrl
        scrot -u '/tmp/%Y-%m-%d_%H:%M:%S_$wx$h.png' -e 'xclip -sel c -t image/png $f && rm $f'
        ;;
    *)
        _help
        exit 0
        ;;
esac

[ "$BEEP" ] && exec $BEEP

