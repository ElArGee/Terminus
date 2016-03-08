/*
keybind:
	Proxy for performing actions when an associated key is pressed and/or released.
	i.e. move north, open inventory, run, etc.

New()
	Creates a new keybind object.

	Args:
		client/C: the client that is creating the keybind object.

KeyDown()
	Called by a client when the associated key is pressed.

	Returns:
		Success: when an attached client exists.
		Failure: when there is no attached client.

KeyUp()
	Called by a client when the associated key is released.

	Returns:
		Success: when an attached client exists.
		Failure: when there is no attached client.
*/
/keybind
	var/name = ""
	var/client/attached_client

/keybind/New(var/client/C)
	if(istype(C))
		attached_client = C
	..()

/keybind/proc/KeyDown()
	if(!attached_client)
		return FALSE
	return TRUE

/keybind/proc/KeyUp()
	if(!attached_client)
		return FALSE
	return TRUE


//Movement keybinds
/keybind/north
	name = "Move Up"

/keybind/south
	name = "Move Down"

/keybind/east
	name = "Move Right"

/keybind/west
	name = "Move Left"

//	KeyDown movement keybinds set the move dir variable, then call the appropriate client directional movement proc
/keybind/north/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= NORTH
	attached_client.North()

/keybind/south/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= SOUTH
	attached_client.South()

/keybind/east/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= EAST
	attached_client.East()

/keybind/west/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= WEST
	attached_client.West()

//	KeyUp movement keybinds unset the move dir variable
/keybind/north/KeyUp()
	if(!..())
		return
	attached_client.move_dir &= ~NORTH

/keybind/south/KeyUp()
	if(!..())
		return
	attached_client.move_dir &= ~SOUTH

/keybind/east/KeyUp()
	if(!..())
		return
	attached_client.move_dir &= ~EAST

/keybind/west/KeyUp()
	if(!..())
		return
	attached_client.move_dir &= ~WEST


//var and proc modifications for /client
/client
	var/move_dir = 0		//bitflags for movement keys being held down
	var/bind = FALSE		//flag for rebinding keys
	var/list/key_actions	//list of all keybind actions
	var/list/keybinds		//list of keybind actions associated with a key

/client/New()
	key_actions = list()
	keybinds = list()

	for(var/T in (typesof(/keybind) - /keybind))
		key_actions.Add(new T(src))

//	keybinds = list("W" = new/keybind/north(src), "A" = new/keybind/west(src), "S" = new/keybind/east(src), "R" = new/keybind/south(src))
	..()

//client directional movement proc overrides
//	checks if a perpendicular movement key is being held down
//	if one is, call the diagonal movement proc instead
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

//KeyDown and KeyUp verbs:
//	called when a key is pressed, which then calls the keybind event associated with that keycode
/client/verb/KeyDown(var/KeyID as text)
	set name = ".keydown"
	set instant = 1

	if(bind)
		BindKey(KeyID)
		return

	var/keybind/K = keybinds[KeyID]
	if(K)
		K.KeyDown()

/client/verb/KeyUp(var/KeyID as text)
	set name = ".keyup"
	set instant = 1

	var/keybind/K = keybinds[KeyID]
	if(K)
		K.KeyUp()

/client/verb/UsrBindKey()
	set name = "bindkey"

	bind = TRUE
	alert("Press 'Ok', then press the key you want to rebind.")

/client/proc/BindKey(var/KeyID)
	if(KeyID)
		var/keybind/K = input("Select action to rebind \"[KeyID]\" to:", "Rebind key", keybinds[KeyID]) in key_actions

		dout("Selected: [K] for key: [KeyID]")

		keybinds[KeyID] = K

	bind = FALSE
	return
