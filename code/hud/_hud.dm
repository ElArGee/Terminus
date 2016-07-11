#define	HUD_BUFFER	3	//pixel buffer for insetting hud objects from the edge of the screen
#define HUD_COLOR	"#88FFFF"

/hudobj
	parent_type = /obj
	layer = HUD_LAYER

	icon = 'icons/ui.dmi'
	icon_state = "button"
	var/overlay_icon = 'icons/ui.dmi'
	var/overlay_icon_state = null
	var/overlay_color = null

	var/client/client
//	var/hudobj/parent
	var/hudgroup/group

	var/anchor_x = "WEST"
	var/anchor_y = "SOUTH"
	var/screen_x = 0
	var/screen_y = 0
	var/width = TILE_WIDTH
	var/height = TILE_HEIGHT
//	var/index = 0

/hudobj/New(loc=null, client/Client, list/Params, show=1)
	client = Client
	for(var/v in Params)
		vars[v] = Params[v]
	if(show)
		Show()

	if(overlay_icon && overlay_icon_state)
		overlays.Cut()
		var/image/I = new(icon = overlay_icon, icon_state = overlay_icon_state)
		if(overlay_color)
			I.color = overlay_color
		else
			I.color = HUD_COLOR
		overlays += I
	..()

/hudobj/proc/SwapWith(var/hudobj/target)
//	dout("SwapWith")
	if(group != target.group)
		group.MoveHUDObj(src, target.group)
	group.SwapHUDObj(src, target)

/hudobj/proc/MoveToGroup(var/hudgroup/target)
	group.Remove(src)
	target.Add(src)

/hudobj/proc/GetIndex()
	if(group)
		return group.hudobjs.Find(src) - 1
/*	else if(parent)
		return parent.GetIndex()*/
	else
		return 1

/hudobj/proc/SetSize(W, H)
	width = W
	height = H
	if(anchor_x != "WEST" || anchor_y != "SOUTH")
		UpdatePos()

/hudobj/proc/SetPos(X, Y, AnchorX="WEST", AnchorY="SOUTH")
	screen_x = X
	anchor_x = AnchorX
	screen_y = Y
	anchor_y = AnchorY
	UpdatePos()

/hudobj/proc/UpdatePos()
	var/ax
	var/ay
	var/ox
	var/oy
	switch(anchor_x)
		if("WEST")
			ax = "WEST+0"
			ox = screen_x + (GetIndex()  * TILE_WIDTH) + HUD_BUFFER
		if("EAST")
			ax = "EAST+0"
			ox = screen_x - (GetIndex() * TILE_WIDTH) - HUD_BUFFER
		if("CENTER")
			ax = "CENTER+0"
			ox = floor((TILE_WIDTH - width)/2) + screen_x + ((GetIndex() - ((group.hudobjs.len - 1) / 2)) * TILE_WIDTH)

	switch(anchor_y)
		if("SOUTH")
			ay = "SOUTH+0"
			oy = screen_y + HUD_BUFFER
		if("NORTH")
			ay = "NORTH+0"
/*			if(parent && parent.anchor_y == NORTH)
				oy = -TILE_HEIGHT - height + screen_y - HUD_BUFFER
			else*/
			oy = TILE_HEIGHT - height + screen_y - HUD_BUFFER
		if("CENTER")
			ay = "CENTER+0"
			oy = floor((TILE_HEIGHT - height)/2) + screen_y

	screen_loc = "[ax]:[ox],[ay]:[oy]"

/hudobj/proc/Show()
	UpdatePos()
	client.screen += src

/hudobj/proc/Hide()
	client.screen -= src

/**********************************\
 On screen button popup menu
\**********************************/
/hudobj/menu
	var/state = 0	//0 = closed, 1 = open
	var/list/button_types = null
	var/list/buttons = null
	var/hudobj/selected = null

/hudobj/menu/New()
	..()
	buttons = new()
	for(var/type in button_types)
		var/hudobj/H = new type(null, client, list(parent = src), 0)
		buttons += H

	for(var/i = 1; i <= buttons.len; i++ )
		var/hudobj/H = buttons[i]
//		H.UpdateMenuButton(i)
		H.anchor_x = anchor_x
		H.anchor_y = anchor_y
		H.screen_x = screen_x
		H.screen_y = TILE_HEIGHT * i
		if(i == 1)
			H.icon_state = "popup_bottom"
		else if(i == buttons.len)
			H.icon_state = "popup_top"
		else
			H.icon_state = "popup_mid"

	UpdateSelected(buttons[buttons.len])
	ToggleMenu()

/hudobj/popup_button/proc/UpdateMenuButton(var/i)
	var/hudobj/menu/M = parent
	anchor_x = M.anchor_x
	anchor_y = M.anchor_y
	screen_x = M.screen_x
	if(M.anchor_y == "NORTH")
		screen_y = -TILE_HEIGHT * i
	else
		screen_y = TILE_HEIGHT * i
	//var/list/index = parent.buttons
	if(i == 1)
		icon_state = "popup_bottom"
	else if(i == M.buttons.len)
		icon_state = "popup_top"
	else
		icon_state = "popup_mid"

/hudobj/menu/Click(var/location, var/control, var/params)
	state = !state
	ToggleMenu()

/hudobj/menu/proc/ToggleMenu()
	switch(state)
		if(1)
			for(var/hudobj/H in buttons)
				H.Show()
		if(0)
			for(var/hudobj/H in buttons)
				H.Hide()

/hudobj/menu/proc/UpdateSelected(var/hudobj/H)
	if(H in buttons)
		selected = H
		overlays.Cut()
		overlays = selected.overlays

/hudobj/popup_button
	var/hudobj/menu/parent

/hudobj/popup_button/Click()
	parent.UpdateSelected(src)
	parent.state = 0
	parent.ToggleMenu()

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

/hudgroup/proc/Add(var/hudobj/new_obj, var/hudobj/target_obj = null)
	if(!new_obj || (!target_obj && hudobjs.Find(new_obj)))
		return
	if(!hudobjs)
		hudobjs = new()

	var/insert_loc = 0
	if(target_obj)
		insert_loc = hudobjs.Find(target_obj)

	hudobjs.Insert(insert_loc, new_obj)
	new_obj.anchor_x = anchor_x
	new_obj.anchor_y = anchor_y
	new_obj.client = client
	new_obj.group = src
	UpdateHUD()

/hudgroup/proc/Remove(var/hudobj/H)
	hudobjs.Remove(H)
	UpdateHUD()

/hudgroup/proc/SwapHUDObj(var/hudobj/target, var/hudobj/destination)
	hudobjs.Swap(target.GetIndex() + 1, destination.GetIndex() + 1)
	UpdateHUD()

/hudgroup/proc/MoveHUDObj(var/hudobj/target, var/hudgroup/destination)
	var/hudgroup/old_group = target.group
	hudobjs.Remove(target)
	destination.Add(target)
	old_group.UpdateHUD()

/hudgroup/proc/UpdateHUD()
	for(var/hudobj/H in hudobjs)
		H.UpdatePos()
