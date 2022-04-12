#!/usr/bin/env bash
#

PRTSCR_FNAME='%Y-%m-%d_%H:%M:%S_$wx$h.png'
PRTSCR_DIR=~/docs/images/screenshots/desktop/

PRTSCR_BEEP='ogg123 -q /usr/share/sounds/freedesktop/stereo/bell.oga'
#PRTSCR_BEEP='beepbop short_up'

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
        scrot    $PRTSCR_FNAME -e "mv $f $PRTSCR_DIR"
        ;;
    rp)
        # PrtSc + Shift        : region to pictures
        sleep 0.3; scrot -s $PRTSCR_FNAME -e "mv $f $PRTSCR_DIR"
        ;;
    wp)
        # PrtSc + Alt          : window to pictures
        scrot -u $PRTSCR_FNAME -e "mv $f $PRTSCR_DIR"
        ;;
    sc)
        # PrtSc + Ctrl         : screen to clipboard
        scrot    /tmp/$PRTSCR_FNAME -e 'xclip -sel c -t image/png $f && rm $f'
        ;;
    rc)
        # PrtSc + Ctrl + Shift : region to clipboard
        sleep 0.3; scrot -s /tmp/$PRTSCR_FNAME -e 'xclip -sel c -t image/png $f && rm $f'
        ;;
    wc)
        # PrtSc + Ctrl + Alt   : window to clipboard
        Print + alt + ctrl
        scrot -u /tmp/$PRTSCR_FNAME -e 'xclip -sel c -t image/png $f && rm $f'
        ;;
    *)
        _help
        exit 0
        ;;
esac

[ "$PRTSCR_BEEP" ] && exec $PRTSCR_BEEP

