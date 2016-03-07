#define		SHIFT_KEY		1

/client
	var/move_dir = 0
	var/shift_key = 0

/client/Move()


/client/verb/KeyDown(var/KeyID as num)
	dout("KeyDown = [KeyID]")
	switch(KeyID)
		if(16)	//Shift
			ShiftDown()
			return
		if(87)	//W		NORTH
			move_dir |= NORTH
		if(65)	//A		EAST
			move_dir |= EAST
		if(82)	//R		SOUTH
			move_dir |= SOUTH
		if(83)	//S		WEST
			move_dir |= WEST

	dout("move_dir = [move_dir]")
/*
	switch(move_dir)
		if(NORTH)
			mob.North()
		if(SOUTH)
			mob.South()
		if(EAST)
			mob.East()
		if(WEST)
			mob.West()
*/
	mob.Move(Dir = move_dir)

/client/verb/KeyUp(var/KeyID as num)
	switch(KeyID)
		if(16)	//Shift
			ShiftUp()
			return
		if(87)	//W		NORTH
			move_dir &= ~NORTH
		if(65)	//A		EAST
			move_dir &= ~EAST
		if(82)	//R		SOUTH
			move_dir &= ~SOUTH
		if(83)	//S		WEST
			move_dir &= ~WEST

/client/proc/ShiftDown()
	if(mob)
		mob.run = TRUE

/client/proc/ShiftUp()
	if(mob)
		mob.run = FALSE

/mob
	var/run = 0
