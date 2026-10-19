# Outils images

Le jeu (`00-peppa-pig.html`, à la racine) est un fichier unique : les images y sont incrustées en base64 dans l'objet `IMGS`. Les fichiers `.png`/`.jpg`/`.webp` de `peppa/sources/` ne servent qu'à la préparation, le jeu n'en a pas besoin pour tourner.

## Remplacer ou ajouter une image

1. **Détourer** (supprime le fond blanc ou damier connecté aux bords, recadre, réduit à 600 px max) :

   ```powershell
   .\outils-peppa\detourer.ps1 -InFile .\peppa\sources\suzy.jpg -OutFile .\peppa\sources\suzy_clean.png
   ```

   - Accepte `.png`, `.jpg` et `.webp`. Les `.webp` passent automatiquement par `webp-en-png.ps1` (le décodeur WebP de Windows perd la transparence, on utilise Edge/Chrome en mode headless).
   - Si l'image a déjà un fond transparent, elle est seulement recadrée et réduite.
   - Réglages : `-BrightMin` (200) et `-SatMax` (30). Pour un personnage blanc avec contour gris (Suzy) : `-BrightMin 235 -SatMax 20`.
   - `-MaxSize` (600) : plus grand côté en pixels, `0` pour ne pas réduire.

2. **Incruster** dans `00-peppa-pig.html` (la clé doit exister dans `IMGS`, ex. `suzy: "__IMG__",`) :

   ```powershell
   .\outils-peppa\set-image.ps1 -Key suzy -Image .\peppa\sources\suzy_clean.png
   ```

   Le script affiche le ratio `ar: hauteur/largeur` à reporter dans la liste `CHARACTERS`.

3. Pour un **nouveau** personnage : ajouter la clé dans `IMGS`, une constante `const XXX = () => IMG(IMGS.cle);` et une ligne dans `CHARACTERS`.

## Éléments génériques

Canard, ballon, étoile, fleurs, papillon et arc-en-ciel viennent de [Microsoft Fluent Emoji](https://github.com/microsoft/fluentui-emoji) (style Flat, licence MIT), intégrés en SVG directement dans le code. La flaque de boue reste un dessin maison (aucune bibliothèque n'en propose).
