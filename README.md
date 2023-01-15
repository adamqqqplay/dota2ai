# Ranked Matchmaking AI

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![Downloads:](https://img.shields.io/steam/downloads/855965029)](https://steamcommunity.com/sharedfiles/filedetails/?id=855965029) [![Release:](https://img.shields.io/github/v/release/adamqqqplay/dota2ai)](https://github.com/adamqqqplay/dota2ai/releases)

This project is an improved Dota2 Bot script based on Valve's default AI. 

It can provide a good practice environment for players who cannot play online to improve their game level. 

 [**简体中文文档**](https://github.com/adamqqqplay/dota2ai/blob/master/README_zh_CN.md)

## Features
1. Support 100+ heroes.
2. Better ability and item usage.
3. More reasonable team hero selection plan.
4. More advanced abilities, talents, and item build lists.
5. Improved strategy system, including farming system, pushing system, warding system etc.

## Install

### Play online

#### Method 1.1
1. Open **Dota2** and click **PLAY VS BOTS**.
2. Select **Ranked Matchmaking AI** in **BOT SCRIPT**.
3. Click **FIND MATCH** to start game.

#### Method 1.2
1. Open Steam workshop link to subscribe this project: https://steamcommunity.com/sharedfiles/filedetails/?id=855965029
2. Open **Dota2** and create a **CUSTOM LOBBIES**.
3. **EDIT** lobbies settings.
4. Select the nearest **Valve official server** or **LOCAL HOST** in the server location.
5. Check **FILL EMPTY SLOT WITH BOTS** checkbox in **ADVANCED LOBBY SETTINGS**. 
6. Choose **Ranked Matchmaking AI** for both side bots.
7. Click **OK** and then start the game.

### Play offline

#### Method 2.1 (With Steam)
1. Subscribe first then you can get this project from path Steam\SteamApps\workshop\content\570\.
(If there is a problem with the Steam download, you can also download it from Github:
https://github.com/adamqqqplay/dota2ai/archive/master.zip)
2. Copy **855965029** folder to Steam\SteamApps\common\dota 2 beta\game\dota\scripts\vscripts\ and rename the folder name to **bots**. Then you can start **Solo Bot match** by choosing Default Bot or this project if you're online.

#### Method 2.2 (Without Steam)
Check out the link below for details: 
https://steamcommunity.com/workshop/filedetails/discussion/855965029/1489987634016938096/
https://steamcommunity.com/workshop/filedetails/discussion/855965029/2217311444342267217/

## Contributing
It is warmly welcomed if you have the interest to improve our project! This project is mainly developed using Lua language.
The steps to participate are as follows:
1. Login Github.
2. Fork this project.
3. Create your feature brache. (git checkout -b new-feature)
4. Commit your change. (git commit -m 'Added some features or fixed a bug or change a text')
5. Push the change to origin repository.  (git push origin new-feature)
6. Then go to the github site and launch the pull request under the new-feature branch of the git remote repository.

We use both normal **Lua** and **Mirana** to develop this project. The Mirana compiler can be found at [Mirana](https://github.com/AaronSong321/Mirana). Mirana is an extension to Lua, supporting lambda expressions and other features. It supports all the syntax of Lua and compiles to Lua. For files written in Mirana, DON'T modify the Lua directly since the modifications are discarded after recompilation.

### Reference
Here are some helpful information for developers.

- https://developer.valvesoftware.com/wiki/Dota_Bot_Scripting 

- http://docs.moddota.com/lua_bots/

- http://dev.dota2.com/forumdisplay.php?f=497

- http://dota2.gamepedia.com/Cheats#Hero_names

## Feedback
If you have any questions or suggestions or tips, please feel free to ask questions.

Open issues on Github: https://github.com/adamqqqplay/dota2ai/issues

## License
GPL v3

    <Ranked Matchmaking AI> Copyright (C) 2017~2023  adamqqq
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.

## Contributors
<a href="https://github.com/adamqqqplay/dota2ai/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=adamqqqplay/dota2ai" />
</a>

## Sponsor
If you like this project, you could support the development team through Paypal or Alipay. 

Paypal/Alipay payment email: adamqqq@163.com

Any contribution will help our development, thanks a lot!

Sponsor list will update at: https://github.com/adamqqqplay/dota2ai/issues/72

![avatar](https://image-10026452.cos.ap-shanghai.myqcloud.com/alipay1542723302162.jpg)
