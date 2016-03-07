/proc/dout(var/s)
	world << "<span class='debug'>DEBUG: [s]</span>"

/client/verb/usr_dout(var/s as text)
	set name = "dout"
	dout(s)

/client/verb/call_proc()
	set name = "call_proc"
	var/p = input("proc to call?", "call_proc()")
	var/s = input("string to pass?", "call_proc()")
	call(p)(s)
