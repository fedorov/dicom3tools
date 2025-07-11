#  binval.awk Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved.
# create C++ headers from binary values template 

# can set these values on the command line:
#
#	role	  - either "declare" or "define"

# 970706 Change \'\\0\' to ends for HPUX awk which outputs the \

NR==1	{
	print "// Automatically generated from template - EDITS WILL BE LOST"
	print ""
	print "// Generated by binval.awk with options " role " " outname
	print ""

	if (role == "declare" || role == "define") {
		print "#ifndef __Header_" outname "__"
		print "#define __Header_" outname "__"
		print ""
	}
	else {
		print "Error - role " role " invalid" >"/dev/tty"
		exit 1
	}

	mode=""
	}

/^[ 	]*BinaryBitMap/ {
	name=""
	if (match($0,"BinaryBitMap=\"[^\"]*\""))
		name=substr($0,RSTART+length("BinaryBitMap=\""),
			RLENGTH-length("BinaryBitMap=\"")-1);
	mode="bitmap"

	if (role == "declare") {
		print "char *\tBinaryBitMapDescription_" name "(Uint16 value);"
	}
	else if (role == "define") {
		print "char *"
		print "BinaryBitMapDescription_" name "(Uint16 value)"
		print "{"
		print "\tUint16 validmask=0;"
		print "\tostrstream ost;"
	}

	}

/^[ 	]*BinaryValues/ {
	name=""
	if (match($0,"BinaryValues=\"[^\"]*\""))
		name=substr($0,RSTART+length("BinaryValues=\""),
			RLENGTH-length("BinaryValues=\"")-1);
	mode="values"

	if (role == "declare") {
		print "char *\tBinaryValueDescription_" name "(Uint16 value);"
	}
	else if (role == "define") {
		print "char *"
		print "BinaryValueDescription_" name "(Uint16 value)"
		print "{"
		print "\tostrstream ost;"
		print "\tswitch (value) {"
	}

	}

/^[ 	]*[0-9]/ {

	if (mode == "values") {
		valueline=$0
		if (!match(valueline,"[0-9][x0-9a-fA-F]*")) {
			print "Line " FNR \
				": error in value line - no code <" \
				valueline ">" >"/dev/tty"
			next
		}
		code=substr(valueline,RSTART,RLENGTH)
		valueline=substr(valueline,RSTART+RLENGTH)
		if (match(valueline,"[ 	]*=[ 	]*")) {
			meaning=substr(valueline,RSTART+RLENGTH)
			if (match(meaning,"[ 	]*,*[ 	]*$")) {
				meaning=substr(meaning,0,RSTART-1)
			}
		}
		else {
			meaning=code
		}

		if (role == "define") {
			print "\t\tcase " code ":"
			print "\t\t\tost << \"" meaning "\" << ends;"
			print "\t\t\treturn ost.str();"
		}
	}
	else if (mode == "bitmap") {
		valueline=$0
		if (!match(valueline,"[0-9][x0-9a-f]*")) {
			print "Line " FNR \
				": error in value line - no bit number <" \
				valueline ">" >"/dev/tty"
			next
		}
		bitnumber=substr(valueline,RSTART,RLENGTH)
		valueline=substr(valueline,RSTART+RLENGTH)

		if (match(valueline,"[ 	]*=[ 	]*")) {
			meaning=substr(valueline,RSTART+RLENGTH)
			if (match(meaning,"[ 	]*[:]")) {
				meaning=substr(meaning,0,RSTART-1)
			}
		}
		else {
			meaning=bitnumber
		}

		if (match(valueline,"[ 	]*:[ 	]*")) {
			falsevalue=substr(valueline,RSTART+RLENGTH)
			if (match(falsevalue,"[ 	]*[,]")) {
				falsevalue=substr(falsevalue,0,RSTART-1)
			}
			else {
				print "Line " FNR \
					": error in bitmap - bad false value <" \
					valueline ">" >"/dev/tty"
				falsevalue=""
			}
		}
		else {
			print "Line " FNR \
				": error in bitmap - no false value <" \
				valueline ">" >"/dev/tty"
			falsevalue=""
		}

		if (match(valueline,"[ 	]*,[ 	]*")) {
			truevalue=substr(valueline,RSTART+RLENGTH)
			if (match(truevalue,"[ 	]*(;|$)")) {
				truevalue=substr(truevalue,0,RSTART-1)
			}
			else {
				print "Line " FNR \
					": error in bitmap - bad true value <" \
					valueline ">" >"/dev/tty"
				truevalue=""
			}
		}
		else {
			print "Line " FNR \
				": error in bitmap - no true value <" \
				valueline ">" >"/dev/tty"
			truevalue=""
		}

		if (role == "define") {
			print "\t{"
			print "\t\tvalidmask|=(1<<" bitnumber ");"
			print "\t\tUint16 bitvalue=value&(1<<" bitnumber ");"
			print "\t\tost << \"" meaning "(\" << (bitvalue ? \"" truevalue "\" : \"" falsevalue "\") << \") \" << ends;"
			print "\t}"
		}
	}
	else {
		print "Line " FNR ": error - no group name" >"/dev/tty"
	}

	}

/^[ 	]*}/ {
	if (role == "define" && mode == "bitmap") {
		print "\tif (value&~validmask)"
		print "\t\treturn 0;"
		print "\telse"
		print "\t\treturn ost.str();"
		print "}"
		print ""
	}
	else if (role == "define" && mode == "values") {
		print "\t\tdefault:"
		print "\t\t\treturn 0;"
		print "\t}"
		print "}"
		print ""
	}

	mode=""
	}

END {
	if (role == "declare" || role == "define") {
		print ""
		print "#endif /* __Header_" outname "__ */"
	}
}

