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

>**PEDO_Initialize** Calls when the gamemode is initialized<br>
**PEDO_RoundEnd** Calls at the end of the round. **Returns Winner**<br>
**PEDO_RoundStart** Calls the beginning of the round


----------
#### <i class="icon-pencil"></i> Configuration
you can configure the gamemode at [*pedocore/gamemode/shared.lua*](https://github.com/habobababo/PEEEDO/blob/master/pedocore/gamemode/shared.lua)

A short list of some configs here
>PEDO.RoundTime = `300` *x minutes roundtime is legit*<br>
PEDO.PreRoundTime = `5` *the x seconds before the round starts*<br>
PEDO.PrepareTime = `30` *the first round right after mapchange*<br>
PEDO.SpawnTime = `15` *pedobear has another x seconds to spawn*<br>
PEDO.NotificationTime = `7` *the time of the notification*<br>
PEDO.CatchRadius = `40` * if a victim comes below that range, he will die.*<br>
PEDO.PedoWalkSpeed = `250` *default walkspeed of the pedobear*<br>
PEDO.VicWalkSpeed = `220` *--||-------------------- victim*<br>
PEDO.RunSpeed = `300` *press SHIFT <IN_SPEED> and run!, thats the speed*<br>
PEDO.PedoSpawnRate = `6` *1 pedobears on 6 players. --> with 12 players you got 2 pedobears*<br>
PEDO.StaminaDrain = `0.01` *How fast the stamina drains to zero. 1 is faster, 0.01 is slow*<br>
PEDO.StaminaRestoreTime =` 0.1` *restoretime. Same as above*<br>
PEDO.DelayRestoreStamina =` 4` *x seconds after release the key, the stamina starts restoring*<br>
PEDO.StaminaDeadPoint = `10` *if stamina is below x, you can't run anymore*<br>

----------
