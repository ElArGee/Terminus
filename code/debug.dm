/proc/dout(var/s)
#if DOUT
	world << "<span class='debug'>DEBUG: [s]</span>"
#else
	return
#endif

/client/verb/usr_dout(var/s as text)
	set name = "dout"
	dout(s)
