# Foundations for every game in this library

Rules that every game in this repo (including the Peppa game, `00-peppa-pig.html`) must follow. Read this before adding or changing a game.

## 1. Who plays

- A 3-year-old: imprecise fingers, cannot read, short attention, taps everything.
- Tablet in landscape first (1024x768, 1280x800). Must also work on a phone (portrait and landscape) and with a mouse.
- An adult is usually sitting next to her. Sessions are a few minutes long.

## 2. Hard rules (never break)

1. **Home button**: a big round button with a house icon, top left, in every game. It goes back to the main menu (`index.html`). Minimum 72 px, no confirmation. It stays visible on every screen of the game. A game with its own inner list (rooms, drawings, cakes) uses a second button for it: a blue square (`#a0c4ff`) with 4 white squares, same size as the house and placed just right of it. See section 4 for the list itself.
2. **No voices**: never use speech code (`speechSynthesis`, `SpeechSynthesisUtterance`) or any synthetic voice. Sound effects and music only.
3. **No reading needed**: the game is playable with zero text. Text is allowed only in the title and in parent-only areas.
4. **No way to lose**: no timer, no score pressure, no error sound. A wrong try gets a soft nudge and the right answer glows.
5. **Immediate feedback**: every tap answers within 100 ms with a sound and an animation, including taps on empty space.
6. **Nothing leaves the device**: no ads, no external links, no analytics, no network calls. Works offline by double-clicking the file.
7. **One self-contained HTML file per game**: CSS and JS inline, no framework, no build step needed to run it.
8. **Game text is in French.** Code comments and docs follow the owner's current language preference.
9. **Fullscreen**: every game plays fullscreen. A browser only grants fullscreen on a tap, a click or a key press, so it is requested on the first one (the big play button) and again on the next tap if fullscreen was left. This is the `<script id="fullscreen">` block at the end of each game file; copy it as is into any new game. The request must fail silently where fullscreen does not exist (iPhone). Going back to the menu leaves fullscreen (the browser does that on every page change); the next game takes it again on its play button.

## 3. Interaction

- Touch targets: 72 px minimum for navigation, as large as possible for play objects.
- **Big mouse cursor**: every page (menu and games) uses the same large cursor, a 64 px yellow arrow with a dark outline, on every element. It is the `<style id="big-cursor">` block in each file; copy it as is into any new game. Never set another cursor (`pointer`, `grab`...) on top of it and never hide it.
- Pointer Events only (`pointerdown`, `pointermove`, `pointerup`, `pointercancel`), so touch and mouse share one code path.
- `touch-action: none` on the play area; block text selection, context menu, pinch zoom, double-tap zoom and scroll bounce.
- Several fingers at once must never break the state (track drags per `pointerId`, ignore extra taps while busy).
- Prefer tap over drag. When drag exists, a tap must do the same job by itself.
- If she hesitates, show a hint after a few seconds (the right object glows). Never punish.
- Settings and whole-game resets sit behind a parental gate: press and hold for 2 seconds. Erasing the current creation is not behind it: that is the one-tap sponge (section 4b).

## 4. Session shape

- Start: one big play button (it also unlocks audio and switches to fullscreen, see rule 9).
- Play: short rounds, one rule at a time, difficulty rises gently.
- Inner list (gallery): when a game has several pictures, rooms or objects to go through, the list is a full screen of big thumbnails. Each thumbnail shows the item as she left it (saved colours, stickers, toppings), and a star marks the ones she finished. One tap opens an item, the blue 4-square button comes back to the list. On the list itself only the house is shown.
- End: a calm natural ending (night, sleep, a quiet screen) that invites stopping or replaying. No endless escalation.
- Progress that matters (stars, placed items, colours) is saved in `localStorage`, wrapped in `try/catch`; the game must work when storage is blocked.

## 4b. Creative games

Her favourite kind: no goal, she makes something. Coloriage magique (05), Mes autocollants (22), La pâtisserie (23), Grattage magique (24), Peinture libre (26), Les décorations (30) and Le salon des copains (36) share these rules.

- A palette of tools (colours, objects) sits on the side in landscape and at the bottom in portrait. The chosen tool gets a dark ring and stays chosen until she picks another one.
- One tap applies the tool. Sliding may repeat it (sprinkling toppings), but is never required.
- An undo button (yellow, round arrow) takes back the last action. Nothing asks for confirmation.
- Sponge: every game where something can be erased has a pink sponge button (🧽) next to the other action buttons, and it acts on ONE tap, no hold and no menu (decided by the owner on 2026-10-11: holding, or going through the parent area, was too hard for her). It empties the current creation only, never the whole game. Where there is an undo arrow, the arrow brings back what the sponge wiped.
- Action buttons sit in one row at the top right of the play area, same size as the house, always in this order from left to right: parents' gear (if any), yellow undo arrow, other actions (wand, music), pink sponge, moon. When the row is too narrow on a phone, the gear moves to a corner of the scene, never on top of another button (checked on all games 2026-10-17).
- Erasing everything in every item at once stays behind the parental gate.
- With a mouse, prefer actions that work by just moving it (scratching) or by a single click. Holding the button while moving is hard at 3: when a game needs it (painting), a single click must already leave a mark.
- Toys without an end (orchestra, marbles, aquarium) get a moon button that calms everything down: that is their natural ending.
- A surprise button (magic wand, dice) that decorates at random is welcome.
- Every creation is saved and shown again in the gallery thumbnails.

