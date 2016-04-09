/hudobj
	parent_type = /obj
	layer = HUD_LAYER
	icon = 'icons/ui.dmi'
	icon_state = "button"
	var/client/client
	var/hudobj/parent
	var/anchor_x = "WEST"
	var/anchor_y = "SOUTH"
	var/screen_x = 0
	var/screen_y = 0
	var/width = TILE_WIDTH
	var/height = TILE_HEIGHT

/hudobj/proc/setSize(W, H)
	width = W
	height = H
	if(anchor_x != "WEST" || anchor_y != "SOUTH")
		updatePos()

/hudobj/proc/setPos(X, Y, AnchorX="WEST", AnchorY="SOUTH")
	screen_x = X
	anchor_x = AnchorX
	screen_y = Y
	anchor_y = AnchorY
	updatePos()

/hudobj/proc/updatePos()
	var/ax
	var/ay
	var/ox
	var/oy
	switch(anchor_x)
		if("WEST")
			ax = "WEST+0"
			ox = screen_x
		if("EAST")
			if(width>TILE_WIDTH)
				var/tx = ceil(width/TILE_WIDTH)
				ax = "EAST-[tx-1]"
				ox = tx * TILE_WIDTH - width + screen_x
			else
				ax = "EAST+0"
				ox = TILE_WIDTH - width + screen_x
		if("CENTER")
			ax = "CENTER+0"
			ox = floor((TILE_WIDTH - width)/2) + screen_x

	switch(anchor_y)
		if("SOUTH")
			ay = "SOUTH+0"
			oy = screen_y
		if("NORTH")
			if(height>TILE_HEIGHT)
				var/ty = ceil(height/TILE_HEIGHT)
				ay = "NORTH-[ty-1]"
				oy = ty*TILE_HEIGHT - height + screen_y
			else
				ay = "NORTH+0"
				oy = TILE_HEIGHT - height + screen_y
		if("CENTER")
			ay = "CENTER+0"
			oy = floor((TILE_HEIGHT - height)/2) + screen_y

	screen_loc = "[ax]:[ox],[ay]:[oy]"

/hudobj/proc/show()
	updatePos()
	client.screen += src

/hudobj/proc/hide()
	client.screen -= src

/hudobj/New(loc=null, client/Client, list/Params, show=1)
	client = Client
	for(var/v in Params)
		vars[v] = Params[v]
	if(show)
		show()


/**********************************\
 On screen button popup menu
\**********************************/
/hudobj/menu
	var/state = 0	//0 = closed, 1 = open
	var/list/button_types = null
	var/list/buttons = null
	var/hudobj/selected = null

/hudobj/menu/intent
	button_types = list(/hudobj/intent/harm, /hudobj/intent/disarm, /hudobj/intent/grab, /hudobj/intent/help)

/hudobj/menu/New()
	..()
	buttons = new()
	for(var/type in button_types)
		var/hudobj/H = new type(null, client, list(parent = src), 0)
		buttons += H

	for(var/i = 1; i <= buttons.len; i++ )
		var/hudobj/H = buttons[i]
		H.anchor_x = anchor_x
		H.anchor_y = anchor_y
		H.screen_y = TILE_HEIGHT * i
		if(i == 1)
			H.icon_state = "popup_bottom"
		else if(i == buttons.len)
			H.icon_state = "popup_top"
		else
			H.icon_state = "popup_mid"

	UpdateSelected(buttons[buttons.len])
	ToggleMenu()

/hudobj/menu/Click(var/location, var/control, var/params)
	state = !state
	ToggleMenu()

/hudobj/menu/proc/ToggleMenu()
	switch(state)
		if(1)
			for(var/hudobj/H in buttons)
				H.show()
		if(0)
			for(var/hudobj/H in buttons)
				H.hide()

/hudobj/menu/proc/UpdateSelected(var/hudobj/H)
	if(H in buttons)
		selected = H
		overlays.Cut()
		overlays = selected.overlays

/**********************************\
 hudgroup
	Framework for grouping hudobjs
	on screen.
\**********************************/
/hudgroup
	parent_type = /obj
	layer = HUD_LAYER
	var/client/client
	var/anchor_x = "CENTER"
	var/anchor_y = "CENTER"
	var/screen_x = 0
	var/screen_y = 0
	var/list/hudobjs = new()

/hudgroup/New(loc=null, client/Client, list/Params)
	client = Client
	for(var/v in Params)
		vars[v] = Params[v]
