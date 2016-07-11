/obj/structure/wall
	icon = 'icons/wall.dmi'
	icon_state = "0"
	density = TRUE
	var/wall_dirs = 0
	var/panel_on = TRUE

/obj/structure/wall/proc/UpdateIcon()
	//var/wall_dirs = 0
	for(var/D in cardinal)
		var/dir_x = x
		var/dir_y = y

		switch(D)
			if(NORTH)
				dir_y++
			if(SOUTH)
				dir_y--
			if(EAST)
				dir_x++
			if(WEST)
				dir_x--

		var/turf/T = locate(dir_x, dir_y, z)
		if(T)
			var/obj/structure/wall/W = locate(type) in T
			if(W && W.type == type)
				wall_dirs += D
	icon_state = "[wall_dirs]"

/obj/structure/wall/Click(mob/mob,location,control,params)
	switch(wall_dirs)
		if(3, 12)
			panel_on = !panel_on
		else
			return

	overlays.Cut()
	if(panel_on)
		icon_state = "[wall_dirs]"
	else
		icon_state = "[wall_dirs]_frame"
		var/click_dir = get_dir(mob,src)
		if(wall_dirs == 3)
			if(click_dir & EAST)
				overlays += image(icon = icon, icon_state = "[wall_dirs]_E")
			else
				overlays += image(icon = icon, icon_state = "[wall_dirs]_W")
		else
			if(click_dir & NORTH)
				overlays += image(icon = icon, icon_state = "[wall_dirs]_N")
			else
				overlays += image(icon = icon, icon_state = "[wall_dirs]_S")
