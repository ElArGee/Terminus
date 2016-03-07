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
	var/hudobj/center
	var/hudobj/bottomcenter

/client/New()
	topleft = new(null, src, list(icon = 'floor.dmi', icon_state = "north", anchor_x = "WEST", anchor_y = "NORTH"), 1)
	topright = new(null, src, list(icon = 'floor.dmi', icon_state = "east", anchor_x = "EAST", anchor_y = "NORTH"), 1)
	bottomleft = new(null, src, list(icon = 'floor.dmi', icon_state = "west", anchor_x = "WEST", anchor_y = "SOUTH"), 1)
	bottomright = new(null, src, list(icon = 'floor.dmi', icon_state = "south", anchor_x = "EAST", anchor_y = "SOUTH"), 1)
	center = new(null, src, list(icon = 'floor.dmi', icon_state = "center", anchor_x = "CENTER", anchor_y = "CENTER"), 1)
	bottomcenter = new(null, src, list(icon = 'floor.dmi', icon_state = "center", anchor_x = "CENTER", anchor_y = "SOUTH"), 1)
	..()

/client/Del()
	topleft = null
	topright = null
	bottomleft = null
	bottomright = null
	center = null
	screen.Cut()
	..()

/client/verb/onResize()
	set hidden = 1
	set waitfor = 0
	var/sz = winget(src, "mainmap", "size")
	var/map_width = text2num(sz)
	var/map_height = text2num(copytext(sz, findtext(sz, "x") + 1, 0))
	map_zoom = 1

	view_width = ceil(map_width / TILE_WIDTH)
	if(!(view_width % 2))
		++view_width
	view_height = ceil(map_height / TILE_HEIGHT)
	if(!(view_height % 2))
		++view_height

	while(view_width * view_height > MAX_VIEW_TILES)
		view_width = ceil(map_width / TILE_WIDTH / ++map_zoom)
		if(!(view_width % 2))
			++view_width
		view_height = ceil(map_height / TILE_HEIGHT / map_zoom)
		if(!(view_height % 2))
			++view_height

	buffer_x = floor((view_width * TILE_WIDTH - map_width / map_zoom) / 2)
	buffer_y = floor((view_height * TILE_HEIGHT - map_height / map_zoom) / 2)

	src.view = "[view_width]x[view_height]"
	winset(src, "mainmap", "zoom=[map_zoom];")

	for(var/hudobj/h in screen)
		h.updatePos()

/mob/Login()
	client.onResize()
	return ..()
