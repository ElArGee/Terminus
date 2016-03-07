/keybind
	var/client/attached_client

/keybind/New(var/client/C)
	if(istype(C))
		attached_client = C
	..()

//KeyDown event
/keybind/proc/KeyDown()
	if(!attached_client)
		return TRUE
	return FALSE

/keybind/north/KeyDown()
	if(..())
		return
	attached_client.move_dir |= NORTH
	attached_client.North()

/keybind/south/KeyDown()
	if(..())
		return
	attached_client.move_dir |= SOUTH
	attached_client.South()

/keybind/east/KeyDown()
	if(..())
		return
	attached_client.move_dir |= EAST
	attached_client.East()

/keybind/west/KeyDown()
	if(..())
		return
	attached_client.move_dir |= WEST
	attached_client.West()

//KeyUp event
/keybind/proc/KeyUp()
	if(!attached_client)
		return TRUE
	return FALSE

/keybind/north/KeyUp()
	if(..())
		return
	attached_client.move_dir &= ~NORTH

/keybind/south/KeyUp()
	if(..())
		return
	attached_client.move_dir &= ~SOUTH

/keybind/east/KeyUp()
	if(..())
		return
	attached_client.move_dir &= ~EAST

/keybind/west/KeyUp()
	if(..())
		return
	attached_client.move_dir &= ~WEST


/client
	var/move_dir = 0
	var/list/keybinds

/client/New()
	keybinds = list("87" = new/keybind/north(src), "65" = new/keybind/west(src), "83" = new/keybind/east(src), "82" = new/keybind/south(src))
	..()

/client/North()
	if(move_dir & EAST)
		Northeast()
	else if(move_dir & WEST)
		Northwest()
	else
		..()

/client/South()
	if(move_dir & EAST)
		Southeast()
	else if(move_dir & WEST)
		Southwest()
	else
		..()

/client/East()
	if(move_dir & NORTH)
		Northeast()
	else if(move_dir & SOUTH)
		Southeast()
	else
		..()

/client/West()
	if(move_dir & NORTH)
		Northwest()
	else if(move_dir & SOUTH)
		Southwest()
	else
		..()

/client/verb/KeyDown(var/KeyID as num)
	set name = ".keydown"
	set hidden = 1
	set instant = 1

	var/keybind/K = keybinds["[KeyID]"]
	if(K)
		K.KeyDown()

/client/verb/KeyUp(var/KeyID as num)
	set name = ".keyup"
	set hidden = 1
	set instant = 1

	var/keybind/K = keybinds["[KeyID]"]
	if(K)
		K.KeyUp()
