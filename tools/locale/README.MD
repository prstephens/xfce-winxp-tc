# Localization Tools
This directory contains tools to help with localization.

## Tools Available
Below describes each tool in this directory (in order of importance).

### muiprep.sh
`muiprep.sh` is a script that prepares a working directory from Windows XP source files with which the other tools will use.

Essentially before you can use any of the other tools, you must run this one. What it does is scan a directory you provide for `I386` setup directories from MUI discs and the Windows XP setup disc.

I recommend you have a directory set up like so:

`<somewhere>/discs`

`<somewhere>/discs/MuiDisc1` (extracted contents of the first MUI disc)

`<somewhere>/discs/MuiDisc2` (extracted contents of the second MUI disc)

`<somewhere>/discs/MuiDisc3` (extracted contents of the third MUI disc)

`<somewhere>/discs/MuiDisc4` (extracted contents of the fourth MUI disc)

`<somewhere>/discs/MuiDisc5` (extracted contents of the fifth MUI disc)

`<somewhere>/discs/XPDisc` (extracted contents of a Windows XP with Service Pack 3 disc)

Then you can run `./muiprep.sh <somewhere>/discs` and it will build the working directory for you. It might take a while to decompress all the files.

Once done you should see a `mui-stuff` folder, and in it should be all the various languages and the XP source files.

### transpot.sh
(Needs implementing)

### scanstr.sh
Scans for translations of the provided string, using the MUI sources in the working directory set up by `muiprep.sh`.

For example:
```
scanstr.sh "Click here to begin"
```

Should output the resource string `Click here to begin`'s translations in each MUI in the format:
```
<ISO language code>#<translated string>
```

### mui2iso.sh
A simple script that simply maps the MUI language code (eg. `GER` or `SV`) to an ISO 639-1 language code as used by `.po` files.

For example:
```
mui2iso.sh SV
```

Will output:
```
sv_SE
```

With no newline after the output.
