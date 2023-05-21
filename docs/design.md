# The design of Ranked Matchmaking AI

## 1. Overview

### 1.1 Introduction

[Ranked Matchmaking AI](https://steamcommunity.com/sharedfiles/filedetails/?id=855965029) (**RMM AI** for short) is a project developed based on Dota2 default AI. At first it was just a simple personal project, but with the efforts of many contributors, it became one of the largest AI projects in the Dota2 community.

Most of the AI systems in Dota2 is implemented by Bot scripting written in [Lua language](https://www.lua.org/). This is done at the server level, so there's no need to do things like examine screen pixels or simulate mouse clicks; instead scripts can query the game state and issue orders directly to units. Scripts have full access to all the entity locations, cooldowns, mana values, etc that a player on that team would expect to. The API is restricted such that scripts can't cheat -- units in Fog of War can't be queried, commands can't be issued to units the script doesn't control, etc.

The AI system developed in this project does not completely take over the Bot's behavior, but rewrites some of the Bot's behaviors in various modes. It can be seen that this project is developed using Lua language, while Dota2's AI is developed using C++ language. The parts that are not implemented by Lua code will automatically adopt the logic of C++ code. This means that the behavior of this AI is largely limited by the default AI.

Before your development, we recommend you to read the [official development docs](https://developer.valvesoftware.com/wiki/Dota_Bot_Scripting).

### 1.2 Decision mechanism

Bots are organized into three levels of evaluation and decisionmaking:

#### Team Level

This is code that determines how much the overall team wants to push each lane, defend each lane, farm each lane, or kill Roshan. These desires exist independent of the state of any of the bots. They are not authoritative; that is, they do not dictate any actions taken by any of the bots. They are instead just desires that the bots can use for decisionmaking.

#### Mode Level

Modes are the high-level desires that individual bots are constantly evaluating, with the highest-scoring mode being their currently active mode. Examples of modes are laning, trying to kill a unit, farming, retreating, and pushing a tower.

#### Action Level

Actions are the individual things that bots are actively doing on a moment-to-moment basis. These loosely correspond to mouse clicks or button presses -- things like moving to a location, or attacking a unit, or using an ability, or purchasing an item.

The overall flow is that the team level is providing top-level guidance on the current strategy of the team. Each bot is then evaluating their desire score for each of its modes, which are taking into account both the team-level desires as well as bot-level desires. The highest scoring mode becomes the active mode, which is solely responsible for issuing actions for the bot to perform.

## 2. Directory Structure

As mentioned above, this AI was developed using the **Mode Override**. We override most of the AI modes and added a series of ability/item usage modes and building lists.

### 2.1 Mode

If you'd like to work within the existing mode architecture but override the logic for mode desire and behavior, for example the Laning mode, you can implement the following functions in a `mode_laning_generic.lua` file:

* GetDesire() - Called every ~300ms, and needs to return a floating-point value between 0 and 1 that indicates how much this mode wants to be the active mode.
* OnStart() - Called when a mode takes control as the active mode.
* OnEnd() - Called when a mode relinquishes control to another active mode.
* Think() - Called every frame while this is the active mode. Responsible for issuing actions for the bot to take.

#### 2.1.1 Mode list

The list of valid bot patterns that can be overridden is as follows. (Patterns that have been overridden are bolded, and patterns that have no effect are strikethrough.)

* **laning**
  * Earn experience and money in the early game.
* attack
  * Try to kill an enemy hero.
* ~~roam~~
  * Solo Gank, but doesn't seem to be enabled in game.
* retreat
  * Retreat because HP/MP is too low.
* **secret_shop**
  * Shop in person at the secret store.
* **side_shop**
  * Activate watchtowers on both sides. (After side shop removal)
* **rune**
  * Pick up the rune in the river.
* **push_tower_top**
  * Push the top lane.
* **push_tower_mid**
  * Push the middle lane.
* **push_tower_bot**
  * Push the bottom lane.
* defend_tower_top
  * Defend the top lane.
* defend_tower_mid
  * Defendthe top lane.
* defend_tower_bot
  * Defendthe top lane.
* ~~assemble~~
  * Ready to do something together, but doesn't seem to be enabled in game.
* **team_roam**
  * Was used to gank with smoke, but is not enabled now.
* **farm**
  * Make money by jungle or laning.
* defend_ally
  * Use abilities to protect teammates, such as healing, adding buffs, etc.
* ~~evasive_maneuvers~~
  * Evade abilities projectiles, but doesn't seem to be enabled in game.
* roshan
  * Try to kill roshan.
* **item**
  * Intended to handle item looting and item swapping, but not currently enabled.
* **ward**
  * Place Observe Ward and Sentry Ward.

### 2.2 Ability and Item usage

If you'd like to just override decisionmaking around ability and item usage, you can implement the following functions in an ability_item_usage_generic.lua file:

* ItemUsageThink() - Called every frame. Responsible for issuing item usage actions.
* AbilityUsageThink() - Called every frame. Responsible for issuing ability usage actions.
* CourierUsageThink() - Called every frame. Responsible for issuing commands to the courier.
* BuybackUsageThink() - Called every frame. Responsible for issuing a command to buyback.
* AbilityLevelUpThink() - Called every frame. Responsible for managing ability leveling.

If any of these functions are not implemented, it will fall back to the default C++ implementation.

You can additionally just override the ability/item usage logic for a single hero, such as Lina, with an `ability_item_usage_lina.lua` file. Please see Appendix A for implementation details if you'd like to chain calls from a hero-specific item/ability implementation back to a generic item/ability implementation.

### 2.3 Item Purchasing

If you'd like to just override decisionmaking around item purchasing, you can implement the following function in an item_purchase_generic.lua file:

* ItemPurchaseThink() - Called every frame. Responsible for purchasing items.

You can additionally just override the item purchasing logic for a single hero, such as Lina, with an `item_purchase_lina.lua` file.

### 2.4 Minion Control

If you would like to override minions, which are illusions, summoned units, dominated units, etc. Basically anything that's under control of your hero. But not couriers. Then you can override the think function inside your hero file.

* MinionThink( hMinionUnit )

This function will be called once per frame for every minion under control by a bot. For example, if you implemented it in `bot_beastmaster.lua`, it would constantly get called both for your boar and hawk while they're summoned and alive. The handle to the bear/hawk unit is passed in as hMinionUnit. Action commands that are usable on your hero are usable on the passed-in hMinionUnit.

### 2.5 Hero Selection

If you'd like to handle hero picking and lane assignment, you can implement the following functions in a `hero_selection.lua` file:

* Think() - Called every frame. Responsible for selecting heroes for bots.
* UpdateLaneAssignments() - Called every frame prior to the game starting. Returns ten PlayerID-Lane pairs.
* GetBotNames() - Called once, returns a table of player names.

### 2.6 Team Level Desires

If you'd like to supply team-level desires, you can implement the following functions in a `team_desires.lua` file:

* TeamThink() - Called every frame. Provides a single think call for your entire team.
* UpdatePushLaneDesires() - Called every frame. Returns floating point values between 0 and 1 that represent the desires for pushing the top, middle, and bottom lanes, respectively.
* UpdateDefendLaneDesires() - Called every frame. Returns floating point values between 0 and 1 that represent the desires for defending the top, middle, and bottom lanes, respectively.
* UpdateFarmLaneDesires() - Called every frame. Returns floating point values between 0 and 1 that represent the desires for farming the top, middle, and bottom lanes, respectively.
* UpdateRoamDesire() - Called every frame. Returns a floating point value between 0 and 1 and a unit handle that represents the desire for someone to roam and gank a specified target.
* UpdateRoshanDesire() - Called every frame. Returns a floating point value between 0 and 1 that represents the desire for the team to kill Roshan.

If any of these functions are not implemented, it will fall back to the default C++ implementation.

## 3. Common module

Some modules that can be reused are placed under the `./util` folder.
