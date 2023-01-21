这是一个有点机智的AI，本脚本旨在实现高水平的人机对抗.。(使用任意服务器均可开始游戏)
v1.7.4 (2021.05.08) Updated by AaronSong321
请不要选择齐天大圣，它会导致AI无法正常工作。更新日志详见创意工坊页面。
支持100+英雄
未实现的英雄：祈求者，德鲁伊，米波，变体精灵，凤凰，帕克，发条技师，拉比克，风暴之灵，地精工程师，修补匠，维萨吉，小精灵，邪影芳灵，石鳞剑士。

[h1]警告[/h1]
很抱歉，我最近没有太多时间更新此脚本。
但你应该知道这个脚本是基于Valve的默认脚本，并在此基础上做了一些改进。 主客户端的任何更新都会改变脚本的行为。 没有程序员会故意使程序难以使用。 但Valve在大约半年时间里没有注意到AI脚本。 我们无法从Valve获得任何技术支持。 这就是绝大多数AI脚本停止更新的原因。 我们只能做一些小的改变。 项目库位于github上。 欢迎任何感兴趣的人士参与此项目的更新。

[h1]作者的话[/h1]
大家好，我是adamqqq，欢迎大家挑战我们的机器人，本脚本旨在实现高水平的人机游戏对抗。我们的最终目标是模拟天梯匹配的游戏体验（哈哈哈）。本脚本部分控制了机器人英雄，其余部分由默认程序实现。玩家可以处于任意位置，默认支持5v5的游戏。

您可以自由地在任何非商业项目上使用本程序的代码，并注明原作者。 不要将这里的任何文件用于商业或不开源的程序。

