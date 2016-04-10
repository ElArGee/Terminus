/**********************************\
 Intent menu buttons
\**********************************/
/hudobj/intent
	var/intent_icon = "help"
	var/intent_color = "FFFFFF"

/hudobj/intent/New()
	..()
	var/image/I = new(icon = 'icons/ui.dmi', icon_state = intent_icon)
	I.color = intent_color
	overlays += I

/hudobj/intent/Click()
	var/hudobj/menu/M = parent
	if(istype(M))
		M.UpdateSelected(src)
		M.state = 0
		M.ToggleMenu()

/hudobj/intent/help
	intent_icon = "help"
	intent_color = "#00FF00"

/hudobj/intent/grab
	intent_icon = "grab"
	intent_color = "#FFFF00"

/hudobj/intent/disarm
	intent_icon = "disarm"
	intent_color = "#00CCFF"

/hudobj/intent/harm
	intent_icon = "harm"
	intent_color = "#FF4400"
