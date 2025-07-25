#  condn.awk Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved.
# create C++ headers from conditions template 

# can set these values on the command line:
#
#	role	  - either "declare" or "define"

NR==1	{
	print "// Automatically generated from template - EDITS WILL BE LOST"
	print ""
	print "// Generated by condn.awk with options " role " " outname
	print ""

	# Never and Always need to be callable as functions ...

	if (role == "declare" || role == "define") {
		print "#ifndef __Header_" outname "__"
		print "#define __Header_" outname "__"
		print ""
	}
	else {
		print "Error - role " role " invalid" >"/dev/tty"
		exit 1
	}

	if (role == "declare") {
		print "bool Condition_Never(AttributeList *list,AttributeList *parentlist=0,AttributeList *rootlist=0);"
		print "bool Condition_Always(AttributeList *list,AttributeList *parentlist=0,AttributeList *rootlist=0);"
		print ""
	}
	else if (role == "define") {
		print "bool Condition_Never(AttributeList *list,AttributeList *parentlist,AttributeList *rootlist)  { (void)list; (void)parentlist; return false; }"
		print "bool Condition_Always(AttributeList *list,AttributeList *parentlist,AttributeList *rootlist) { (void)list; (void)parentlist; return true; }"
		print ""
	}

	condition=""
	}

/^[ 	]*Condition=/ {

	condition=""
	if (match($0,"Condition=\"[^\"]*\""))
		condition=substr($0,RSTART+length("Condition=\""),
			RLENGTH-length("Condition=\"")-1);

	if (role == "declare") {
		print "bool	Condition_" condition "(AttributeList *list,AttributeList *parentlist=0,AttributeList *rootlist=0);"
	}
	else if (role == "define") {
		nestinglevel=0
		print "bool"
		print "Condition_" condition "(AttributeList *list,AttributeList *parentlist,AttributeList *rootlist)"
		print "{"
		print "\tint condition" nestinglevel " =0;"
		print "\t(void)list;"
		print "\t(void)parentlist;"
		print "\t(void)rootlist;"
		print ""
	}

	}

/^[ 	]*ConditionEnd/ {

	if (role == "define") {
		print ""
		print "\treturn (condition" nestinglevel " & 1) != 0;"
		print "}"
		print ""
	}
	condition=""

	}

