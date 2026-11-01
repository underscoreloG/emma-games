# Le grand match - spec

Game 37, `jeux/37-le-grand-match.html`. Size S: one self-contained HTML file. `FOUNDATIONS.md` applies in full and wins over this file on any conflict.

## Pitch

Emma plays a short football match in a packed stadium and every tap makes something happen.

Pillars:
1. It feels like the football she watches on TV: stadium, crowd, whistle, passes, keeper, celebration close-up, trophy.
2. Tap anywhere works. Nothing needs aiming, timing or reading.
3. She always scores. The fun comes from the moment of the goal and from the keeper's funny failures.

Fun gate (asked after she plays it): does she ask to play again, and does she laugh or cheer at a goal?

## Session shape

Start screen (big play button, FOUNDATIONS rule 9), then shirt picker, then kick-off, then 5 goals, then trophy, then night, then a replay button. Target about 2-3 minutes per match.

### Shirt picker

Four very big shirts to tap. One tap picks and starts the match. Her side's colour drives the kit, the banners, most of the crowd and the confetti. The saved shirt is ringed but not auto-picked. A row of small gold trophies shows `mem.trophies` (max 10 drawn, then a small star).

| Shirt | Kit | Opponent kit |
|---|---|---|
| bleu | `#2f6fde` | orange `#fb8500` |
| rouge | `#e63946` | sky `#48cae4` |
| rose | `#ff70a6` | violet `#7b2cbf` |
| jaune | `#ffd60a` | navy `#1d3557` |

Opponent keeper: always lime `#b5e48c` with white gloves. Pitch stripes `#6fbf73` and `#62b268`, lines white. Palette as CSS variables or one JS table. No crests, no club or national names.

### The match is data

```js
const MATCH = [
  { k: "pass", passes: 2 },
  { k: "penalty" },
  { k: "save", saves: 3, then: { k: "pass", passes: 1 } },
  { k: "pass", passes: 3, fork: true },
  { k: "penalty" }
];
```

Adding or reordering steps must not touch the engine. Progress is a row of 5 ball slots at top centre that fill up on each goal, clear of the house button at every size. No score numbers.

## Input rule

One pointerdown handler on the scene. While the game waits for a tap, a tap ANYWHERE does the current action. While it is busy, a tap gives a small spark at the tap point and a soft sound and changes nothing. During a celebration or the trophy scene, a tap fires a burst of confetti or a firework at the tap point. Every tap answers within 100 ms (sound plus visible reaction) before any longer animation starts.

The game never advances by itself out of a waiting state, and there is no timer. After 3 s of waiting the target glows harder and a pointing hand 👆 appears on it.

## Moments

**Kick-off** (under 3 s, no tap needed): both teams in place, crowd noise rises, whistle.

**Pass** (side-on TV view, her side attacks to the right, the camera pans to follow the ball). Three of her players, hero last, and 2 opponents who stumble about and never reach the ball. The next receiver waves and has a pulsing ring. Tap: the holder kicks, the ball rolls in an arc to the receiver in about 600 ms, the camera follows. After `passes` passes the ball is with the hero (number 10) near the goal, the goal glows, tap: shot, goal.

With `fork: true`, on the last pass two receivers glow (high and low on the pitch); the one nearer the tap gets the ball. Either way the hero ends up with it for the shot.

**Penalty** (from behind the hero, goal big in the centre, keeper in it, stands behind). The shirt back shows `EMMA` and `10`. A tap anywhere sets the aim: the tap point, clamped inside the goal frame, gets a star marker at once. Short run-up, kick, ball flies and shrinks towards the aim in about 500 ms, the net bulges, goal.

**Keeper gag** (penalties and pass shots, data table, no immediate repeat):
- `plonge`: dives the wrong way and flops
- `glisse`: slips and lands on its bottom
- `tourne`: spins dizzy, stars around the head
- `tunnel`: the ball goes between its legs, it looks down
- `poteau`: the ball hits the post, a loud boing, bounces off the keeper's head and into the net (about 1 shot in 4)

**Save** (first person, she is the keeper, she sees two big gloves at the bottom of the screen). An opponent in the distance kicks; the ball grows towards her over about 2 s and then floats, wobbling and glowing, until she taps. It never gets past her. Tap anywhere: the gloves fly to the ball and catch it, thud, crowd cheers, gloves shake. Next shot comes from another side. After `saves` catches, one more tap throws the ball out and the game cuts to the `then` step.

**Goal and celebration** (about 4 s). In this order: whistle, net shakes, crowd roar swells, ball slot fills with a pop, big burst of confetti in her colour, cut to a TV close-up of the hero front on, large in the middle of the screen, in front of the crowd, doing one celebration. Then cut back to the next step.

