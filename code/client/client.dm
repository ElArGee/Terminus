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


/client/New()
	var/hudobj/menu/intent/M = new(null, src, list(anchor_x = "EAST", anchor_y = "SOUTH"), 1)
	bottomright = M
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
	for(var/hudobj/h in screen)
		h.updatePos()

/mob/Login()
	client.onResize()
	return ..()
