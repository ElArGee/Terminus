/client
	var/view_width
	var/view_height
	var/buffer_x
	var/buffer_y
	var/map_zoom

	var/hudobj/topleft
	var/hudobj/topright
	var/hudobj/bottomleft
	var/hudobj/bottomright
	var/hudobj/bottomcenter

	var/hudgroup/top_left
	var/hudgroup/top_mid
	var/hudgroup/top_right
	var/hudgroup/mid_left
	var/hudgroup/mid_mid
	var/hudgroup/mid_right
	var/hudgroup/bottom_left
	var/hudgroup/bottom_mid
	var/hudgroup/bottom_right

	var/modify_hud = FALSE
	var/hudobj/modifying_hudobj = null

	var/obj/screen/black/modify_overlay = null


/client/New()
	key_actions = list()
	keybinds = list()

	for(var/T in (typesof(/keybind) - /keybind))
		key_actions.Add(new T(src))
/*
	//temp code for mapping keybinds at client join
	for(var/keybind/K in key_actions)
		switch(K.name)
			if("Move Up")
				keybinds["W"] = K
			if("Move Down")
				keybinds["R"] = K
			if("Move Left")
				keybinds["A"] = K
			if("Move Right")
				keybinds["S"] = K
			if("Run")
				keybinds["SHIFT"] = K
			if("Modify HUD")
				keybinds["Escape"] = K
*/
/*
	modify_overlay = new(null, src)
	bottom_left = new(null, src, list(anchor_x = "WEST", anchor_y = "SOUTH"))


	var/hudobj/toggle/pull/P = new(null, src, null, 1)
	bottom_left.Add(P)
	var/hudobj/menu/intent/M = new(null, src, null, 1)
	bottom_left.Add(M)

	var/hudobj/toggle/drop/D = new(null, src, null, 1)
	bottom_left.Add(D)

	top_mid = new(null, src, list(anchor_x = "CENTER", anchor_y = "NORTH"))

	var/hudobj/toggle/resist/R = new(null, src, null, 1)
	top_mid.Add(R)

	var/hudobj/toggle/throw/T = new(null, src, null, 1)
	top_mid.Add(T)

	var/hudobj/toggle/zone/Z = new(null, src, null, 1)
	top_mid.Add(Z)

	var/hudobj/toggle/drop/Dt = new(null, src, null, 1)
	top_mid.Add(Dt)

	var/hudobj/toggle/pull/Pt = new(null, src, null, 1)
	top_mid.Add(Pt)
*/


/*	top_left = new(null, src, list(anchor_x = "WEST", anchor_y = "NORTH"))
	top_left.Add(P)*/
	..()

/client/Del()
	topleft = null
	topright = null
	bottomleft = null
	bottomright = null
	screen.Cut()
	..()

/client/verb/onResize()
	set hidden = 1
	set waitfor = 0

	var/sz = winget(src, "mainwindow", "size")
	var/map_width = text2num(sz)
	var/map_height = text2num(copytext(sz, findtext(sz, "x") + 1, 0))

	if(map_width < map_height)
		map_zoom = map_width / TILE_WIDTH
	else
		map_zoom = map_height / TILE_HEIGHT

	map_zoom = max(1, floor(map_zoom / (view * 2 + 1)))

	winset(src, "mainmap", "zoom=[map_zoom];")
	for(var/hudobj/H in screen)
		H.UpdatePos()

/client/Click(atom/object, location, control, params)
	if(modify_hud)
		if(!modifying_hudobj)
			if(istype(object, /hudobj))
				modifying_hudobj = object
				dout("selected hudobj: [modifying_hudobj]")
			else
				return
		else if(istype(object, /hudobj))
			dout("moving [modifying_hudobj] to [object]")
			modifying_hudobj.SwapWith(object)
			modifying_hudobj = null
		else if(istype(object, /hudgroup))
			modifying_hudobj.MoveToGroup(object)
			modifying_hudobj = null
		else
			return
	else
		object.Click(mob, location, control, params)

/client/proc/ModifyHUD()
	if(modify_hud)
		modify_overlay.Show()
	else
		modify_overlay.Hide()

/mob/Login()
	client.onResize()
	return ..()
