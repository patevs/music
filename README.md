# Music Scripts

> Setup a disposable environment for downloading music from Spotify including metadata.

---

## Usage Instructions

❗️ **This tool works only with Python 3.6+**

Run the setup script:

```powershell
.\music.ps1
```

For the most basic usage, downloading tracks and playlists is as easy as:

```powershell
# Download song:
spotdl -s <song-url>
```

```powershell
# Save playlist to file:
spotdl -p <playlist-url>
# Download songs from playlist file:
spotdl --list <playlist-file>
```

---

## Project Structure

```md
.
├── docs                # Documentation
├── scripts             # Unused scripts
├── .editorconfig       # Editor configuration
├── .gitignore          # Git ignore rules
├── .np-config.json     # NPM publish (np) configuration
├── config.yml          # spotdl configuration
├── LICENSE             # Project LICENSE
├── music.ps1           # Music environment setup script
├── package.json        # NPM package configuration
└── README.md           # Project README
```

---

## Disclaimer

Downloading copyright songs may be illegal in your country.
This tool is for educational purposes only and was created only to show
how Spotify's API can be exploited to download music from YouTube.
Please support the artists by buying their music.

---

## License

[![License](https://img.shields.io/github/license/patevs/music.svg)](https://github.com/patevs/music/blob/master/LICENSE)

---