在脚本更新后，可能需要重新订阅本脚本以升级至最新版本。如果你在游戏中发现任何错误，或者有任何建议，请在[url=http://steamcommunity.com/sharedfiles/filedetails/discussions/855965029] 这里 [/url] 留言。

感谢PLATINUM，FURIOUSPUPPY和GXC，他们的代码帮助了我很多。最后祝您游戏愉快！
adamqqq
2017.2.3

[h1]感谢[/h1]
感谢以下代码的作者，他们的代码给予了我很多启迪
1.[url=https://steamcommunity.com/profiles/76561198027945144]PLATINUM[/url] -- Author of PubSimulator
一些通用函数
2.[url=https://github.com/furiouspuppy/Dota2_Bots]FURIOUSPUPPY[/url] -- Author of FURIOUSPUPPY's BOT
一些通用函数
3.[url=https://steamcommunity.com/profiles/76561198061276925]GXC[/url] -- Author of GXC's BOT
一些通用函数
4.[url=https://steamcommunity.com/id/zonatc08]Arizona Fauzie[/url] -- Author of BOT EXPERIMENT
分享吃树，插眼系统，队长模式，一些通用函数
5.v33 -- Author of Impoved Default Bot
插眼系统
6.[url=https://steamcommunity.com/profiles/76561198095982575]pilaoda[/url] -- Author of Army Bots.
推进系统
7.[url=http://steamcommunity.com/profiles/76561197967823929]DblTap[/url]
改进阵容挑选。
8.[url=https://steamcommunity.com/profiles/76561198129462630]zmcmcc[/url]
大量更新
9.[url=https://steamcommunity.com/id/1430963765]maltose[/url]
物品构建更新
10. [url=https://steamcommunity.com/profiles/76561198101520008/]DarKdeZ[/url]
官方技术支持人员小d，为玩家社区做出了大量贡献。

[h1]更新日志[/h1]
请访问这个页面：https://steamcommunity.com/sharedfiles/filedetails/changelog/855965029

[h1]使用方法[/h1]
打开dota2， 创建房间，选择“编辑”，在高级房间设置中
勾选“机器人填满空位”，随后订阅并使用创意工坊的脚本。

[h1]开发计划[/h1]
1. 支持全部的英雄。
2. 改进技能使用。
3. 改进团战走位。（完成）
4. 改进推进与防守。

[h1]常见问题[/h1]
Q：我能不能离线和电脑玩？
A：如果你已订阅，那么可以通过steam启动dota2来离线进行游戏。离线打开dota2，在主菜单选择脚本并开始游戏即可。
国服玩家无法进入dota2的离线模式，请先把steam dota2启动项设置中的-perfectworld去掉。
Old A:可以，把Steam\steamapps\workshop\content\570\855965029\下的所有文件复制到把Steam\steamapps\common\dota 2 beta\game\dota\scripts\vscripts\的bots文件夹下，如果没有，新建一个即可。然后你就可以直接通过主界面的机器人游戏开始了，而不需要创建主机。
你的文件夹中请不要包含空格和特殊符号。

Q:为什么电脑不走中？为什么某个英雄不走中？
A:本ai由v社默认分路系统完成分路，所以暂时不能解决这类问题。

Q:为什么电脑很傻，一直抱团推？怎么让电脑配合我？
A:本ai绝大部分继承了默认ai系统，所以战略上有些问题是很正常的。关于与人类玩家更好的配合，仍在开发中。 

Q:能不能不让电脑喝泉水？电脑为什么这么毒瘤！
A:可以，把Steam\steamapps\workshop\content\570\855965029\mode_team_roam_generic.lua 删除，他们就不会喝水了。

Q:为什么我没有和你的电脑一起玩，还是默认的电脑阵容出装？（作废，你现在可以在任何服务器上玩）
A:因为你没有在本地主机上游戏，在开启游戏前请在服务器位置中选择本地主机。

Q:我能不能和其他玩家一起玩？
A:可以，只需要创建主机即可。关于在合作对抗机器人匹配中使用自定义脚本，v社正在开发中，敬请期待。

Q:我觉得某个英雄这样出装/加点/使用技能更好
A:感谢您的建议，请提交至讨论板块
http://steamcommunity.com/workshop/filedetails/discussion/855965029/1334600128974494653/

Q:我发现一个致命错误！
A:感谢您的反馈，请提交至讨论板块 http://steamcommunity.com/workshop/filedetails/discussion/855965029/1334600128974492030/

Q:有Github页面吗？
A:有，请访问https://github.com/adamqqqplay/dota2ai

Q:对于为什么有时候电脑会做出一些匪夷所思的操作，以下是v社的解释：
A:疯狂的机器人是最难的机器人，几乎与困难机器人在游戏风格上完全相同。 他们的补兵几乎是完美的，
当以单人模式玩的时候，玩家队伍的机器人会故意玩得更差（例如抢人头，漏掉反补，拒绝使用控制，越过敌方防御塔，独自带线对抗整个队伍，一直打野即使敌方英雄推到基地等）。
敌方机器人也将在30分钟后获得金钱和经验 25％的提升。 如果一个队伍的人类玩家从游戏中掉线，敌方队伍不会减少一个成员，以便更好地模拟真正的游戏匹配体验。

所以，如果你觉得疯狂难度电脑喜欢送，就去玩[b]困难模式[/b]，困难模式与疯狂模式的差别不是很大。

Q：为什么AI不够强？
A：我理解并同意你所说的话，但完全重写默认AI架构需要很多时间（全职工作6个月以上）和精力。 许多人试图这样做，但最终失败或放弃。（例如，Nostrademous - 完整的Bot覆盖）。 我也不能这样做，我只是一个dota2玩家，只是在业余时间做一点改进。
在TI7OpenAI的表演之后，每个人的期望都大大提高，希望创意工坊的机器人脚本可以和Open AI相同。 不幸的是，我们没有资金和技术支持。 即使是OpenAI团队，也很难做出如想影魔solo那样强的5v5 AI。
所以，请不要抱怨AI不够强大，这只是一个练习AI，不能给予如此高的游戏体验。

本产品采用GPLv3授权。
Copyright 2017 [adamqqq]。此产品不授权在 Steam 上发布，除非在 Steam 帐户 adamqqqplay 下，或目标产品使用GPL协议授权。

[h1]赞助:[/h1]
如果您喜欢这个项目，可以通过Paypal或Alipay支持开发团队。
付款邮箱: adamqqq@163.com