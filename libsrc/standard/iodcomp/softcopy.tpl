CompositeIOD="GrayscaleSoftcopyPresentationState"	Condition="GrayscaleSoftcopyPresentationStateInstance"
	InformationEntity="File"
		Module="FileMetaInformation"				Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"							Usage="M"
		Module="ClinicalTrialSubject"				Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"						Usage="M"
		Module="PatientStudy"						Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"					Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"						Usage="M"
		Module="ClinicalTrialSeries"				Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="PresentationSeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Presentation"
		Module="PresentationStateIdentification"	Usage="M"
		Module="PresentationStateRelationship"		Usage="M"
		Module="PresentationStateShutter"			Usage="M"
		Module="PresentationStateMask"				Usage="M"
		Module="Mask"								Usage="C"	Condition="NeedModuleMask"
		Module="DisplayShutter"						Usage="C"	Condition="NeedModuleDisplayShutter"
		Module="BitmapDisplayShutter"				Usage="C"	Condition="NeedModuleBitmapDisplayShutter"
		Module="OverlayPlane"						Usage="C"	Condition="NeedModuleOverlayPlane"
		Module="OverlayActivation"					Usage="C"	Condition="NeedModuleOverlayActivation"
		Module="DisplayedArea"						Usage="M"
		Module="GraphicAnnotation"					Usage="C"	Condition="NeedModuleGraphicAnnotation"
		Module="SpatialTransformation"				Usage="C"	Condition="NeedModuleSpatialTransformation"
		Module="GraphicLayer"						Usage="C"	Condition="NeedModuleGraphicLayer"
		Module="GraphicGroup"						Usage="C"	Condition="NeedModuleGraphicGroup"
		Module="ModalityLUT"						Usage="C"	Condition="NeedModuleModalityLUT"
		Module="SoftcopyVOILUT"						Usage="C"	Condition="NeedModuleSoftcopyVOILUT"
		Module="SoftcopyPresentationLUT"			Usage="M"
		Module="Specimen"							Usage="U"	Condition="NeedModuleSpecimen"
		Module="SOPCommon"							Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="ColorSoftcopyPresentationState"	Condition="ColorSoftcopyPresentationStateInstance"
	InformationEntity="File"
		Module="FileMetaInformation"				Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"							Usage="M"
		Module="ClinicalTrialSubject"				Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"						Usage="M"
		Module="PatientStudy"						Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"					Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"						Usage="M"
		Module="ClinicalTrialSeries"				Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="PresentationSeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Presentation"
		Module="PresentationStateIdentification"	Usage="M"
		Module="PresentationStateRelationship"		Usage="M"
		Module="PresentationStateShutter"			Usage="M"
		Module="DisplayShutter"						Usage="C"	Condition="NeedModuleDisplayShutter"
		Module="BitmapDisplayShutter"				Usage="C"	Condition="NeedModuleBitmapDisplayShutter"
		Module="OverlayPlane"						Usage="C"	Condition="NeedModuleOverlayPlane"
		Module="OverlayActivation"					Usage="C"	Condition="NeedModuleOverlayActivation"
		Module="DisplayedArea"						Usage="M"
		Module="GraphicAnnotation"					Usage="C"	Condition="NeedModuleGraphicAnnotation"
		Module="SpatialTransformation"				Usage="C"	Condition="NeedModuleSpatialTransformation"
		Module="GraphicLayer"						Usage="C"	Condition="NeedModuleGraphicLayer"
		Module="GraphicGroup"						Usage="C"	Condition="NeedModuleGraphicGroup"
		Module="ICCProfile"							Usage="M"
		Module="Specimen"							Usage="U"	Condition="NeedModuleSpecimen"
		Module="SOPCommon"							Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="PseudoColorSoftcopyPresentationState"	Condition="PseudoColorSoftcopyPresentationStateInstance"
	InformationEntity="File"
		Module="FileMetaInformation"				Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"							Usage="M"
		Module="ClinicalTrialSubject"				Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"						Usage="M"
		Module="PatientStudy"						Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"					Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"						Usage="M"
		Module="ClinicalTrialSeries"				Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="PresentationSeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Presentation"
		Module="PresentationStateIdentification"	Usage="M"
		Module="PresentationStateRelationship"		Usage="M"
		Module="PresentationStateShutter"			Usage="M"
		Module="PresentationStateMask"				Usage="M"
		Module="Mask"								Usage="C"	Condition="NeedModuleMask"
		Module="DisplayShutter"						Usage="C"	Condition="NeedModuleDisplayShutter"
		Module="BitmapDisplayShutter"				Usage="C"	Condition="NeedModuleBitmapDisplayShutter"
		Module="OverlayPlane"						Usage="C"	Condition="NeedModuleOverlayPlane"
		Module="OverlayActivation"					Usage="C"	Condition="NeedModuleOverlayActivation"
		Module="DisplayedArea"						Usage="M"
		Module="GraphicAnnotation"					Usage="C"	Condition="NeedModuleGraphicAnnotation"
		Module="SpatialTransformation"				Usage="C"	Condition="NeedModuleSpatialTransformation"
		Module="GraphicLayer"						Usage="C"	Condition="NeedModuleGraphicLayer"
		Module="GraphicGroup"						Usage="C"	Condition="NeedModuleGraphicGroup"
		Module="ModalityLUT"						Usage="C"	Condition="NeedModuleModalityLUT"
		Module="SoftcopyVOILUT"						Usage="C"	Condition="NeedModuleSoftcopyVOILUT"
		Module="PaletteColorLookupTable"			Usage="M"
		Module="ICCProfile"							Usage="M"
		Module="Specimen"							Usage="U"	Condition="NeedModuleSpecimen"
		Module="SOPCommon"							Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="BlendingSoftcopyPresentationState"	Condition="BlendingSoftcopyPresentationStateInstance"
	InformationEntity="File"
		Module="FileMetaInformation"				Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"							Usage="M"
		Module="ClinicalTrialSubject"				Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"						Usage="M"
		Module="PatientStudy"						Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"					Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"						Usage="M"
		Module="ClinicalTrialSeries"				Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="PresentationSeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Presentation"
		Module="PresentationStateIdentification"	Usage="M"
		Module="PresentationStateBlending"			Usage="M"
		Module="DisplayedArea"						Usage="M"
		Module="GraphicAnnotation"					Usage="C"	Condition="NeedModuleGraphicAnnotation"
		Module="SpatialTransformation"				Usage="C"	Condition="NeedModuleSpatialTransformation"
		Module="GraphicLayer"						Usage="C"	Condition="NeedModuleGraphicLayer"
		Module="GraphicGroup"						Usage="C"	Condition="NeedModuleGraphicGroup"
		Module="PaletteColorLookupTable"			Usage="M"
		Module="ICCProfile"							Usage="M"
		Module="Specimen"							Usage="U"	Condition="NeedModuleSpecimen"
		Module="SOPCommon"							Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="AdvancedBlendingSoftcopyPresentationState"	Condition="AdvancedBlendingSoftcopyPresentationStateInstance"
	InformationEntity="File"
		Module="FileMetaInformation"				Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"							Usage="M"
		Module="ClinicalTrialSubject"				Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"						Usage="M"
		Module="PatientStudy"						Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"					Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"						Usage="M"
		Module="ClinicalTrialSeries"				Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="PresentationSeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Presentation"
		Module="PresentationStateIdentification"	Usage="M"
		Module="AdvancedBlendingPresentationState"	Usage="M"
		Module="AdvancedBlendingPresentationStateDisplay"	Usage="M"
		Module="DisplayedArea"						Usage="U"	Condition="NeedModuleDisplayedArea"
		Module="GraphicAnnotation"					Usage="C"	Condition="NeedModuleGraphicAnnotation"
		Module="SpatialTransformation"				Usage="C"	Condition="NeedModuleSpatialTransformation"
		Module="GraphicLayer"						Usage="C"	Condition="NeedModuleGraphicLayer"
		Module="GraphicGroup"						Usage="C"	Condition="NeedModuleGraphicGroup"
		Module="ICCProfile"							Usage="M"
		Module="CommonInstanceReference"			Usage="M"
		Module="Specimen"							Usage="U"	Condition="NeedModuleSpecimen"
		Module="SOPCommon"							Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="AdvancedBlendingSoftcopyPresentationStateIDCVOIPaletteOpticalPath"	Condition="AdvancedBlendingSoftcopyPresentationStateInstance"	Profile="IDCVOIPaletteOpticalPath"
	InformationEntity="File"
		Module="FileMetaInformation"				Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"							Usage="M"
		Module="ClinicalTrialSubject"				Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"						Usage="M"
		Module="PatientStudy"						Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"					Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"						Usage="M"
		Module="ClinicalTrialSeries"				Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="PresentationSeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"					Usage="M"
	InformationEntityEnd
	InformationEntity="Presentation"
		Module="PresentationStateIdentification"	Usage="M"
		Module="AdvancedBlendingPresentationStateIDCVOIPaletteOpticalPath"			Usage="M"
		Module="AdvancedBlendingPresentationStateDisplay"	Usage="M"
		Module="DisplayedArea"						Usage="U"	Condition="NeedModuleDisplayedArea"
		Module="GraphicAnnotation"					Usage="C"	Condition="NeedModuleGraphicAnnotation"
		Module="SpatialTransformation"				Usage="C"	Condition="NeedModuleSpatialTransformation"
		Module="GraphicLayer"						Usage="C"	Condition="NeedModuleGraphicLayer"
		Module="GraphicGroup"						Usage="C"	Condition="NeedModuleGraphicGroup"
		Module="ICCProfile"							Usage="M"
		Module="CommonInstanceReference"			Usage="M"
		Module="Specimen"							Usage="U"	Condition="NeedModuleSpecimen"
		Module="SOPCommon"							Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="HangingProtocol"	Condition="HangingProtocolInstance"
	InformationEntity="File"
		Module="FileMetaInformation"		Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="HangingProtocol"
		Module="HangingProtocolDefinition"	Usage="M"
		Module="HangingProtocolEnvironment"	Usage="M"
		Module="HangingProtocolDisplay"		Usage="M"
		Module="SOPCommon"					Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="ColorPalette"	Condition="ColorPaletteInstance"
	InformationEntity="File"
		Module="FileMetaInformation"		Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="ColorPalette"
		Module="ColorPaletteDefinition"		Usage="M"
		Module="PaletteColorLookupTable"	Usage="M"
		Module="ICCProfile"					Usage="M"
		Module="SOPCommon"					Usage="M"
	InformationEntityEnd
