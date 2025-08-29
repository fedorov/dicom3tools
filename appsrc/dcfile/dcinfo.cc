static const char *CopyrightIdentifier(void) { return "@(#)dcinfo.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attrmxls.h"
#include "elmconst.h"
#include "mesgtext.h"
#include "dcopt.h"

int
main(int argc, char *argv[])
{
	GetNamedOptions 	options(argc,argv);
	DicomInputOptions 	dicom_input_options(options);

	bool verbose=options.get("verbose") || options.get("v");
	bool showfilename=options.get("filename");

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
			<< " [-v|-verbose]"
			<< " [-filename]"
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
		log << "Filename: \"" << (filenameused && strlen(filenameused) > 0 ? filenameused : "-") << "\"" << endl;
	}

	if (verbose) log << "******** While reading ... ********" << endl;
//clock_t start = clock();
	list.read(din,false/*newformat*/,&log,verbose,0xffffffff,true,dicom_input_options.uselengthtoend,dicom_input_options.ignoreoutofordertags,dicom_input_options.useUSVRForLUTDataIfNotExplicit);
//log << "Elapsed time " << (double((clock() - start))/CLOCKS_PER_SEC*1000.0) << " ms" <<endl;
	
	const char *errors=list.errors();
	if (errors) log << errors << flush;
	if (!list.good()) {
		log << EMsgDC(DatasetReadFailed) << endl;
		success=false;
	}

	if (verbose) log << "******** As read ... ********" << endl;

	// derived from dciodvfy.checkOffsetTables()

	//Attribute *aTransferSyntax=list[TagFromName(TransferSyntaxUID)];
	//char *vTransferSyntax = NULL;
	//if (aTransferSyntax) {
	//	(void)aTransferSyntax->getValue(0,vTransferSyntax);
	//}
	TransferSyntax *dts=din.getTransferSyntaxToReadDataSet();
	if (dts) {
		log << "Transfer Syntax to read data set is " << (dts->getEncapsulated() ? "" : "un") << "encapsulated" << endl;
	}

	Attribute *aSharedFunctionalGroupsSequence=list[TagFromName(SharedFunctionalGroupsSequence)];
	Attribute *aPerFrameFunctionalGroupsSequence=list[TagFromName(PerFrameFunctionalGroupsSequence)];
	if (aSharedFunctionalGroupsSequence || aPerFrameFunctionalGroupsSequence) {
		log << "Is an enhanced family instance" << endl;
	}
	else {
		log << "Is a non-enhanced family instance" << endl;
	}

	if (aPerFrameFunctionalGroupsSequence) {
		log << "Is an enhanced family instance with PerFrameFunctionalGroupsSequence" << endl;
	}
	else if (aSharedFunctionalGroupsSequence) {
		log << "Is an enhanced family instance without PerFrameFunctionalGroupsSequence" << endl;
	}

	Attribute *aPixelData=list[TagFromName(PixelData)];

	if (!aPixelData) {
		log << "Is not an image (no PixelData in top level dataset)" << endl;
	}
	else {
		Attribute *aNumberOfFrames=list[TagFromName(NumberOfFrames)];
		Uint32 vNumberOfFrames = 1;
		if (aNumberOfFrames) {
			(void)aNumberOfFrames->getValue(0,vNumberOfFrames);
		}
		if (vNumberOfFrames > 1) {
			log << "Is an image with multiple frames" << endl;
		}
		else {
			log << "Is an image with a single frame" << endl;
		}
		
		if (!aPixelData->isEncapsulated()) {
			log << "Is an image with unencapsulated PixelData" << endl;
		}
		else {
			log << "Is an image with encapsulated PixelData" << endl;
		
			Uint32 offsetOfFirstFragmentItemTag = 0;	// need this for checking both the Basic Offset Table and the Extended Offset Table
			
			BinaryInputStream in(*(istream *)input_opener,LittleEndian);
			
			long offset = aPixelData->getByteOffset();
			//cerr << "checkOffsetTables(): aPixelData offsetToStartOfPixelDataAttribute = " << offset << endl;
			// can assume Explicit VR LE representation since all encapsulated TS are that
			offset += 12;	// length of PixelData group, element, VR and padding, VL
			offset += 4;	// length of Item Tag group, element
				
			in.seekg(offset);	// need to seek from beginning, since may not have been rewound from previous reads
			Uint32 lengthOfBasicOffsetTableInBytes = in.read32();
			//cerr << "checkOffsetTables(): lengthOfBasicOffsetTableInBytes = " << lengthOfBasicOffsetTableInBytes << endl;
			offset+=4;
			
			// check Basic Offset Table, if present ... (000531)
			if (lengthOfBasicOffsetTableInBytes) {
				log << "Basic Offset Table is present" << endl;
			}
			else {
				log << "Basic Offset Table is absent" << endl;
			}

			// check Extended Offset Table, if present ...
			//cerr << "checkOffsetTables(): looking for ExtendedOffsetTable attribute" << endl;
			Uint32 nExtendedOffsetTable = 0;
			const Uint64 *vExtendedOffsetTable = NULL;
			Attribute *aExtendedOffsetTable = list[TagFromName(ExtendedOffsetTable)];
			if (aExtendedOffsetTable) {
				if (lengthOfBasicOffsetTableInBytes > 0) {
					log << "Extended Offset Table is present" << endl;
				}
				else {
					log << "Extended Offset Table is present but empty" << endl;
				}
			}
			else {
					log << "Extended Offset Table is absent" << endl;
			}
		}
	}
}
