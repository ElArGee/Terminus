/obj/screen/black
	screen_loc = "SOUTH,WEST to NORTH,EAST"
	var/client/client

/obj/screen/black/New(loc = null, var/client/Client)
	..()
	client = Client
	var/image/I = new(icon = 'icons/ui.dmi', icon_state = "overlay")
	I.color = "#000000"
	I.alpha = 170
	overlays += I

/obj/screen/black/proc/Show()
	client.screen += src

/obj/screen/black/proc/Hide()
	client.screen -= src
