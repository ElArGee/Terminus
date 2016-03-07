/turf
	icon = 'floor.dmi'

/turf/floor
	icon_state = "tile"

/turf/floor/New()
	icon_state = prob(90) ? "tile" : "tile2"
	if(icon_state == "tile2")
		density = TRUE
	..()