/^[ 	]*Element/ {

	element=""
	if (match($0,"Element=\"[^\"]*\""))
		element=substr($0,RSTART+length("Element=\""),
			RLENGTH-length("Element=\"")-1);

	operator=""
	if (match($0,"Operator=\"[^\"]*\""))
		operator=substr($0,RSTART+length("Operator=\""),
			RLENGTH-length("Operator=\"")-1);

	if (operator == "or" || operator == "Or" || operator == "|" || operator == "||") {
		operator="|"
	}
	else if (operator == "xor" || operator == "Xor" || operator == "^") {
		operator="^"
	}
	else if (operator == "and" || operator == "And" || operator == "&" || operator == "&&") {
		operator="&"
	}
	else if (length(operator) == 0) {
		operator="|"
	}
	else {
		print "Error - Operator \"" operator "\" invalid, assuming or, at line" FNR >"/dev/tty"
	}

	modifier=""
	if (match($0,"Modifier=\"[^\"]*\""))
		modifier=substr($0,RSTART+length("Modifier=\""),
			RLENGTH-length("Modifier=\"")-1);

	if (modifier == "not" || modifier == "Not" || modifier == "~" || modifier == "!") {
		modifier="~"
	}
	else if (length(modifier) == 0) {
		modifier=""
	}
	else {
		print "Error - Modifier \"" modifier "\" invalid, assuming none, at line" FNR >"/dev/tty"
	}

	selector=""
	if (match($0,"ValueSelector=\"[^\"]*\""))
		selector=substr($0,RSTART+length("ValueSelector=\""),
			RLENGTH-length("ValueSelector=\"")-1);

	if (length(selector) == 0) {
		selector="-1"		# default is wildcard not 1st value !
	}
	else if (selector == "*") {
		selector="-1"		# wildcard
	}

	valuepresent=0
	if (match($0,"ValuePresent=\"[^\"]*\"")) {
		valuepresent=1
	}
	
	elementpresent=0
	elementpresentmask=""
	if (match($0,"ElementPresent=\"[^\"]*\"")) {
		elementpresent=1;
		elementpresentmask=substr($0,RSTART+length("ElementPresent=\""),
			RLENGTH-length("ElementPresent=\"")-1);
	}

	elementpresentabove=0
	if (match($0,"ElementPresentAbove=\"[^\"]*\"")) {
		elementpresentabove=1;
	}

	elementpresentinroot=0
	if (match($0,"ElementPresentInRoot=\"[^\"]*\"")) {
		elementpresentinroot=1;
	}

	elementpresentwithin=0
	elementpresentwithinsequence=""
	if (match($0,"ElementPresentWithin=\"[^\"]*\"")) {
		elementpresentwithin=1;
		elementpresentwithinsequence=substr($0,RSTART+length("ElementPresentWithin=\""),
			RLENGTH-length("ElementPresentWithin=\"")-1);
	}

	elementpresentinpath=0
	elementpresentinpathfromroot=""
	if (match($0,"ElementPresentInPathFromRoot=\"[^\"]*\"")) {
		elementpresentinpath=1;
		elementpresentinpathfromroot=substr($0,RSTART+length("ElementPresentInPathFromRoot=\""),
			RLENGTH-length("ElementPresentInPathFromRoot=\"")-1);
	}

	sequencepresentinpathhasitems=0
	sequencepresentinpathfromroothasitems=""
	if (match($0,"SequencePresentInPathFromRootHasItems=\"[^\"]*\"")) {
		sequencepresentinpathhasitems=1;
		sequencepresentinpathfromroothasitems=substr($0,RSTART+length("SequencePresentInPathFromRootHasItems=\""),
			RLENGTH-length("SequencePresentInPathFromRootHasItems=\"")-1);
	}

	elementpresentinpathfirstitem=0
	elementpresentinpathfromrootfirstitem=""
	if (match($0,"ElementPresentInPathFromRootFirstItem=\"[^\"]*\"")) {
		elementpresentinpathfirstitem=1;
		elementpresentinpathfromrootfirstitem=substr($0,RSTART+length("ElementPresentInPathFromRootFirstItem=\""),
			RLENGTH-length("ElementPresentInPathFromRootFirstItem=\"")-1);
	}

	sequencepresentinpathfirstitemhasitems=0
	sequencepresentinpathfromrootfirstitemhasitems=""
	if (match($0,"SequencePresentInPathFromRootFirstItemHasItems=\"[^\"]*\"")) {
		sequencepresentinpathfirstitemhasitems=1;
		sequencepresentinpathfromrootfirstitemhasitems=substr($0,RSTART+length("SequencePresentInPathFromRootFirstItemHasItems=\""),
			RLENGTH-length("SequencePresentInPathFromRootFirstItemHasItems=\"")-1);
	}

	grouppresent=0;
	grouppresentmask=""
	if (match($0,"GroupPresent=\"[^\"]*\"")) {
		grouppresent=1;
		grouppresentmask=substr($0,RSTART+length("GroupPresent=\""),
			RLENGTH-length("GroupPresent=\"")-1);
	}

	stringconstant=""
	stringconstantused=0
	if (match($0,"StringConstant=\"[^\"]*\"")) {
		stringconstantused=1
		stringconstant=substr($0,RSTART+length("StringConstant=\""),
			RLENGTH-length("StringConstant=\"")-1);
	}
	
	stringconstantfromrootattribute=""
	stringconstantfromrootattributeused=0
	if (match($0,"StringConstantFromRootAttribute=\"[^\"]*\"")) {
		stringconstantfromrootattributeused=1
		stringconstantfromrootattribute=substr($0,RSTART+length("StringConstantFromRootAttribute=\""),
			RLENGTH-length("StringConstantFromRootAttribute=\"")-1);
	}

	stringvalue=""
	stringvalueused=0
	if (match($0,"StringValue=\"[^\"]*\"")) {
		stringvalueused=1
		stringvalue=substr($0,RSTART+length("StringValue=\""),
			RLENGTH-length("StringValue=\"")-1);
	}
	
	stringvalueabove=""
	stringvalueaboveused=0
	if (match($0,"StringValueAbove=\"[^\"]*\"")) {
		stringvalueaboveused=1
		stringvalueabove=substr($0,RSTART+length("StringValueAbove=\""),
			RLENGTH-length("StringValueAbove=\"")-1);
	}
	
	stringvaluefromrootattribute=""
	stringvaluefromrootattributeused=0
	if (match($0,"StringValueFromRootAttribute=\"[^\"]*\"")) {
		stringvaluefromrootattributeused=1
		stringvaluefromrootattribute=substr($0,RSTART+length("StringValueFromRootAttribute=\""),
			RLENGTH-length("StringValueFromRootAttribute=\"")-1);
	}

	binaryvalue=""
	binaryvaluematchoperator=""
	if (match($0,"BinaryValue=\"[^\"]*\"")) {
		binaryvaluewithoperator=substr($0,RSTART+length("BinaryValue=\""),
			RLENGTH-length("BinaryValue=\"")-1);
		# e.g., "== 1" ; "< 367"
		spacestart=index(binaryvaluewithoperator," "); # 3 ; 2
		binaryvalue=substr(binaryvaluewithoperator,spacestart+1,length(binaryvaluewithoperator)-spacestart);	# 4, 4-3=1 ; 3, 5-2=3
		matchoperatorstring=substr(binaryvaluewithoperator,1,spacestart-1);	# 1,2 ; 1,1
		if (matchoperatorstring == "==") binaryvaluematchoperator = "Equals"
		else if (matchoperatorstring == "!=") binaryvaluematchoperator = "NotEquals"
		else if (matchoperatorstring == "<") binaryvaluematchoperator = "LessThan"
		else if (matchoperatorstring == "<=") binaryvaluematchoperator = "LessThanOrEquals"
		else if (matchoperatorstring == ">") binaryvaluematchoperator = "GreaterThan"
		else if (matchoperatorstring == ">=") binaryvaluematchoperator = "GreaterThanOrEquals"
		else print "Error - Binary Match Operator \"" matchoperatorstring "\" invalid at line" FNR >"/dev/tty"
	}

	binaryvaluefromrootattribute=""
	binaryvaluematchoperatorfromrootattribute=""
	if (match($0,"BinaryValueFromRootAttribute=\"[^\"]*\"")) {
		binaryvaluewithoperator=substr($0,RSTART+length("BinaryValueFromRootAttribute=\""),
			RLENGTH-length("BinaryValueFromRootAttribute=\"")-1);
		# e.g., "== 1" ; "< 367"
		spacestart=index(binaryvaluewithoperator," "); # 3 ; 2
		binaryvaluefromrootattribute=substr(binaryvaluewithoperator,spacestart+1,length(binaryvaluewithoperator)-spacestart);	# 4, 4-3=1 ; 3, 5-2=3
		matchoperatorstring=substr(binaryvaluewithoperator,1,spacestart-1);	# 1,2 ; 1,1
		if (matchoperatorstring == "==") binaryvaluematchoperatorfromrootattribute = "Equals"
		else if (matchoperatorstring == "!=") binaryvaluematchoperatorfromrootattribute = "NotEquals"
		else if (matchoperatorstring == "<") binaryvaluematchoperatorfromrootattribute = "LessThan"
		else if (matchoperatorstring == "<=") binaryvaluematchoperatorfromrootattribute = "LessThanOrEquals"
		else if (matchoperatorstring == ">") binaryvaluematchoperatorfromrootattribute = "GreaterThan"
		else if (matchoperatorstring == ">=") binaryvaluematchoperatorfromrootattribute = "GreaterThanOrEquals"
		else print "Error - Binary Match Operator \"" matchoperatorstring "\" invalid at line" FNR >"/dev/tty"
	}

	tagvalue=""
	if (match($0,"TagValue=\"[^\"]*\""))
		tagvalue=substr($0,RSTART+length("TagValue=\""),
			RLENGTH-length("TagValue=\"")-1);

	tagvaluefromrootattribute=""
	if (match($0,"TagValueFromRootAttribute=\"[^\"]*\""))
		tagvaluefromrootattribute=substr($0,RSTART+length("TagValueFromRootAttribute=\""),
			RLENGTH-length("TagValueFromRootAttribute=\"")-1);

	sequencehasitems=0
	if (match($0,"SequenceHasItems=\"[^\"]*\"")) {
		sequencehasitems=1;
	}

	sequencehasoneitem=0
	if (match($0,"SequenceHasOneItem=\"[^\"]*\"")) {
		sequencehasoneitem=1;
	}

	sequencehastwoitems=0
	if (match($0,"SequenceHasTwoItems=\"[^\"]*\"")) {
		sequencehastwoitems=1;
	}

	sequencehasmultipleitems=0
	if (match($0,"SequenceHasMultipleItems=\"[^\"]*\"")) {
		sequencehasmultipleitems=1;
	}

	if (role == "define") {
		if (valuepresent) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(ValuePresent(list,TagFromName(" element ")," selector ")?1:0);"
		}
		if (elementpresent) {
			if (length(elementpresentmask) > 0) {
				print "\tcondition" nestinglevel " " operator "=" modifier "(ElementPresentMasked(list,TagFromName(" element ")," elementpresentmask ")?1:0);"
			}
			else {
				print "\tcondition" nestinglevel " " operator "=" modifier "(ElementPresent(list,TagFromName(" element "))?1:0);"
			}
		}
		if (elementpresentabove) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(ElementPresentAbove(parentlist,TagFromName(" element "))?1:0);"
		}
		if (elementpresentwithin) {
			if (length(elementpresentwithinsequence) > 0) {
				if (stringvalueused) {
					print "\tcondition" nestinglevel " " operator "=" modifier "(ElementStringValueMatchWithin(list,TagFromName(" element "),TagFromName(" elementpresentwithinsequence ")," selector ",\"" stringvalue "\")?1:0);"
					stringvalueused=0	# i.e., don't use it again below !
				}
				else if (stringconstantused) {
					print "\tcondition" nestinglevel " " operator "=" modifier "(ElementStringValueMatchWithin(list,TagFromName(" element "),TagFromName(" elementpresentwithinsequence ")," selector ",\"" stringconstant "\")?1:0);"
					stringconstantused=0	# i.e., don't use it again below !
				}
				else {
					print "\tcondition" nestinglevel " " operator "=" modifier "(ElementPresentWithin(list,TagFromName(" element "),TagFromName(" elementpresentwithinsequence "))?1:0);"
				}
			}
			else {
				print "Error - Must specify sequence attribute argument for ElementPresentWithin " FNR >"/dev/tty"
			}
		}
		if (elementpresentinpath) {
			if (length(elementpresentinpathfromroot) > 0) {
				print "\tcondition" nestinglevel " " operator "=" modifier "(ElementPresentInPathFromRoot(rootlist,TagFromName(" element "),TagFromName(" elementpresentinpathfromroot "))?1:0);"
			}
			else {
				print "Error - Must specify sequence attribute argument for ElementPresentInPathFromRoot " FNR >"/dev/tty"
			}
		}
		if (sequencepresentinpathhasitems) {
			if (length(sequencepresentinpathfromroothasitems) > 0) {
				print "\tcondition" nestinglevel " " operator "=" modifier "(SequencePresentInPathFromRootHasItems(rootlist,TagFromName(" element "),TagFromName(" sequencepresentinpathfromroothasitems "))?1:0);"
			}
			else {
				print "Error - Must specify sequence attribute argument for SequencePresentInPathFromRootHasItems " FNR >"/dev/tty"
			}
		}
		if (elementpresentinpathfirstitem) {
			if (length(elementpresentinpathfromrootfirstitem) > 0) {
				print "\tcondition" nestinglevel " " operator "=" modifier "(ElementPresentInPathFromRootFirstItem(rootlist,TagFromName(" element "),TagFromName(" elementpresentinpathfromrootfirstitem "))?1:0);"
			}
			else {
				print "Error - Must specify sequence attribute argument for ElementPresentInPathFromRoot " FNR >"/dev/tty"
			}
		}
		if (sequencepresentinpathfirstitemhasitems) {
			if (length(sequencepresentinpathfromrootfirstitemhasitems) > 0) {
				print "\tcondition" nestinglevel " " operator "=" modifier "(SequencePresentInPathFromRootFirstItemHasItems(rootlist,TagFromName(" element "),TagFromName(" sequencepresentinpathfromrootfirstitemhasitems "))?1:0);"
			}
			else {
				print "Error - Must specify sequence attribute argument for SequencePresentInPathFromRootFirstItemHasItems " FNR >"/dev/tty"
			}
		}
		if (elementpresentinroot) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(ElementPresent(rootlist,TagFromName(" element "))?1:0);"
		}
		if (grouppresent) {
			if (length(grouppresentmask) > 0) {
				print "\tcondition" nestinglevel " " operator "=" modifier "(GroupPresentMasked(list,TagFromName(" element ")," grouppresentmask ")?1:0);"
			}
			else {
				print "\tcondition" nestinglevel " " operator "=" modifier "GroupPresent(list,TagFromName(" element "))?1:0;"
			}
		}
		if (stringconstantused) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(StringValueMatch(list,TagFromName(" element ")," selector "," stringconstant ")?1:0);"
		}
		if (stringconstantfromrootattributeused) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(StringValueMatch(rootlist,TagFromName(" element ")," selector "," stringconstantfromrootattribute ")?1:0);"
		}
		if (stringvalueused) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(StringValueMatch(list,TagFromName(" element ")," selector ",\"" stringvalue "\")?1:0);"
		}
		if (stringvalueaboveused) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(StringValueMatch(parentlist,TagFromName(" element ")," selector ",\"" stringvalueabove "\")?1:0);"
		}
		if (stringvaluefromrootattributeused) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(StringValueMatch(rootlist,TagFromName(" element ")," selector ",\"" stringvaluefromrootattribute "\")?1:0);"
		}
		if (length(binaryvalue) > 0) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(BinaryValueMatch(list,TagFromName(" element ")," selector "," binaryvaluematchoperator "," binaryvalue ")?1:0);"
		}
		if (length(binaryvaluefromrootattribute) > 0) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(BinaryValueMatch(rootlist,TagFromName(" element ")," selector "," binaryvaluematchoperatorfromrootattribute "," binaryvaluefromrootattribute ")?1:0);"
		}
		if (length(tagvalue) > 0) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(TagValueMatch(list,TagFromName(" element ")," selector ",Tag(" tagvalue "))?1:0);"
		}
		if (length(tagvaluefromrootattribute) > 0) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(TagValueMatch(rootlist,TagFromName(" element ")," selector ",Tag(" tagvaluefromrootattribute "))?1:0);"
		}
		if (sequencehasitems) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(SequenceHasItems(list,TagFromName(" element "))?1:0);"
		}
		if (sequencehasoneitem) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(SequenceHasOneItem(list,TagFromName(" element "))?1:0);"
		}
		if (sequencehastwoitems) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(SequenceHasTwoItems(list,TagFromName(" element "))?1:0);"
		}
		if (sequencehasmultipleitems) {
			print "\tcondition" nestinglevel " " operator "=" modifier "(SequenceHasMultipleItems(list,TagFromName(" element "))?1:0);"
		}
	}

	}

