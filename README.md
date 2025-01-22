# Piron Games Haxe/OpenFL GameLib 2.0
It's a game development library/framework, written in Haxe 3/4 for the OpenFL framework. The primary target is HTML5.

This is a port of [hxgamelib2](https://github.com/stefandee/hxgamelib2), which was done in 2018. It powers the following HTML5 games: [Orbital Decay](https://www.pirongames.com/orbital-decay/), [SuperChicken Battles The Penguin Horde](https://www.pirongames.com/superchicken-battles-the-penguin-horde/), [Loose Cannon Physics](https://www.pirongames.com/loose-cannon-physics/), [Knight And Witch](https://www.pirongames.com/knight-and-witch/) and [Laser Lab](https://www.pirongames.com/laser-lab/).

It's in a dormant state, as I have no plans to make new games in Haxe/OpenFL. I am, however, trying to keep it up-to-date with the latest versions of Haxe/OpenFL and occasionally fix bugs.

The main features are:
* scene graph (a "loose" port to Haxe and adaptation of jMonkeyEngine for 2D games);
* support for patterns (Entity-Component-System, pooling, observer);
* UI support via microvcl, with additional visual components and behaviours ("tactics");
* [Sentry](https://github.com/stefandee/gametoolkit) sprites loading and rendering;
* localization (requires [StringTool](https://github.com/stefandee/gametoolkit) with [StringScript_HxGameLib2.csl](tools/StringTool/StringScript_HxGameLib2.csl) export script to convert data from a master sheet to a format usable by the library);
* leaderboards support (needs refactoring in the logic and UI to abstract it);
* cryptography support (to protect in-game memory data from direct search and tampering via CheatEngine, e.g. scores, resources counts, etc).

## Requirements
Haxe 3/4, OpenFL 9.4.0, Perl (tooling)

While the library doesn't direcly requires them, the included samples and any project using it would need tools from the [Piron GameToolkit](https://github.com/stefandee/gametoolkit), for specific usages:
* the built-in sprite system uses Sentry;
* the built-in l10n system uses StringTool;

Pre-built binaries of the Piron GameToolkit are available for [download here](https://github.com/stefandee/gametoolkit/releases).

## Setup

To use the library in your project, install it using [haxelib git](https://lib.haxe.org/documentation/using-haxelib/#git):

```console
haxelib git hxgamelib-openfl https://github.com/stefandee/hxgamelib2-openfl.git
```

## Usage

### A Basic Example

Please see the example provided in [examples/gamelib2](examples/gamelib2) for how to setup an application, work with some microvcl elements and the spriting system and initialize the localization.

To build the example data, download a [Piron Games Gametoolkit](https://github.com/stefandee/gametoolkit/releases) release and unpack it, then adjust the paths in [makedata.bat](examples/gamelib2/assets/makedata.bat).

To build&run the example, use either [build.bat](examples/gamelib2/build.bat) or simply run

```console
openfl test html5
```

### Blacklisting

This sample is relevant for HTML5 games only.

It shows how to generate a blacklist Haxe class out of a text file containing sites you don't want your game to run on. The generated class keeps the blacklist entries encrypted with a simple cypher (RC4), so they won't appear in a casual search.

In a real game, you would grab the URL the game is run from, check it against the blacklist and decide what to do.

Works best when using an obfuscation tool (e.g. Google Closure compiler).

### Leaderboards

The leaderboard module and the sample was written for the [Piron Games Arcade v4](https://github.com/stefandee/pirongames-website-v4) and needs adjustments to work with a different leaderboard provider.

To build&run the example, use either [build.bat](examples/leaderboard/build.bat) or simply run

```console
openfl test html5
```

### Tooling

A couple of Perl scripts to help build the data in library-friendly formats are provided.

These are:
* makedatalib.pl merges together files in a folder and also outputs Haxe definitions to easily access them (useful for creating a sprite library)
* makelanglib.pl converts all the xml files, merges them together and generates Haxe definitions
* makepbl.pl creates a RC4 blacklist Haxe definitions based on a list of sites (this was used to prevent the game from running on sites that were known to block ads or outgoing links in the Flash era)

## Known Issues/Future work

The library roots are in Flash game development. It was common to design a game for a fixed resolution (simplified developement, small assets to keep the game below 3-5Mb for fast download, etc). This is why the library lacks ways to resize. Some preliminary work has been done in Application.hx and Form.hx, but it's never been completed. This is one of the biggest points of improvement.

The spriting format exported and used is, again, optimized for Flash games ecosystem, which favoured small sizes. HTML5 and OpenFL have issues with storing and rendering many separate BitmapData like the SentryModuleTemplate currently holds. They work, but not efficiently. To be efficient for HTML5 would mean to pack everything in a large BitmapData and use offset rendering from it. This would require adding support to library Sentry sprite system as well as creating an export script for Sentry sprite editor.

Leaderboard system should be refactored to accept any provider, convert provider data to internal data. Its [UI part](src/gamelib2/microvcl/leaderboard) should also be refactored.

Improved test case coverage.

Replace haxe.xml.Fast with haxe.xml.Access.

I don't have immediate plans to implement any of the above, though.

## License

Code license:
https://opensource.org/licenses/MIT

Art assets license:
https://creativecommons.org/licenses/by-nc-sa/4.0/
