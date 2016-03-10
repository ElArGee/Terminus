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
	attached_client.move_dir_y = NORTH
	attached_client.North()

/keybind/north/KeyUp()
	if(!..())
		return

	if(attached_client.move_dir_y == NORTH)
		attached_client.move_dir_y = 0

	attached_client.MoveStop()

	switch(attached_client.move_dir_x)
		if(EAST)
			attached_client.East()
		if(WEST)
			attached_client.West()

/keybind/south
	name = "Move Down"

/keybind/south/KeyDown()
	if(!..())
		return
	attached_client.move_dir_y = SOUTH
	attached_client.South()

/keybind/south/KeyUp()
	if(!..())
		return

	if(attached_client.move_dir_y == SOUTH)
		attached_client.move_dir_y = 0

	attached_client.MoveStop()

	switch(attached_client.move_dir_x)
		if(EAST)
			attached_client.East()
		if(WEST)
			attached_client.West()

/keybind/east
	name = "Move Right"

/keybind/east/KeyDown()
	if(!..())
		return
	attached_client.move_dir_x = EAST
	attached_client.East()

/keybind/east/KeyUp()
	if(!..())
		return

	if(attached_client.move_dir_x == EAST)
		attached_client.move_dir_x = 0

	attached_client.MoveStop()

	switch(attached_client.move_dir_y)
		if(NORTH)
			attached_client.North()
		if(SOUTH)
			attached_client.South()

/keybind/west
	name = "Move Left"

/keybind/west/KeyDown()
	if(!..())
		return
	attached_client.move_dir_x = WEST
	attached_client.West()

/keybind/west/KeyUp()
	if(!..())
		return

	if(attached_client.move_dir_x == WEST)
		attached_client.move_dir_x = 0

	attached_client.MoveStop()

	switch(attached_client.move_dir_y)
		if(NORTH)
			attached_client.North()
		if(SOUTH)
			attached_client.South()

/keybind/shift
	name = "Run"

/keybind/shift/KeyDown()
	if(!..())
		return

	attached_client.mob.step_size *= 2
	ResetMovement()

/keybind/shift/KeyUp()
	if(!..())
		return

	attached_client.mob.step_size = initial(attached_client.mob.step_size)
	ResetMovement()

/keybind/shift/proc/ResetMovement()
	attached_client.MoveStop()
	switch(attached_client.move_dir_y)
		if(NORTH)
			attached_client.North()
		if(SOUTH)
			attached_client.South()
		else
			switch(attached_client.move_dir_x)
				if(EAST)
					attached_client.East()
				if(WEST)
					attached_client.West()

//var and proc modifications for /client
/client
	var/move_dir = 0		//bitflags for movement keys being held down
	var/move_dir_x = 0
	var/move_dir_y = 0
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
			if("Run")
				keybinds["SHIFT"] = K
	..()

//client directional movement proc overrides
//	checks if a perpendicular movement key is being held down
//	if one is, call the diagonal movement proc instead
/client/North()
	switch(move_dir_x)
		if(EAST)
			walk(mob, NORTHEAST, , mob.step_size * 0.8)
		if(WEST)
			walk(mob, NORTHWEST, , mob.step_size * 0.8)
		else
			walk(mob, NORTH, , 0)

/client/South()
	switch(move_dir_x)
		if(EAST)
			walk(mob, SOUTHEAST, , mob.step_size * 0.8)
		if(WEST)
			walk(mob, SOUTHWEST, , mob.step_size * 0.8)
		else
			walk(mob, SOUTH, , 0)

/client/East()
	switch(move_dir_y)
		if(NORTH)
			walk(mob, NORTHEAST, , mob.step_size * 0.8)
		if(SOUTH)
			walk(mob, SOUTHEAST, , mob.step_size * 0.8)
		else
			walk(mob, EAST, , 0)

/client/West()
	switch(move_dir_y)
		if(NORTH)
			walk(mob, NORTHWEST, , mob.step_size * 0.8)
		if(SOUTH)
			walk(mob, SOUTHWEST, , mob.step_size * 0.8)
		else
			walk(mob, WEST, , 0)

/client/proc/MoveStop()
	walk(mob, 0)

//KeyDown and KeyUp verbs:
//	called when a key is pressed, which then calls the keybind event associated with that keycode
/client/verb/KeyDown(var/KeyID as text)
	set name = ".keydown"
	set instant = 1

	dout("KeyDown: [KeyID]")

	if(bind)
		BindKey(KeyID)
		return

	var/keybind/K = keybinds[KeyID]
	if(K)
		K.KeyDown()

/client/verb/KeyUp(var/KeyID as text)
	set name = ".keyup"
	set instant = 1

	dout("KeyUp: [KeyID]")

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