## 5. Sound

- Audio starts only after the first user gesture.
- Synthesized WebAudio sounds always exist as a fallback; real sound files in `sons/` are optional and a missing file must never break a game.
- Long sounds stop when their action is interrupted.
- A mute toggle exists where there is a parent area.
- No voice, see rule 2.

## 6. Look

- Flat, rounded, friendly shapes; pastel background with a few saturated accents; palette defined once (CSS variables).
- Animations are short and readable. `prefers-reduced-motion` only calms decorative loops (pulsing buttons, falling rain, bubbles). Movements that ARE the game (a jump, a fall, a bite, a piece flying to its place) always play: skipping them made the games look broken on the family PC, which has reduced motion turned on (found 2026-10-14).
- Inside SVG, animate with `transform` attributes from JS, not CSS transforms: CSS transforms on SVG elements rotated around the wrong origin on the family tablet. Opacity animations in CSS are fine.
- Size buttons with `px`, `vmin` or a CSS variable, not `%` padding (on a fixed element it is a share of the screen width, and the button balloons).
- No copyrighted assets except the Peppa images, which are for personal family use only.

## 7. Code

- Plain readable JS, no dependencies. The HTML file is the only source: there is no separate build folder to keep in sync.
- One state object per game; content (levels, rooms, items, poses) is data, not code, so adding content does not touch the engine.
- Animations and timers that matter for logic run on a game clock, and a test hook (`window.__game` with `step(ms)`) lets the game be checked when `requestAnimationFrame` is throttled.
- No layout thrash during drag: move things with transforms.
- Games 24 to 36 start their script with the same shared core (sound, game clock, list screen, saving, hold button). For a new game, copy that block from one of them, then write the game below it. La pâtisserie (23) and Les décorations (30) share one engine and differ only by their content block and the `END` setting. Le salon des copains (36) replaced three older games, the hair salon (27), the monster maker (28) and face painting (29), merged into one (decided 2026-10-17; 27-29 were deleted on 2026-10-19 and stay in the git history): one friend per list item, a 🐾 button switches between animals, children and monsters, part buttons change eyes, mouth, face paint, hat and accessory, and the hair tools work on every head. A colour acts where she taps: hair lock, skin or shirt.
- Chained movements (a tween started from the end of another one) must survive the clock update: the shared core keeps tweens created during the update. A character with several moves uses a pose rig: a few numbers (lean, head, legs, squash, height) tweened from pose to pose, as the cat in game 35.

## 8. Catalog integration

- File name: `jeux/NN-nom-du-jeu.html`, next free number. Games live in `jeux/`; the menu `index.html` and the shared files (`icone.png`, `sons/`, `peppa/`) stay at the repo root, so a game links to them with `../` (house button: `../index.html`).
- Every new game first gets its tile in the **🧪 En test** section at the top of `index.html`, never directly in a final section. The owner plays it with his daughter, validates it, and only then is the tile moved to the right section (decided 2026-10-14). Games that existed before that date stay where they are until the owner sorts them.
- One tile in `index.html` (emoji or image, title, one-line description).
- The menu must not need scrolling on a tablet or computer: a script picks the biggest tile size (96 to 240 px) at which every section fits in the window, and small sections share a row. Each section is a `<section class="blk">` (title + grid) inside `#games`; add `small` to a section of 1 to 3 games so it can sit next to another one. On a phone the tiles stay at 110 px and the page scrolls.
- Favicon comes from the tile emoji; `apple-touch-icon` is `icone.png`.
- Add a line to the "Pour les parents" notes when the game has something a parent should know (duration, settings, natural ending).

## 9. Before calling a game done

- No console errors on load and during a full playthrough (404 on optional `sons/` files are expected).
- Every object renders and every action ends cleanly.
- Tested at 1024x768 and 390x844 with pointer events; reload restores saved progress (test this over `http://localhost`, a `file://` preview may block `localStorage`).
- The big yellow cursor shows on every element, and the blue 4-square button is there if the game has a list.
- Action buttons (undo, wand, sponge, moon) are fully visible, not cut by the rounded border of the play card.
- If the game has something to erase, the sponge does it in one tap.
- The house button returns to the menu.
- The game goes fullscreen on the tap on the play button (check `document.fullscreenElement` with a real click, a scripted event is refused by the browser).
- Report plainly what was not tested (real tablet, sound by ear, frame rate).

## 10. Ideas for next games

From a look at what Sago Mini, Toca Boca, Pok Pok and CBeebies Get Creative offer to this age (October 2026). Already built from that list: cake decorating, scratch to reveal, puzzle, free painting, hair salon, monster maker, face painting, seasonal decorating, animal orchestra, marble run, aquarium.

Still open:

- Busy board: switches, zips, doors and lights that react.
- Car wash or pet wash: foam, rinse, dry, shine.
- Train or road builder: lay track pieces, then the train drives on them.
- Shadow theatre or puppets: place characters, they play a short scene.
- More content for the existing engines: new treats and decorations (23, 30), new pictures (24, 25), new parts (28, 29), new circuits (32).
