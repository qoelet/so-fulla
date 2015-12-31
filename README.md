# so fulla ►

![capture](https://github.com/qoelet/so-fulla/blob/master/so-fulla.png?raw=True)

a minimal commandline music player.

## usage

```shell
fs
      --source=string (optional)
      --playlist=string (optional)
      --sink=string (optional)
      --shuffle
  -h  --help                        show help and exit
```

you can specify a single file or folder using the `--source`, for example:

```shell
$ fs --source /home/music/foo.flac --sink alsa_output.usb-Schiit_Audio_I_m_Fulla_Schiit-00-Schiit.analog-stereo
```

or use a playlist (YAML). an example:

```yaml
- name: "The Black Light"
  artist: "Calexico"
  location: "/home/music/Calexico_The_Black_Light"

- name: "Born Under Saturn"
  artist: "Django Django"
  location: "/home/music/Django\ Django\ -\ Born\ Under\ Saturn\ -\ 2015\ [FLAC]"
  songs:
    - "01 Giant.flac"
    - "02 Shake and Tremble.flac"
    - "03 Found You.flac"
    - "04 First Light.flac"
```
if `songs` are not specified, the `location` is read and played.

you can also specify any other DAC using the `--sink` by passing in the name of the sink.

## interaction during playback

during playback,

<kbd>SPACE</kbd> to skip to next song

<kbd>q</kbd> to quit

## disclaimer

only `flac` or `wav` files.

experimental, use at your own risk.
