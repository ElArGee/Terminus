/hudobj
	parent_type = /obj
	layer = HUD_LAYER
	var/client/client
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
			ox = screen_x + client.buffer_x
		if("EAST")
			if(width>TILE_WIDTH)
				var/tx = ceil(width/TILE_WIDTH)
				ax = "EAST-[tx-1]"
				ox = tx*TILE_WIDTH - width - client.buffer_x + screen_x
			else
				ax = "EAST+0"
				ox = TILE_WIDTH - width - client.buffer_x + screen_x
		if("CENTER")
			ax = "CENTER+0"
			ox = floor((TILE_WIDTH - width)/2) + screen_x

	switch(anchor_y)
		if("SOUTH")
			ay = "SOUTH+0"
			oy = screen_y + client.buffer_y
		if("NORTH")
			if(height>TILE_HEIGHT)
				var/ty = ceil(height/TILE_HEIGHT)
				ay = "NORTH-[ty-1]"
				oy = ty*TILE_HEIGHT - height - client.buffer_y + screen_y
			else
				ay = "NORTH+0"
				oy = TILE_HEIGHT - height - client.buffer_y + screen_y
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