/^[ 	]*[(]/ {
	if (role == "define") {
		++nestinglevel
		print "{"
		print "\tint condition" nestinglevel " =0;"
	}
	
	}
	
/^[ 	]*[)]/ {
	operator=""
	if (match($0,"Operator=\"[^\"]*\""))
		operator=substr($0,RSTART+length("Operator=\""),
			RLENGTH-length("Operator=\"")-1);

	if (operator == "or" || operator == "Or" || operator == "|" || operator == "||") {
		operator="|"
	}
	else if (operator == "xor" || operator == "Xor" || operator == "^") {
		operator="^"
	}
	else if (operator == "and" || operator == "And" || operator == "&" || operator == "&&") {
		operator="&"
	}
	else if (length(operator) == 0) {
		operator="|"
	}
	else {
		print "Error - Operator \"" operator "\" invalid, assuming or, at line" FNR >"/dev/tty"
	}

	modifier=""
	if (match($0,"Modifier=\"[^\"]*\""))
		modifier=substr($0,RSTART+length("Modifier=\""),
			RLENGTH-length("Modifier=\"")-1);

	if (modifier == "not" || modifier == "Not" || modifier == "~" || modifier == "!") {
		modifier="~"
	}
	else if (length(modifier) == 0) {
		modifier=""
	}
	else {
		print "Error - Modifier \"" modifier "\" invalid, assuming none, at line" FNR >"/dev/tty"
	}

	if (role == "define") {
		print "\tcondition" (nestinglevel-1) " " operator "=" modifier "condition" nestinglevel ";"
		print "}"
		--nestinglevel
	}
	
	}
	
END {
	if (role == "declare" || role == "define") {
		print ""
		print "#endif /* __Header_" outname "__ */"
	}
}

