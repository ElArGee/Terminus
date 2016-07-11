/mob
	//glide_size = 2
	icon = 'icons/man.dmi'
	icon_state = "walk"
	var/base_move_delay = 2
	var/is_running = FALSE
	var/injured = FALSE

/mob/New()
	..()
	UpdateMoveDelay()

/mob/proc/Run(var/run)
	is_running = run
	UpdateMoveDelay()

/mob/proc/UpdateMoveDelay()
	if(injured)
		move_delay = base_move_delay * 2	//reduce movement speed if injured
	else if(is_running)
		move_delay = base_move_delay / 2	//increase movement speed if running
	else
		move_delay = base_move_delay

	move_delay = max(0, round(move_delay, (move_delay < 2) ? 1 : 2))	//rounded to a multiple of 2 for smooth gliding

	if(move_delay < 2)
		icon_state = "run"
	else
		icon_state = "walk"
