/* pqconv.h Copyright (c) 1993-2024, David A. Clunie DBA PixelMed Publishing. All rights reserved. */
#ifdef CRAP
// Automatically generated from template - EDITS WILL BE LOST
//
// Generated by tpltohdr.awk with options or defaults ...
//
// 	 role=dicom
// 	 prefix=PQ_
// 	 dicomfunctionname=ToDicom_Template
// 	 dumpcommonfunctionname=DumpCommon
// 	 dumpselectedimagefunctionname=DumpSelectedImage
// 	 headeroffsetprefix=PQ_Offset
// 	 headeroffsetsuffix=ptr
// 	 headerclassprefix=PQ_HeaderClass
// 	 headerdicomclassprefix=PQ_Header_BothClass
// 	 headerdumpclassprefix=PQ_Header_BothClass
// 	 headerinstanceprefix=PQ_HeaderInstance
// 	 methodnameprefix=PQ_Method
// 	 methodconstructorargsprefix=PQ_MethodConstructorArgs
// 	 headerclassparameters=

void 
PQ_Header_BothClass::ToDicom_Template(AttributeList *list)
{
	(*list)+=new UnsignedShortAttribute(
		TagFromName(PixelPaddingValue),0);

	(*list)+=new CodeStringAttribute(
		TagFromName(PhotometricInterpretation),"MONOCHROME2");

	(*list)+=new DecimalStringAttribute(
		TagFromName(RescaleIntercept),"0");

	(*list)+=new PersonNameAttribute(
		TagFromName(ReferringPhysicianName));

}

#endif

void 
PQ_Header_BothClass::ToDicom_Template(AttributeList *list)
{
	// constant stuff

	(*list)+=new UnsignedShortAttribute(TagFromName(BitsAllocated),16);
	(*list)+=new UnsignedShortAttribute(TagFromName(BitsStored),16);
	(*list)+=new UnsignedShortAttribute(TagFromName(HighBit),15);
	(*list)+=new UnsignedShortAttribute(TagFromName(PixelPaddingValue),0);
	(*list)+=new UnsignedShortAttribute(TagFromName(SamplesPerPixel),1);
	(*list)+=new UnsignedShortAttribute(TagFromName(PixelRepresentation),1);
	(*list)+=new CodeStringAttribute(TagFromName(PhotometricInterpretation),"MONOCHROME2");

	(*list)+=new DecimalStringAttribute(TagFromName(RescaleIntercept),"0");
	(*list)+=new DecimalStringAttribute(TagFromName(RescaleSlope),"1");
	(*list)+=new LongStringAttribute(TagFromName(RescaleType),"HU");

	{
		Int32 recon_matrix;
		bool found=getIntegerAttribute("RCNMTRX",recon_matrix);
		Assert(found);
		(*list)+=new UnsignedShortAttribute(TagFromName(Rows),Uint16(recon_matrix));
		(*list)+=new UnsignedShortAttribute(TagFromName(Columns),Uint16(recon_matrix));
	}
}
