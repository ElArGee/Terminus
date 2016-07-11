/proc/dout(var/s)
#if DOUT
	world << "<span class='debug'>DEBUG: [s]</span>"
#else
	return
#endif

/client/verb/usr_dout(var/s as text)
	set name = "dout"
	dout(s)

/var/global/worldstarttime = 0
/var/global/worldstarttimeofday = 0

/client/Stat()
	#if WORLDTICKDRIFT
	if (!worldstarttime || worldstarttimeofday)
		worldstarttime = world.time
		worldstarttimeofday = world.timeofday
	var/tickdrift = (worldstarttimeofday - world.timeofday) - (worldstarttime - world.time)  / world.tick_lag
	if(usr)
		statpanel("Tick Drift", "[round(tickdrift)] Missed ticks")
	#endif
	..()
/*
/client/verb/test_walls()
	set name = "wall test"
	for(var/obj/structure/wall/W in world)
		W.update()
*/

/world/New()
	..()
	for(var/obj/structure/wall/W in world)
		W.UpdateIcon()


/client/verb/test_walls()
	set name = "wall test"
	var/wall_count = 0
	for(var/obj/structure/wall/W in world)
		wall_count++

	var/time = world.timeofday
	for(var/obj/structure/wall/W in world)
		W.UpdateIcon()
	var/total_time = world.timeofday - time
	dout("[wall_count] walls took [total_time / 10]s to update : [(total_time / wall_count) / 10]s each")

/client/verb/ChangeMoveDelay()
	set name = "Change Move Delay"
	var/new_delay = input("Input new move delay", "Change move delay", mob.move_delay) as num
	mob.move_delay = new_delay
	mob.UpdateMoveDelay()

/client/verb/ToggleRun()
	set name = "Toggle run"
	toggle_run = !toggle_run
	dout("toggle_run [toggle_run ? "On" : "Off"]")

/client/verb/ToggleInjured()
	set name = "Toggle injured"
	mob.injured = !mob.injured
	mob.UpdateMoveDelay()
	dout("injured [mob.injured ? "On" : "Off"]")
