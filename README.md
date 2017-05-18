PEEEDO
===============


**PEEEDO** ist nur ein Gamemode




----------
#### <i class="icon-file"></i> Developer documentation
-------------
<i class="icon-th-list">Serverside hooks:
>

<i class="icon-user">Clientside hooks:
>

<i class="icon-user"><i class="icon-th-list">Shared hooks:

>
**PEDO_Initialize** Calls when the gamemode is initialized
**PEDO_RoundEnd** Calls at the end of the round. **Returns Winner**
**PEDO_RoundStart** Calls the beginning of the round


----------
#### <i class="icon-pencil"></i> Configuration
you can configure the gamemode at [*pedocore/gamemode/shared.lua*](https://github.com/habobababo/PEEEDO/blob/master/pedocore/gamemode/shared.lua)

A short list of some configs here
>PEDO.RoundTime = `300` *x minutes roundtime is legit*
PEDO.PreRoundTime = `5` -- *the x seconds before the round starts*
PEDO.PrepareTime = `30` -- *the first round right after mapchange*
PEDO.SpawnTime = `15` -- *pedobear has another x seconds to spawn*
PEDO.NotificationTime = `7` -- *the time of the notification*
PEDO.CatchRadius = `40` --* if a victim comes below that range, he will die.*
PEDO.PedoWalkSpeed = `250` --*default walkspeed of the pedobear*
PEDO.VicWalkSpeed = `220` -- *--||-------------------- victim*
PEDO.RunSpeed = `300` -- *press SHIFT <IN_SPEED> and run!, thats the speed*
PEDO.PedoSpawnRate = `6` -- *1 pedobears on 6 players. --> with 12 players you got 2 pedobears*
PEDO.StaminaDrain = `0.01` -- *How fast the stamina drains to zero. 1 is faster, 0.01 is slow*
PEDO.StaminaRestoreTime =` 0.1`  -- *restoretime. Same as above*
PEDO.DelayRestoreStamina =` 4` -- *x seconds after release the key, the stamina starts restoring*
PEDO.StaminaDeadPoint = `10` -- *if stamina is below x, you can't run anymore*

----------
