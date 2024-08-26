# Going Deeper

## Getting started

You need:
* Git (use [Github Desktop](https://desktop.github.com/) if you're not familiar with Git)
* Godot v4.3

Then follow these instructions:
1. Clone the repository
3. Open Godot
4. Import the project

## Files & folders structure

```
assets/             Any assets/media like arts, sounds that are imported in the game
components/         Any reusable piece of code or scene
├── actors/         Any scene or scripts related to characters, NPCs, enemies, etc.
├── biomes/         Any script or scene related to biomes
├── classes/        Any reusable classes or object structures (like health, various statistics classes, etc.)
├── ui/             Any reusable script or scene for the graphical user interface (i.e. panel, button, text box, etc.)
globals/            Autoloaded global scripts (global states, global utilities, etc.)
levels/             Godot scenes that represent game levels (each game level has to be loaded in the current context)
├── scripts/        Scripts related to certain levels (i.e. start menu scene needs a button to load the first playable level)
resources/          Godot global resource files (i.e. theme, tilesetetc.)
├── game_theme.tres Theme resource file of the game (i.e. colors, typo, etc.). Change any theme related parameters here to affect the whole project
```
