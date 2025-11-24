#!/usr/bin/env bash

# This script aims to adhere to the Google Shell Style Guide: https://google.github.io/styleguide/shellguide.html

# Full system path to the directory containing this file, with trailing slash.
# This line determines the location of the script even when called from a bash
# prompt in another directory (in which case `pwd` will point to that directory
# instead of the one containing this script).  See http://stackoverflow.com/a/246128
MYDIR="$( cd -P "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )/"

# Source config file or exit.
if [ -e "${MYDIR}/config.sh" ]; then
  source "${MYDIR}/config.sh"
else
  echo "Could not find required config file at ${MYDIR}/config.sh. Exiting."
  exit 1
fi

# Print usage.
function usage {
  echo "Usage: $0 [up|down]"
  echo "  Change screen brightness up or down by on incremental pre-set percentage of max brightness"
  echo "See also: README and config.sh in $MYDIR.";
  exit 1;
}

# Print fatal error to STDERR and kill script.
function fatal {
  >&2 echo "FATAL ERROR: $1";
  exit 1;
}

# Ensure up or down argument, or print usage.
if [[ "$1" != "up" && "$1" != "down" ]]; then
  usage;
fi


device_base="/sys/class/backlight/$DEVICE/"

if [[ ! -w "$device_base/brightness" ]]; then
  fatal "Brightness file $device_base/brightness is not writable, or does not exist. (Hint: check DEVICE value in $MYDIR/config.sh)"
fi


# Specify config defaults:
INCREMENT_PERCENT="${INCREMENT_PERCENT:-5}"
MIN_PERCENT="${MIN_PERCENT:-1}"
if [[ "$MIN_PERCENT" -lt "1" ]]; then
    MIN_PERCENT="1";
fi

max=$(cat $device_base/max_brightness)
cur=$(cat $device_base/brightness)

# calculate step size (bump) and min brightness.
bump=$(( max * INCREMENT_PERCENT / 100 ))
min=$(( max * MIN_PERCENT / 100 ))

# Calculate new value based on inputs. (Note, we've already verified that $1 is 
# a valid value "up" or "down".
if [[ "$1" == "up" ]]; then
  new=`echo "$cur + $bump" | bc`
else
  new=`echo "$cur - $bump" | bc`
fi

# Ensure brightness doesn't exceed max or min.
if [[ "$new" -lt $min ]]; then
  new=$min
elif [[ "$new" -gt $max ]]; then
  new=$max
fi

# Save the new value to the file.
echo $new | tee $device_base/brightness