Celebration table (data, no repeat within a match): `avion` (arms out, swoops side to side), `glissade` (knee slide into frame), `danse` (hip wiggle, arms up), `salto` (backflip), `coeur` (hands make a heart, ❤️ float up), `calin` (two teammates run in for a hug).

**Trophy** (after goal 5). Whistle three times. Her team on a podium, a big gold trophy glowing in front. Tap: the hero lifts it high, fanfare, fireworks, gold confetti. `mem.trophies` goes up by 1 and is saved here. For about 6 s every tap adds a firework.

**Night** (calm ending, no tap needed). The sky goes dark, floodlights go out one by one with a soft clunk, the crowd noise fades to nothing, moon and stars come out, the hero sleeps against the trophy with 💤, a short soft lullaby in tones. Then the 🔁 button appears (72 px or more, top right). It goes back to the shirt picker.

## Look

- Flat, rounded, chibi players with big heads, on the 1600x900 base. Hero: ponytail. Teammates vary in skin and hair, and two of them are girls.
- A player is a rig: head, torso, two arms, two legs as separate groups driven by a pose object tweened from pose to pose, as in game 35. Three views are needed: side (pass), back (penalty), front (keeper, close-up).
- Ball, trophy, gloves, goal and net are drawn in SVG, not emoji. Emoji are fine for ❤️ 💤 👆.
- Stands: rows of round heads, mostly her colour, a few banners. Rows bob gently; on a goal a Mexican wave runs along the stands. Group the heads so a frame touches no more than about 12 elements for the crowd.
- Confetti and fireworks may use a `<canvas>` overlay with `pointer-events:none`, driven by the game clock. Max 150 live particles.
- Text: the title, plus `EMMA` and `10` on the shirt as decoration. Nothing else on screen is text.

## Devices

Must be fully playable on a computer with a mouse, on a tablet and on a phone (owner's requirement, 2026-11-01). One click or one tap does every action, so a mouse needs no dragging, holding or hovering, and nothing depends on touch-only gestures. Pointer Events only. On a computer the scene fills the whole window at any window size, including wide 16:9 screens.

## Sizes

Landscape: viewBox 1600x900. Portrait: viewBox width 1000 and height from the window ratio, with stands and grass drawn large enough to fill it and the camera keeping the action in frame. Recompute on resize. At 390x844 the hero, the ball and the glow target must each be at least 72 px on screen.

## Sound

No voice, ever. Synth exists for everything: a low looping crowd bed (filtered noise, stops at the Night scene), goal roar (noise swell about 3 s), whistle (trill around 2500 Hz), kick (low thump plus click), net swish, boing, catch thud, clap, fanfare, firework pop, lullaby.

Optional real files in `../sons/`, played through `Audio` elements so it works on `file://`, falling back to synth when a file is missing or fails: `foule-ambiance.mp3` (loop), `foule-but.mp3`, `sifflet.mp3`, `frappe-ballon.mp3`. A missing file must never log an uncaught error or break anything.

## Code

- Copy the shared core from game 35 (script start through `window.__game`), the `big-cursor` style block and the `fullscreen` script block as is. Drop the list screen and hold button parts if unused. No blue list button: there is no inner list.
- All timed logic runs on the game clock. Animate SVG with `transform` attributes from JS. No CSS transforms inside SVG.
- One state object. Save `{ trophies, shirt }` under key `match-v1` with the core's `load`/`store`.
- A small state machine: every screen and every moment is a state; a tap reads the state and does one thing. Extra fingers can never run two actions.
- Test hooks on `window.__game`: `step(ms)`, `st()` returning `{ screen, stepIndex, goals, waiting, busy, hint, shirt, trophies, lastGag, lastCeleb }`, `tap(x, y)` running the real input path with client coordinates, `mem`.

## Acceptance

Checked in the browser pane over `http://localhost`, stepping with `__game.step()` because the pane throttles `requestAnimationFrame`:

1. No console errors on load or through a full match (404 on optional `sons/` files are expected).
2. A full match from play button to 🔁 completes using only `tap` and `step`, with `goals` reaching 5 and `trophies` up by 1.
3. With no taps, a waiting state stays waiting for 60 s and `hint` is true by 4 s.
4. 500 random taps during a match, at any time, leave a valid state and the match still completes.
5. Reload restores `trophies` and the saved shirt ring.
6. At 1920x1080, 1024x768, 844x390 and 390x844: no element off screen, 5 slots clear of the house, target sizes met, screenshots of each moment read clearly.
7. Every keeper gag and every celebration plays cleanly.
8. Grep finds no `speechSynthesis` or `SpeechSynthesisUtterance`, no `cursor:` other than the big cursor block, no network calls other than optional `../sons/`.
9. House link is `../index.html`, 72 px or more, visible on every screen. Fullscreen and cursor blocks are identical to game 35.

## Out of scope

Blue list button, moon button, sound settings, tapping players for reactions, weather, animal opponent team, more moments, dribbling, a two-player mode.
