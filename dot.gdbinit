set history save
set history size 2500
set history filename ~/.gdb_history

set print pretty on
set print asm-demangle on
set print object on
set print static-members off

define dis
	disassemble $rip-16,+48
end
document dis
	Disassembles code around the current instruction pointer ($rip)
end
