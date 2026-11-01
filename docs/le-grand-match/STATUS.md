# Le grand match - status

Idea: an easy football match for a 3-year-old who likes watching football.
Slug: le-grand-match. Size: S. Phase: 5 (fun gate).

## Decisions

- 2026-11-01: lives in emma-games as game 37, not its own project folder, FOUNDATIONS.md applies. Spec and ledger stay in docs/le-grand-match/.
- 2026-11-01: core loop is a mixed match of 5 goals: passes, penalty, keeper saves then counter-attack, passes with a fork, penalty.
- 2026-11-01: she picks one of 4 shirts, colours only, no crests or real names.
- 2026-11-01: every shot scores. Keeper failures are the joke, about 1 shot in 4 hits the post and goes in.
- 2026-11-01: real CC0 crowd, whistle and kick recordings wanted, optional files in sons/, synth fallback. Each file is approved before download.

## Work packages

| WP | What | Owns | Dispatch | State |
|---|---|---|---|---|
| WP01 | Build the whole game | jeux/37-le-grand-match.html | subagent, opus, high | merged |
| WP02 | Find CC0 sound candidates, no download | nothing | subagent, sonnet, high | done, shortlist given to the owner |

## Open

- Fun gate: she plays it, then a parent moves the tile out of En test.
- Sounds: no file downloaded yet. Whistle and kick exist as CC0, crowd only as CC-BY or CC-BY-SA, so crowd files would need a credit line.
- Not tested: sound by ear, real touch, frame rate on a real tablet, fullscreen in a real browser (the preview pane refuses it).
- Known weak spots: side-view open mouth, fork receivers overlap a little on short screens, empty grass at the bottom in portrait on pass and trophy, resizing during an animation can misplace things until the next scene.
