/atom/Click(mob/mob,location,control,params)
	return

/atom/movable
	appearance_flags = LONG_GLIDE //make diagonal and horizontal moves take the same amount of time
	var/move_delay = 0 //how long between self movements this movable should be forced to wait.
	var/tmp/next_move = 0 //the world.time value of the next allowed self movement
	var/tmp/last_move = 0 //the world.time value of the last self movement
	var/tmp/move_dir = 0 //the direction of the current/last movement
//    var/tmp/move_flags = 0 //the type of the current/last movement

/atom/movable/Move(atom/NewLoc, Dir=0)
	var/time = world.time
	if(next_move > time)
		return 0
	if(!NewLoc) //if the new location is null, treat this as a failed slide and an edge bump.
		move_dir = Dir
	//        move_flags = MOVE_SLIDE
	else if(isturf(loc) && isturf(NewLoc)) //if this is a movement between two turfs
		var/dx = NewLoc.x - x //get the distance delta
		var/dy = NewLoc.y - y
		if(z == NewLoc.z && abs(dx) <= 1 && abs(dy) <= 1) //if only moving one tile on the same layer, mark the current move as a slide and figure out the move_dir
			move_dir = 0
	//            move_flags = MOVE_SLIDE
			if(dx > 0)
				move_dir |= EAST
			else if(dx < 0)
				move_dir |= WEST
			if(dy > 0)
				move_dir |= NORTH
			else if(dy < 0)
				move_dir |= SOUTH
	    else //jumping between z levels or more than one tile is a jump with no move_dir
			move_dir = 0
	//            move_flags = MOVE_JUMP
	else //moving into or out of a null location or another atom other than a turf is a teleport with no move_dir
		move_dir = 0
	//        move_flags = MOVE_TELEPORT
	glide_size = TILE_WIDTH / max(move_delay, TICK_LAG) * TICK_LAG //set the glide size
	. = ..() //perform the movement
	last_move = time //set the last movement time
	if(.)
		next_move = time + move_delay
