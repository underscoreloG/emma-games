# Mes autocollants (22-autocollants.html)

1. Open: double-click `jeux/22-autocollants.html` (or open `index.html` at the repo root and pick the house tile). No server, no network, no other file needed.
2. Play: tap a sticker (it flies to its spot) or drag it anywhere; drag it back on the sheet to remove it. Round arrow = undo, blue square with 4 white squares = room list, house = main menu (always visible).
3. Parent area: press and hold the gear for 2 seconds (sound, language FR/EN, empty a room, erase everything).
4. Progress (stickers, stars, character) is saved in `localStorage` under the key `autocollants-v1`.
5. Add a theme pack: push one more object into `ROOMS` (section 3 of the script): `{ id, bg: roomBg({...}), stickers: [...] }`. No engine change.
6. A sticker is `{ id, w, h, x, b (bottom) or y (center), layer: "wall" | "ground" | "floor" | "top", art, act }`; `art` is an SVG string built with the helpers `r c el p ln g`.
7. An action is data too: `act: { pose, dx or on:[dx,dy], hold, fx, fxAt, snd, dur, over, persist, set }`. Poses are in `POSES`, held objects in `PROPS`, sounds in `SFX`.
8. Add the room name to `STRINGS.fr.rooms` and `STRINGS.en.rooms`. A pack can also add poses, props and names with `Object.assign` (see the garden and school packs).
9. Checks: open the page, then in the browser console run `__game.openRoom("kitchen"); __game.place("oven"); __game.step(3000)` and look at the scene; the console must stay free of errors. Natural spots must not overlap, except an object resting on its furniture (kettle on the counter, duck on the tub rim).
10. Full check: place every sticker of every room with `__game.place(id)`, call `__game.act(id)` then `__game.step(6000)` and verify `__game.chr.act === null`; reload and verify `__game.state.rooms` and `__game.state.stars` are restored.
