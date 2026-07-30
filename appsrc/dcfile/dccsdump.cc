static const char *CopyrightIdentifier(void) { return "@(#)dccidump.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attrmxls.h"
#include "mesgtext.h"
#include "dcopt.h"
#include "elmconst.h"
#include "attrval.h"

static inline void
indent(TextOutputStream &log,unsigned depth,bool showtabs,bool showgt) {
	unsigned d=depth;
	if (showtabs) while (d--) log << "\t";
	d=depth;
	if (showgt) while (d--) log << ">";
}

static void
writeTagNameToLog(Tag tag,ElementDictionary *dict,TextOutputStream &log) {
	const char *desc = NULL;
	if (dict) {
		desc = dict->getDescription(tag);
	}
	if (desc && strlen(desc) > 0 && strcmp(desc,"?") != 0) {
		log << desc;
	}
}

static void
writeTagNameToLog(Attribute *a,ElementDictionary *dict,TextOutputStream &log) {
	writeTagNameToLog(a->getTag(),dict,log);
}

static void
logStringValueOfAttribute(Attribute *a,TextOutputStream &log) {
	if (a) {
		char *v = AttributeValue(a);
		if (v) {
			log << v;
			delete[] v;
		}
	}
}

static void
processCodeSequenceItem(AttributeList *list,TextOutputStream &log) {
	log << "(";
	{
		Attribute *a = (*list)[TagFromName(CodeValue)];
		if (!a) {	// (000633)
			a = (*list)[TagFromName(LongCodeValue)];
			if (!a) {
				a = (*list)[TagFromName(URNCodeValue)];
			}
		}
		logStringValueOfAttribute(a,log);
	}
	log << ",";
	logStringValueOfAttribute((*list)[TagFromName(CodingSchemeDesignator)],log);
	log << "," << "\"" ;
	logStringValueOfAttribute((*list)[TagFromName(CodeMeaning)],log);
	log << "\")";
}

static bool
processCodeSequences(AttributeList *list,TextOutputStream &log,bool verbose,bool veryverbose,unsigned depth,const char *identifierstring)   {
	bool success=true;
	
	int attributeCount = 0;
	AttributeListIterator listi(*list);
	while (!listi) {
		Attribute *a=listi();
		Assert(a);
		char *attributeidentifierstring = NULL;
		if (identifierstring) {
			ostrstream attributeidentifierstream;
			attributeidentifierstream << identifierstring << "." << (attributeCount+1) << ends;
			attributeidentifierstring = attributeidentifierstream.str();
		}
		if (strcmp(a->getVR(),"SQ") == 0) {
			AttributeList **al;
			int n;
			if ((n=a->getLists(&al)) > 0) {
				bool thisAttributeIsCodeSequence = false;
				if (n>0 && (*al[0])[TagFromName(CodingSchemeDesignator)] && a->getTag() != TagFromName(CodingSchemeIdentificationSequence)) {
					thisAttributeIsCodeSequence = true;
					indent(log,depth,true,false/*showgt*/);
					if (attributeidentifierstring) {
						log << attributeidentifierstring << ": ";
					}
					writeTagNameToLog(a,list->getDictionary(),log);
					log << " = ";
				}
				
				int i;
				for (i=0; i<n; ++i) {
					char *childidentifierstring = NULL;
					if (attributeidentifierstring) {
						ostrstream childidentifierstream;
						childidentifierstream << attributeidentifierstring << "[" << (i+1) << "]" << ends;	// distinguish items in brackets from attribute path separated by periods
						childidentifierstring = childidentifierstream.str();
					}
					
					if (thisAttributeIsCodeSequence) {
						if (i > 0) log << ", ";
						processCodeSequenceItem(al[i],log);
					}
					
					success&=processCodeSequences(al[i],log,verbose,veryverbose,depth+1,childidentifierstring);
					if (childidentifierstring) {
						delete [] childidentifierstring;
					}
				}
				if (thisAttributeIsCodeSequence) log << endl;
				
				delete [] al;
			}
		}
		if (attributeidentifierstring) {
			delete [] attributeidentifierstring;
		}
		++listi;
		++attributeCount;
	}
	return success;
}

static bool
parseCodeSequences(ManagedAttributeList &list,TextOutputStream &log,bool verbose,bool veryverbose,bool showidentifier)
{
	bool result = processCodeSequences(&list,log,verbose,veryverbose,0,showidentifier ? "1" : NULL);
	return result;
}

int
main(int argc, char *argv[])
{
	GetNamedOptions 	options(argc,argv);
	DicomInputOptions 	dicom_input_options(options);

	bool veryverbose=options.get("veryverbose") || options.get("vv");
	bool verbose=options.get("verbose") || options.get("v") || veryverbose;
	bool showfilename=options.get("filename");
	bool showidentifier=options.get("identifier");

	dicom_input_options.done();
	options.done();

	DicomInputOpenerFromOptions input_opener(
		options,dicom_input_options.filename,cin);

	cerr << dicom_input_options.errors();
	cerr << options.errors();
	cerr << input_opener.errors();

	if (!dicom_input_options.good()
	 || !options.good()
	 || !input_opener.good()
	 || !options) {
		cerr 	<< MMsgDC(Usage) << ": " << options.command()
			<< dicom_input_options.usage()
			<< " [-v|-verbose|-vv|-veryverbose]"
			<< " [-filename]"
			<< " [-identifier]"
			<< " [" << MMsgDC(InputFile) << "]"
			<< " <" << MMsgDC(InputFile)
			<< endl;
		exit(1);
	}

	DicomInputStream din(*(istream *)input_opener,
		dicom_input_options.transfersyntaxuid,
		dicom_input_options.usemetaheader);

	ManagedAttributeList list;

	bool success=true;
	TextOutputStream log(cerr);
	
	if (showfilename) {
		const char *filenameused = input_opener.getFilename();
		cerr << "Filename: \"" << (filenameused && strlen(filenameused) > 0 ? filenameused : "-") << "\"" << endl;
	}

	if (veryverbose) log << "******** While reading ... ********" << endl; 
	list.read(din,false/*newformat*/,&log,veryverbose,0xffffffff,true,dicom_input_options.uselengthtoend,dicom_input_options.ignoreoutofordertags,dicom_input_options.useUSVRForLUTDataIfNotExplicit);

	const char *errors=list.errors();
	if (errors) log << errors << flush;
	if (!list.good()) {
		log << EMsgDC(DatasetReadFailed) << endl;
		success=false;
	}

	//if (veryverbose) log << "******** As read ... ********" << endl; 
	//log << list;
	//list.write(log,veryverbose);

	{
		bool parseSuccess = parseCodeSequences(list,log,verbose,veryverbose,showidentifier);		// parse regardless of read success or failure
		success=success&&parseSuccess;
	}

	return success ? 0 : 1;
}




