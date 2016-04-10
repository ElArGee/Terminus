/proc/dout(var/s)
#if DOUT
	world << "<span class='debug'>DEBUG: [s]</span>"
#else
	return
#endif

/client/verb/usr_dout(var/s as text)
	set name = "dout"
	dout(s)

var
  worldstarttime = 0
  worldstarttimeofday = 0

client
  Stat()
	#if WORLDTICKDRIFT
    if (!worldstarttime || worldstarttimeofday)
      worldstarttime = world.time
      worldstarttimeofday = world.timeofday
    var/tickdrift = (worldstarttimeofday - world.timeofday) - (worldstarttime - world.time)  / world.tick_lag
    statpanel("Tick Drift", "[round(tickdrift)] Missed ticks")
	#endif
    ..()
