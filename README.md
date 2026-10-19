# Les jeux d'Emma

Small games for a 3-year-old: tap, paint, stickers, puzzles, animals. Game text is in French. Everything runs offline in a browser, with no server, no install and no network.

## Play

Online: **https://underscorelog.github.io/emma-games/** (GitHub Pages, published from `main`).

Offline: open `index.html` (double-click). Tap a tile. Each game opens fullscreen on its big play button; the round house button at the top left comes back to the menu.

## Layout

| Path | What it is |
|---|---|
| `index.html` | The menu, with a "Pour les parents" notes section at the bottom |
| `jeux/NN-nom-du-jeu.html` | One self-contained game per file (HTML, CSS and JS inline). `00-peppa-pig.html` is the Peppa game |
| `FOUNDATIONS.md` | The rules every game follows. Read it before adding or changing a game |
| `icone.png` | Home screen icon shared by all pages |
| `sons/` | Optional real recordings (`sons/<name>.mp3`, names in `LISEZMOI.txt`). A missing file falls back to a synthesized sound |
| `peppa/` | Peppa character images used by the menu and game 21; `peppa/sources/` holds the originals used to prepare the Peppa game |
| `outils-peppa/` | PowerShell scripts that cut out and embed images into the Peppa game |
| `docs/` | Extra notes and screenshots for some games |

## Adding a game

Follow `FOUNDATIONS.md`: next free number in `jeux/`, tile first in the "🧪 En test" section of `index.html`, then moved to its section once it has been played and validated.

## Note

The Peppa Pig images (`peppa/`, `jeux/00-peppa-pig.html`, `jeux/21-roues-autobus.html`) are copyrighted and meant for private family use only.
