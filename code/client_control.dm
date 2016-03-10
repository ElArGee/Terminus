//var and proc modifications for /client
/client
	//bitflags for movement keys being held down
	var/move_dir_x = 0
	var/move_dir_y = 0
	var/run = FALSE
	//other binding vars
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

//MovePlayer
//	handles which direction to move the player in
/client/proc/MovePlayer()
	var/move_speed = mob.step_size

	//if we are moving on a diagonal, reduce step size
	if(move_dir_x && move_dir_y && run)
		move_speed *= 0.8

	//if we are running, increase step size
	if(run)
		move_speed *= 2

	dout("move_dir: [move_dir_x | move_dir_y]")
	dout("move_speed: [move_speed]")

	//stop current movement first (to prevent weird bugs)
	walk(mob, 0)
	//then start moving in the desired direction
	walk(mob, move_dir_x | move_dir_y, , move_speed)

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
