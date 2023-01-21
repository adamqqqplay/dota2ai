This project is an improved Dota2 Bot script based on Valve's default AI.
v1.7.11 (2022/07/01) Update to 7.31c, and fix many issues.
More update infomation at workshop page.

Unimplemented heroes: invoker, lone druid, meepo, morphling, phoenix, puck, clockwerk, rubick, storm spirit, techies, tinker, visage, wisp, dark willow, pangolier.

[h1]Features[/h1]
1. Support 100+ heroes.
2. Better ability and item usage.
3. More reasonable team hero selection plan.
4. More advanced abilities, talents, and item build lists.
5. Improved strategy system, including farming system, pushing system, warding system etc.

[h1]Contributing[/h1]
The best way to help this project grow is to participate in updates.
It is warmly welcomed if you have the interest to improve our project! This project is mainly developed using Lua language.
Github Link: https://github.com/adamqqqplay/dota2ai

[h1]Credit[/h1]
Thanks to all the authors of the cited code, their code gave me a lot of inspiration.
1.[url=https://steamcommunity.com/profiles/76561198027945144]PLATINUM[/url] -- Author of PubSimulator
Some utility function.
2.[url=https://github.com/furiouspuppy/Dota2_Bots]FURIOUSPUPPY[/url] -- Author of FURIOUSPUPPY's BOT
Some utility function.
3.[url=https://steamcommunity.com/profiles/76561198061276925]GXC[/url] -- Author of GXC's BOT
Some utility function.
4.[url=https://steamcommunity.com/id/zonatc08]Arizona Fauzie[/url] -- Author of BOT EXPERIMENT
Some utility function, tango sharing, warding system, CM mode.
5.v33 -- Author of Impoved Default Bot
Warding system.
6.[url=https://steamcommunity.com/profiles/76561198095982575]pilaoda[/url] -- Author of Army Bots.
Push system.
7.[url=http://steamcommunity.com/profiles/76561197967823929]DblTap[/url]
Hero selection.
8.[url=https://steamcommunity.com/profiles/76561198129462630]zmcmcc[/url]
Lots of update.
9.[url=https://steamcommunity.com/id/1430963765]maltose[/url]
Item building update.
10. [url=https://steamcommunity.com/profiles/76561198101520008/]DarKdeZ[/url]
A lot of answers for the player community


[h1]Changelog[/h1]
Please visit this page: https://steamcommunity.com/sharedfiles/filedetails/changelog/855965029

[h1]How to use it[/h1]
1. Open Dota2 and click PLAY VS BOTS.
2. Select Ranked Matchmaking AI in BOT SCRIPT.
3. Click FIND MATCH to start game.

[h1]FAQ[/h1]
Q:How can I play it offline?
A: If you have subscribe, you can just select it on the play menu. And start solo bot match.
Old Answer:Subscribe first and copy the folder's file steamapps\workshop\content\570\855965029\ to steamapps\common\dota 2 beta\game\dota\scripts\vscripts\bots\ . Then you can start bot game in the main menu.
If you have more question about play offline
Please refer to here http://steamcommunity.com/workshop/filedetails/discussion/855965029/2217311444342267217/
Your game folder name can not include spaces and other special symbols.

Q: Why does not the bot go to the middle? Why a bot hero does not go to the middle?
A: The lane assaignment system of my AI inherited the default AI system, so temporarily unable to solve such problems.

Q: Why is the bot so silly, always push mid. How to let the computer cooperate me?
A: The vast majority of my AI inherited the default AI system, so some of the strategic issues are normal. On the better cooperate with the human players, is still under development.

Q: Can not let the computer drink shrine? Why is the computer so cancer!
A: You can remove Steam\steamapps\workshop\content\570\855965029\mode_team_roam_generic.lua, they will not drink shrine forever.

Q: Why is your script not working? (Don't valid now, you can play it on any server)
A: Because you do not have a game on the local host, select the local host in the server location before starting the game.

Q: Can I play with other players?
A: Yes, you only need to create a lobby. We are looking forward to play with custom scripts in the cooperation bot matching. Valve are still developing it.

Q:I have some advice on item building / ability building / ability usage.
A:Thanks, please submit to discussion board http://steamcommunity.com/workshop/filedetails/discussion/855965029/1334600128974494653/

Q:I found a fatal bug!
A:Thanks, please submit to discussion board http://steamcommunity.com/workshop/filedetails/discussion/855965029/1334600128974492030/

Q:Do you have a Github page?
A:Yes, https://github.com/adamqqqplay/dota2ai

Q: Why friends bots are worse than the enemy?
A: Because unfair bots have some strange behaviour by valve's default bots.
Unfair bots are the hardest bots, and are almost identical to Hard bots in terms of play-style. Their last hits are almost perfect, and when played in single player mode, the bots on the player's team would purposely play poorly (such as kill stealing, missing denies, refusing to use stuns, diving into enemy towers, running toward and pushing alone agaisnt the whole enemy team, farming in jungle while enermy pushing to the base, etc.).

If you feel confused with unfair bots, I suggest you to play with hard bots. Hard bots will not do these strange things.

Q:Why AI is not strong enough?
A:I understand and agree with what you say, but completely overwrited the default AI architecture will take a lot of time (full-time work for more than six months) and energy. Many people try to do this, but finally fail or give up. (For example, Nostrademous - Full Bot Overwrite). I can not do that too, I'm just a dota2 player, just do a little improvement in the spare time.
After TI7 Open AI's show, everyone's expectations are greatly improved, hoping that the bot script in workshop can be the same as Open AI. Unfortunately, we do not have their money and technical support. Even if they are, it is difficult to make such as 5v5 AI.
So, please do not complain that AI is not strong enough, this is just a practice AI, and can not give such a high gaming experience.

This project is licensed under GPLv3.
Copyright 2023 [adamqqq]. This project is not authorized to be released on Steam unless it is under the Steam account adamqqqplay or the target project is licensed under the GPL protocol.

[h1]Sponsor[/h1]
If you like this project, you could support the development team through Paypal or Alipay. 

Paypal/Alipay payment email: adamqqq@163.com

Any contribution will help our development, thanks a lot!

Sponsor list will update at: https://github.com/adamqqqplay/dota2ai/issues/72