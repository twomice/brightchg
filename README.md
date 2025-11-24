# brightchg
## Linux display brightness control
The work is licensed under [GPL-3.0](LICENSE.txt).

Most modern desktop environments (DEs) already provide mechanisms for adjusting screen
brightness in some way that most their users like.  Some do not, e.g.:
- There is no menu item revealing a screen-brightness setting;
- The DE only provides mouse-driven controls, but the user wants shortcut keys.

This script simply aims to expose screen brightness controls through bash execution,
which can of course be accessed by shortcut keys in most DEs.

## Usage
From the bash command line, call this script with an argument of either "up" or "down"
to raise or lower screen brightness.

## Configuration
Copy config.sh.dist to config.sh, and edit per the comments in that file. Specifically:

### DEVICE
This config setting should name a directory under /sys/class/backlight representing
the relevant backlight device. This directory should already contain files named
`brightness` and `max_brightness`.

If there is more than one device (directory), consult documentation for your system
to determine which one is relevant (active), or inspect the files yourself, and/or
perform trial-and-error testing. 

For trial-and-error testing, this author recommends using values of X and Y, where
X is the value contained in the device's `max_brightness` file, and Y is half of that
value (50% brightness). Avoid using "0" (per warning at top of this README).

## Setup/installation
Do whatever you want, but a reasonable expected installation would go like so:
1. Clone this project to your local system.
2. Configure as explained above.
2. Symlink the file `brightchg.sh` to some location in your path, e.g.  
   `ln -s $local_repo_path/brightchg.sh ~/bin/.`
3. (Optional but recommended): Allow non-root changes to screen brightness by  
   ensuring that the `brightness` file is world-writable; on many systems, perms
   for such files are re-set at boot time, so you probably want to configure your
   system to do `chmod a+w` on this file immediately after every system boot.
   If this file is not writable by your user, `brightchg` won't be able to
   adjust your brightness.
4. (Optional but recommended): Configure shortcut keys ("hot keys") in your desktop
   software to call `brightchg up` and `brightchg down` on certain keys, for
   maximum convenience. (E.g. assign the keys Alt-Up and Alt-Down to adjust brightness
   up and down, respectively.)
