# so fulla ►

![capture](https://github.com/qoelet/so-fulla/blob/master/so-fulla.png?raw=True)

A minimal CLI music player.

## requires

On most Nix systems,

```shell
$ sudo aptitude install libpulse-dev libsndfile-dev
$ stack install
```

## usage

```shell
fs
      --source=string (optional)
      --playlist=string (optional)
      --sink=string (optional)
      --shuffle
  -h  --help                        show help and exit
```

You can specify a single file or folder using the `--source`, for example:

```shell
$ fs --source /home/foo/music/foo.flac
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

If `songs` are not specified, the `location` is read and played.

You can also specify any other DAC using the `--sink` by passing in the name of the sink.

## interaction during playback

During playback,

<kbd>SPACE</kbd> to skip to next song

<kbd>q</kbd> to quit
