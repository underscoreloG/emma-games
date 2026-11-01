# Le grand match - status

Idea: an easy football match for a 3-year-old who likes watching football.
Slug: le-grand-match. Size: S. Phase: 5 (fun gate).

## Decisions

- 2026-11-01: lives in emma-games as game 37, not its own project folder, FOUNDATIONS.md applies. Spec and ledger stay in docs/le-grand-match/.
- 2026-11-01: core loop is a mixed match of 5 goals: passes, penalty, keeper saves then counter-attack, passes with a fork, penalty.
- 2026-11-01: she picks one of 4 shirts, colours only, no crests or real names.
- 2026-11-01: every shot scores. Keeper failures are the joke, about 1 shot in 4 hits the post and goes in.
- 2026-11-01: real CC0 crowd, whistle and kick recordings wanted, optional files in sons/, synth fallback. Each file is approved before download.
- 2026-11-01: owner approved all 4 sounds. No CC0 crowd was found, so the crowd is CC-BY 4.0 with a credit in the parents' notes and sons/LISEZMOI.txt.
- 2026-11-01: clips load as decoded buffers like the other games, with Audio elements only for file://. Apple documents the Audio element volume as read-only on iOS, and play() outside a tap can fail there.

## Work packages

| WP | What | Owns | Dispatch | State |
|---|---|---|---|---|
| WP01 | Build the whole game | jeux/37-le-grand-match.html | subagent, opus, high | merged |
| WP02 | Find CC0 sound candidates, no download | nothing | subagent, sonnet, high | done, shortlist given to the owner |

## Open

- Fun gate: she plays it, then a parent moves the tile out of En test.
- Sounds: 4 files in sons/, passed by the owner's listen on 2026-11-01. Sound on a real iPad or iPhone is still untested.
- Not tested: sound by ear, real touch, frame rate on a real tablet, fullscreen in a real browser (the preview pane refuses it).
- Known weak spots: side-view open mouth, fork receivers overlap a little on short screens, empty grass at the bottom in portrait on pass and trophy, resizing during an animation can misplace things until the next scene.