CompositeIODEnd

CompositeIOD="BasicStructuredDisplay"	Condition="BasicStructuredDisplayInstance"
	InformationEntity="File"
		Module="FileMetaInformation"				Usage="C"	Condition="NeedModuleFileMetaInformation"
	InformationEntityEnd
	InformationEntity="Patient"
		Module="Patient"							Usage="M"
		Module="ClinicalTrialSubject"				Usage="U"	Condition="NeedModuleClinicalTrialSubject"
	InformationEntityEnd
	InformationEntity="Study"
		Module="GeneralStudy"						Usage="M"
		Module="PatientStudy"						Usage="U"	# no condition ... all attributes type 3
		Module="ClinicalTrialStudy"					Usage="U"	Condition="NeedModuleClinicalTrialStudy"
	InformationEntityEnd
	InformationEntity="Series"
		Module="GeneralSeries"						Usage="M"
		Module="ClinicalTrialSeries"				Usage="U"	Condition="NeedModuleClinicalTrialSeries"
		Module="PresentationSeries"					Usage="M"
	InformationEntityEnd
	InformationEntity="Equipment"
		Module="GeneralEquipment"					Usage="M"
		Module="EnhancedGeneralEquipment"			Usage="U"	Condition="EnhancedGeneralEquipmentIsPresent"
	InformationEntityEnd
	InformationEntity="Presentation"
		Module="StructuredDisplay"					Usage="M"
		Module="StructuredDisplayImageBox"			Usage="M"
		Module="StructuredDisplayAnnotation"		Usage="U"	Condition="NeedModuleStructuredDisplayAnnotation"
		Module="CommonInstanceReference"			Usage="M"
		Module="Specimen"							Usage="U"	Condition="NeedModuleSpecimen"
		Module="SOPCommon"							Usage="M"
	InformationEntityEnd
CompositeIODEnd

