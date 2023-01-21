This project is an improved Dota2 Bot script based on Valve's default AI.
v1.7.11 (2022/07/01) Update to 7.31c, and fix many issues.
More update infomation at workshop page.

Unimplemented heroes: invoker, lone druid, meepo, morphling, phoenix, puck, clockwerk, rubick, storm spirit, techies, tinker, visage, wisp, dark willow, pangolier.

[h1]Features[/h1]


[h1]WARNING[/h1]
I am sorry I did not have much time to update this script recently.
But you should know that this script is based on the Valve's default script, and on this basis made some improvements. Any update in main client will change the script's behavior. No programmer will intentionally make a program hard to use. But Valve has not paid attention to the AI script for about half a year. We cannot get any technical support from valve. This is why the vast majority of AI scripts stop being updated. We can only make some minor changes. The project repository is located on github. Any interested person is welcome to participate in the update of this project. https://github.com/adamqqqplay/dota2ai

[h1]Words of author[/h1]
Hello, everyone, I am adamqqq.Welcome to play with our ai, the script aims to achieve a high level of man-machine confrontation. Our ultimate goal is to simulate the Ranked Matchmaking gaming experience (ha ha ha). The script partly take over bot hero, the rest implement by the default program. Players can be in any position, the default support 5v5 game.

You are free to use all of the codes for any non-commercial purposes you choose, with a reference to the original Author. Do not use any of the files here for any program which is not open source and free to use.

Recommended game mode:
Let the script control the entire team, and then players on the other side, so you can experience the strongest strength of this script.

After the script is updated, you may need to re-subscribe this script to update. If you find any bug in the game, or have any suggestions, just leave a maeesage here.

http://steamcommunity.com/sharedfiles/filedetails/discussions/855965029

Thanks to PLATINUM ,FURIOUSPUPPY and GXC, their code helped me a lot.Finally, wish you a happy game!

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
Open Dota 2, open "CREAT LOBBY", open "EDIT", in the "ADVANCED LOBBY SETTINGS"
check "FILL EMPTY SLOTS WITH BOTS".Then subscribe and use workshop bot script.

[h1]Development plan[/h1]
1. Support all heroes.
2. Improve ability usage.
3. Improve team fight positioning. (Done)
4. Improve pushing and defending.

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

This product is licensed under GPLv3.
Copyright 2017 [adamqqq]. This product is not authorized to be released on Steam unless it is under the Steam account adamqqqplay or the target product is licensed under the GPL protocol.

[h1]Donate:[/h1]
If you like this project, you can support the development team through Paypal or Alipay.
Payment address: adamqqq@163.com

More infomation at https://github.com/adamqqqplay/dota2ai/issues/72