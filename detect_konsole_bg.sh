#!/bin/bash
COLORSCHEME_WHITE="f9f9"
old_stty_conf="$(stty -g)"
stty -icanon -echo min 0 time 1 ; printf '\e]11;?\e\\'; read bg
bg_term_val=$(echo $bg | cat -A)
#stty ${old_stty_conf}
if [ -n "${bg_term_val}" ]; then
	echo "${bg_term_val##*rgb:}" | cut -d'/' -f1 | grep -q $COLORSCHEME_WHITE && echo "light"
	exit 0
else 
	if [ -n "$COLORFGBG" ]; then
		if [ "${COLORFGBG##*;}" -ne 0 ]; then
			echo "light"
			exit 0
		fi
	fi
fi
echo "dark"
