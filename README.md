# NS2 Combat++
**Version 0.4 Alpha**

## Overview
The intent of this mod is to bring back a gameplay type using the orignial Natural Selection 1 Combat Mod for primary insiration, use the [Natural Selection 2 Combat Mod](https://github.com/AlexHayton/NS2Combat) as a reference and possibly incorporate some ideas from the Combat Standalone (placing structures, etc).  Seeing as how the title is still 'Combat', I'd like to keep that original gametype feel as much as possible (individual xp, no commanders), an not alter the lifeform, gun, or game physics as many players use combat for practicing for the vanilla game.

## Contributing
Check out the issues backlog.  If something is marked **Help Wanted**, then feel free to implement it and send me a pull request.

## Change Log
**6/8/2018** - Added rejoin penalty and free spawn time at beginning of match.

**6/1/2018** - Refactored code to use Ghoul's folder hooks method.  Added round time (with overtime), team rebalance xp, and late join xp.

**5/27/2018** - Respawn Improvements

    > Updated respawn code to mimic Combat Classic wave spawning. The number of players that spawn each wave is controlled through a variable that will be made available in a config later.

    > Moved over spawn protection code from Combat Classic

    > Fixed isssue with advanced metabolize not working

    > Fixed issue #41 that caused the server to crash with "too many entities"
    
**5/25/2018** - Alien Abilities

    > Alien abilities can now be purchased as upgrades from the Alien Buy Menu

    > Fixed issue with the upgrade tree not getting properly reset and initialized when switching teams mid game

    > Fixed issue with xp not resetting when switching teams mid game

**5/18/2018** - UI Improvements

    > Made the Buy Menus more transparent.

    > Addressed scaling issues on other resolutions.

    > Reduced the length of the xp bar by 200 pixels.

    > Fixed issue with not being able choose upgrades as a skulk.

    > Fixed issue with not being able to upgrade more than one upgrade at a time as Alien.

**5/10/2018** - Enabled sprinting while using the builder in create mode.

**5/6/2018** - Overall uplift to the structure logic.

    > Fixed issue with player spawning with the builder in create mode if they died with the builder open.  This also corrected the issue where the upgrade points could go negative.
    
    > Fixed issue with only being able to select a certain structure once from the buy menu.
    
    > Added hard caps to structures so that there is a limit for how many of a structure type the team can place.
    
    > If a player leaves the team or disconnects, the structures they placed will now be killed.
    
    > If a player's structure is destroyed, they are refunded the upgrade points they spent on that structure.
    
    > There is still no good way to reselect the builder tool (create mode).  The workaround is to select the structure from the buy menu again.

**5/4/2018** - Major overhaul to the upgrade system, some updates to the Marine Buy Menu, more progress on Alien Buy Menu.

**4/3/2018** - Players now gain xp for teammate kills nearby, ejecting from Exos has been disabled, and players now receive credit for sentry and babbler kills if they are the one that placed/created it.

**1/24/2018** - Added the xp bar and text to the Alien HUD, track healing for Aliens, and added an Auto-Cyst feature to the Hive.

**1/15/2018** - Experience is now given for building structures and welding.  Added Upgrade Point award for the 'Damage Dealer' criteria.  Implemented an XP scale/modifier based on the distance between the player and the enemy base. Also, some improvements to the XP notification GUI.

**1/13/2018** - Marines can now press the USE key to socket power nodes.  This is a change from the original idea of socketing them all on game start.

**1/13/2018** - Added cooldown abilities for Marines (MedPack, AmmoPack, CatPack, Scan).

**1/7/2018** - Command station and hive will now be "occupied" and therefore in their visibly closed state.

**1/7/2018** - Sentries now work without the battery.

**12/30/2017** - Modified Builder to have a 'Create' mode.  Marines can now place structures.  Lots of polish on the Marine Buy Menu.

## Contributing
Check out the issues backlog.  If something is marked **Help Wanted**, then feel free to implement it and send me a pull request.  For the time being, I'll be handling most of the Epics until I get the upgrade code refactored into a managable system instead of the hacked in mess it is right now.

## Credits
Level up icon made by [Vaadin](https://www.flaticon.com/authors/vaadin) from www.flaticon.com

Radar icon made by [mola](https://openclipart.org/user-detail/mola) from openclipart.org

Infinity icon made by [alaindelluc](https://thenounproject.com/alaindelluc/) from thenounproject.com

Close icon made by [Juliia Osadcha](https://www.shareicon.net/author/juliia-osadcha) at shareicon.net
