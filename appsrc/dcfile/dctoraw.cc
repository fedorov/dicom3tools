static const char *CopyrightIdentifier(void) { return "@(#)dctoraw.cc Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved."; }
#include "attrmxls.h"
#include "attrothr.h"
#include "attrval.h"
#include "mesgtext.h"
#include "ioopt.h"
#include "dcopt.h"
#include "elmconst.h"
#include "transynd.h"

int
main(int argc, char *argv[])
{
	GetNamedOptions 	options(argc,argv);
	DicomInputOptions 	dicom_input_options(options);
	OutputOptions		output_options(options);

	bool verbose=options.get("verbose") || options.get("v");
	bool quiet=options.get("quiet") || options.get("silent");

	dicom_input_options.done();
	output_options.done();
	options.done();

	DicomInputOpenerFromOptions input_opener(
		options,dicom_input_options.filename,cin);
	OutputOpenerFromOptions output_opener(
		options,output_options.filename,cout);

	cerr << dicom_input_options.errors();
	cerr << output_options.errors();
	cerr << options.errors();
	cerr << input_opener.errors();
	cerr << output_opener.errors();

	if (!dicom_input_options.good()
	 || !output_options.good()
	 || !options.good()
	 || !input_opener.good()
	 || !output_opener.good()
	 || !options) {
		cerr 	<< MMsgDC(Usage) << ": " << options.command()
			<< dicom_input_options.usage()
			<< output_options.usage()
			<< " [-v|-verbose]"
			<< " [-quiet|-silent]"
			<< " [" << MMsgDC(InputFile)
				<< "[" << MMsgDC(OutputFile) << "]]"
			<< " <" << MMsgDC(InputFile)
			<< " >" << MMsgDC(OutputFile)
			<< endl;
		exit(1);
	}

	DicomInputStream din(*(istream *)input_opener,
		dicom_input_options.transfersyntaxuid,
		dicom_input_options.usemetaheader);
	ostream out(output_opener);

	ManagedAttributeList list;

	bool success=true;
	TextOutputStream log(cerr);
	if (verbose) log << "******** While reading ... ********" << endl; 
	list.read(din,false/*newformat*/,&log,verbose,0xffffffff,true,dicom_input_options.uselengthtoend,dicom_input_options.ignoreoutofordertags,dicom_input_options.useUSVRForLUTDataIfNotExplicit);

	const char *errors=list.errors();
	if (errors) log << errors << flush;
	if (!list.good()) {
		log << EMsgDC(DatasetReadFailed) << endl;
		success=false;
	}
	
	// Most of this is copied from dctopnm ... should refactor :(

	Uint16 vRows = 0;
	Attribute *aRows = list[TagFromName(Rows)];
	if (!aRows)
		log << WMsgDC(MissingAttribute)
		    << " - \"Rows\""
		    << endl;
	else
		vRows=AttributeValue(aRows);

	Uint16 vColumns = 0;
	Attribute *aColumns = list[TagFromName(Columns)];
	if (!aColumns)
		log << WMsgDC(MissingAttribute)
		    << " - \"Columns\""
		    << endl;
	else
		vColumns=AttributeValue(aColumns);

	Uint16 vNumberOfFrames = 0;
	Attribute *aNumberOfFrames = list[TagFromName(NumberOfFrames)];
	if (aNumberOfFrames)	// optional
		vNumberOfFrames=AttributeValue(aNumberOfFrames);

	if (vNumberOfFrames == 0) {
		vNumberOfFrames = 1;	// need to treat it as 1 if missing for later byteCount calculation
	}

	char *vPhotometricInterpretation = 0;
	Attribute *aPhotometricInterpretation = list[TagFromName(PhotometricInterpretation)];
	if (!aPhotometricInterpretation)
		log << WMsgDC(MissingAttribute)
		    << " - \"PhotometricInterpretation\""
		    << endl;
	else
		vPhotometricInterpretation=AttributeValue(aPhotometricInterpretation);

	Uint16 vSamplesPerPixel = 0;
	Attribute *aSamplesPerPixel = list[TagFromName(SamplesPerPixel)];
	if (!aSamplesPerPixel)
		log << WMsgDC(MissingAttribute)
		    << " - \"SamplesPerPixel\""
		    << endl;
	else
		vSamplesPerPixel=AttributeValue(aSamplesPerPixel);

	Uint16 vBitsAllocated = 0;
	Attribute *aBitsAllocated = list[TagFromName(BitsAllocated)];
	if (!aBitsAllocated)
		log << WMsgDC(MissingAttribute)
		    << " - \"BitsAllocated\""
		    << endl;
	else
		vBitsAllocated=AttributeValue(aBitsAllocated);

	Uint16 vBitsStored = 0;
	Attribute *aBitsStored = list[TagFromName(BitsStored)];
	if (!aBitsStored)
		log << WMsgDC(MissingAttribute)
		    << " - \"BitsStored\""
		    << endl;
	else
		vBitsStored=AttributeValue(aBitsStored);

	Uint16 vHighBit = 0;
	Attribute *aHighBit = list[TagFromName(HighBit)];
	if (!aHighBit)
		log << WMsgDC(MissingAttribute)
		    << " - \"HighBit\""
		    << endl;
	else
		vHighBit=AttributeValue(aHighBit);

	Uint16 vPixelRepresentation = 0xffff;
	Attribute *aPixelRepresentation = list[TagFromName(PixelRepresentation)];
	if (!aPixelRepresentation)
		log << WMsgDC(MissingAttribute)
		    << " - \"PixelRepresentation\""
		    << endl;
	else
		vPixelRepresentation=AttributeValue(aPixelRepresentation);

	Uint16 vPlanarConfiguration = 0xffff;
	Attribute *aPlanarConfiguration = list[TagFromName(PlanarConfiguration)];
	if (vSamplesPerPixel > 1 && !aPlanarConfiguration)
		log << WMsgDC(MissingAttribute)
		    << " - \"PlanarConfiguration\""
		    << endl;
	else
		vPlanarConfiguration=AttributeValue(aPlanarConfiguration);

	Uint32 byteCount = ((Uint32)vRows) * vColumns * vNumberOfFrames * vSamplesPerPixel * ((vBitsAllocated-1)/8 + 1);

	TransferSyntax *ts=din.getTransferSyntaxToReadDataSet();
	Assert(ts);

	Attribute *apixeldata=list[TagFromName(PixelData)];
	if (!apixeldata) {
		log << EMsgDC(MissingAttribute) << " - \"PixelData\"" << endl;
		success=false;
	}
	else if (!apixeldata->isOtherData()) {
		log << EMsgDC(PixelDataIncorrectVR) << endl;
		success=false;
	}
	else {
		if (!quiet) {
			// this is now redundant with the explicit retrieval of values above, but keep this redundant dump in case anyone used these in scripts ...
			log << "******** Parameters ... ********" << endl; 
			ElementDictionary *dict=list.getDictionary();
			Attribute *a;
			a=list[TagFromName(NumberOfFrames)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(Rows)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(Columns)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(SamplesPerPixel)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(PixelRepresentation)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(PhotometricInterpretation)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(PlanarConfiguration)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(BitsAllocated)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(BitsStored)];
			if (a) { a->write(log,dict); log << endl; }
			a=list[TagFromName(HighBit)];
			if (a) { a->write(log,dict); log << endl; }

			log << "\tRows = " << dec << vRows << endl;
			log << "\tColumns = " << dec << vColumns << endl;
			log << "\tNumberOfFrames = " << dec << vNumberOfFrames << endl;
			log << "\tPhotometricInterpretation = "
				<< (vPhotometricInterpretation ? vPhotometricInterpretation : "")
				<< endl;
			log << "\tSamplesPerPixel = " << dec << vSamplesPerPixel << endl;
			log << "\tBitsAllocated = " << dec << vBitsAllocated << endl;
			log << "\tBitsStored = " << dec << vBitsStored << endl;
			log << "\tHighBit = " << dec << vHighBit << endl;
			log << "\tPixelRepresentation = " << dec << vPixelRepresentation << endl;
			log << "\tPlanarConfiguration = " << hex << vPlanarConfiguration << dec << endl;
			log << "\tRows*Columns*vNumberOfFrames*SamplesPerPixel*((vBitsAllocated-1)/8+1) = "
				<< hex << byteCount
				<< dec << " (" << byteCount << " dec)" << endl;

			dumpTransferSyntaxEncapsulation(ts);
			dumpTransferSyntaxByteOrder(ts);
		}

		OtherUnspecifiedLargeAttributeBase *
			opixeldata = apixeldata->castToOtherData();
		Assert(opixeldata);

		if (ts->isEncapsulated()) {
			if (!quiet) log << "Writing encapsulated Transfer Syntax ..." << endl;
			opixeldata->writeRaw(out);
		}
		else if (byteCount == 0) {
			// do it the "old" way, if for some reason we could not find a suitable value for something that contributes to the desired count; should never happen
			if (!quiet) log << "Writing VL " << dec << opixeldata->getVL() << " (dec) bytes ..." << endl;
			opixeldata->writeRaw(out);
		}
		else {
			if (!quiet) log << "Writing unpadded " << dec << byteCount << " (dec) bytes ..." << endl;
			opixeldata->writeRaw(out,0/*byte offset*/,byteCount);
		}
		
		if (!out.good()) {
			log << EMsgDC(Writefailed) << endl;
			success=false;
		}
	}

	return success ? 0 : 1;
}

	
