// all-in header for Bar Code Kit

#import <Availability.h>

// code implementations
#import "BCKCodabarCode.h"
#import "BCKGTINCode.h"
#import "BCKEAN8Code.h"
#import "BCKEAN13Code.h"
#import "BCKUPCECode.h"
#import "BCKCode39Code.h"
#import "BCKCode93Code.h"
#import "BCKFacingIdentificationMarkCode.h"
#import "BCKInterleaved2of5Code.h"
#import "BCKCode128Code.h"
#import "BCKMSICode.h"
#import "BCKPharmacodeOneTrack.h"
#import "BCKPOSTNETCode.h"
#import "BCKStandard2of5Code.h"
#import "BCKISBNCode.h"
#import "BCKISSNCode.h"
#import "BCKISMNCode.h"

// code characters for EAN/UPC
#import "BCKEANCodeCharacter.h"
#import "BCKEANDigitCodeCharacter.h"
#import "BCKUPCCodeCharacter.h"
#import "BCKGTINSupplementCodeCharacter.h"
#import "BCKGTINSupplementDataCodeCharacter.h"

// code character for Codabar
#import "BCKCodabarCodeCharacter.h"
#import "BCKCodabarContentCodeCharacter.h"

// code character for Code11
#import "BCKCode11CodeCharacter.h"
#import "BCKCode11ContentCodeCharacter.h"

// code character for Code39
#import "BCKCode39CodeCharacter.h"
#import "BCKCode39ContentCodeCharacter.h"

// code character for Code2of5
#import "BCKInterleaved2of5CodeCharacter.h"
#import "BCKInterleaved2of5DigitPairCodeCharacter.h"

// code character for Code93
#import "BCKCode93CodeCharacter.h"
#import "BCKCode93ContentCodeCharacter.h"

// code character for Facing Identification Mark
#import "BCKFacingIdentificationMarkCodeCharacter.h"

// code character for Interleaved 2 of 5
#import "BCKInterleaved2of5CodeCharacter.h"
#import "BCKInterleaved2of5DigitPairCodeCharacter.h"

// code character for Code128
#import "BCKCode128ContentCodeCharacter.h"
#import "BCKCode128CodeCharacter.h"

// code character for MSI
#import "BCKMSICodeCharacter.h"
#import "BCKMSIContentCodeCharacter.h"

// code character for Pharmacode
#import "BCKPharmaOneTrackContentCodeCharacter.h"

// code character for POSTNET
#import "BCKPOSTNETCodeCharacter.h"
#import "BCKPOSTNETContentCodeCharacter.h"

// code character for Standard 2 of 5
#import "BCKStandard2of5CodeCharacter.h"
#import "BCKStandard2of5ContentCodeCharacter.h"

// error reporting
#import "NSError+BCKCode.h"

// barcode rendering
#import "BCKCodeFunctions.h"

#if TARGET_OS_IPHONE
	#import "UIImage+BarCodeKit.h"
#else
	#import "NSImage+BarCodeKit.h"
#endif
