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
//	KeyDown movement keybinds set the move dir variable, then call the appropriate client directional movement proc
//	KeyUp movement keybinds unset the move dir variable
/keybind/north
	name = "Move Up"

/keybind/north/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= NORTH
	attached_client.North()

/keybind/north/KeyUp()
	if(!..())
		return
	attached_client.move_dir &= ~NORTH


/keybind/south
	name = "Move Down"

/keybind/south/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= SOUTH
	attached_client.South()

/keybind/south/KeyUp()
	if(!..())
		return
	attached_client.move_dir &= ~SOUTH

/keybind/east
	name = "Move Right"

/keybind/east/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= EAST
	attached_client.East()

/keybind/east/KeyUp()
	if(!..())
		return
	attached_client.move_dir &= ~EAST


/keybind/west
	name = "Move Left"

/keybind/west/KeyDown()
	if(!..())
		return
	attached_client.move_dir |= WEST
	attached_client.West()

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
