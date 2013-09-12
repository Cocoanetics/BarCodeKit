//
//  BCKCode.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

// string constants
extern NSString * const BCKCodeDrawingBarScaleOption;
extern NSString * const BCKCodeDrawingPrintCaptionOption;
extern NSString * const BCKCodeDrawingCaptionFontNameOption;
extern NSString * const BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption;
extern NSString * const BCKCodeDrawingFillEmptyQuietZonesOption;
extern NSString * const BCKCodeDrawingDebugOption;

/**
 Caption Zones
 */
typedef NS_ENUM(NSUInteger, BCKCodeDrawingCaption)
{
	/**
	 The quiet zone to the left of the left start marker
	 */
	BCKCodeDrawingCaptionLeftQuietZone,
	
	/**
	 The digit zone between the left start marker and the middle marker
	 */
	BCKCodeDrawingCaptionLeftNumberZone,
	
	/**
	 The digit zone between the middle marker and the right end marker
	 */
	BCKCodeDrawingCaptionRightNumberZone,
	
	/**
	 The quiet zone to the right of the right end marker
	 */
	BCKCodeDrawingCaptionRightQuietZone,
	
	/**
	 The text zone between the left and right start and end markers
	 */
	BCKCodeDrawingCaptionTextZone
};

/**
 This is the base class for all barcode variants:
 
 - BCKEAN8Code - EAN-8 - International Standard ISO/IEC 15420
 - BCKEAN13Code - EAN-13 (13-digit EAN or 12-digit UPC-A) - International Standard ISO/IEC 15420
 - BCKUPCECode - UPC-E (shortened UPC) - International Standard ISO/IEC 15420
 - BCKCode39Code - Code 39 - international standard ISO/IEC 16388
 - BCKCode93Code - Code 93 - no international standard
 - BCKInterleaved2of5Code - Interleaved 2 of 5 - International standard ISO/IEC 16390
 - BCKCode128Code - Code 128 - International Standard ISO/IEC 15417
 - BCKCode11Code - Code 11 - no international standard
 - BCKMSICode - MSI or Modified Plessey barcode - no international standard
 
 For rendering codes several options can be combined in an options dictionary:
 
 - **BCKCodeDrawingBarScaleOption** - Multiplier for the bar width (default 1)
 - **BCKCodeDrawingPrintCaptionOption** - Whether the code caption should be printed (default NO)
 - **BCKCodeDrawingCaptionFontNameOption** - Which font face name to use for the caption (default is 'OCRB' for EAN/UPC and 'Helvetica' otherwise)
 - **BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption** - How many percent of the caption height are covered by elongated marker bars (default 1.0)
 - **BCKCodeDrawingFillEmptyQuietZonesOption** - Whether quiet zones should be filled with angle brackes (default NO)
 - **BCKCodeDrawingDebugOption** - Whether the caption areas should be tinted for debugging (default NO)
 */
@interface BCKCode : NSObject
{
	NSString *_content;
	NSArray *_codeCharacters;       // This ivar is declared as a public ivar to enable subclass access
}

/**
 @name Creating Bar Codes
 */

/**
 Root initializer for sub-classes of the BCKCode class cluster. You should not call this on BCKCode directly, but always on concrete subclasses based on the kind of code you want to generate.
 @warning This method is deprecated, use - [BCKCode initWithContent:error:] instead
 @param content The number string for the code
 @return The requested BCKCode subclass. Returns nil if the content provided cannot be encoded using the requested BCKCode subclass
 */
- (instancetype)initWithContent:(NSString *)content __attribute__((deprecated("use - [BCKCode initWithContent:error:] instead")));

/**
 Root initializer for sub-classes of the BCKCode class cluster. You should not call this on BCKCode directly, but always on concrete subclasses based on the kind of code you want to generate.
 @param content The number string for the code
 @param error Double indirection to an NSError instance
 @return The requested BCKCode subclass. Returns nil if the provided content cannot be encoded by the requested BCKCode subclass, the error object will contain error details
 */
- (instancetype)initWithContent:(NSString *)content error:(NSError**)error;

/**
 @name Drawing Bar Codes
 */

/**
 Renders the receiver into a graphics context
 @param context The graphics context to render into
 @param options The rendering options
 */
- (void)renderInContext:(CGContextRef)context options:(NSDictionary *)options;


/**
 Calculates the graphics context size for the passed render options.
 @param options An NSDictionary containig the requested rendering options
 @returns The size required to fit the receiver's rendered representation
 */
- (CGSize)sizeWithRenderOptions:(NSDictionary *)options;

/**
 @name Methods for Subclassing
 */

/**
 The individual code characters the bar code comprises. When subclassing BCKCode this generates an array of BCKCodeCharacter instances which make up the bit string representation of the bar code
 */
@property (nonatomic, readonly) NSArray *codeCharacters;

/**
 The width of the horizontal quiet zone (in bar units) on the left and right sides of the bar code.
 */
- (NSUInteger)horizontalQuietZoneWidth;

/**
 The text to display in the given caption zone, or `nil` for no caption text. Defaults to `nil`. Subclasses can return the check digit or other text.
 @param captionZone The BCKCodeDrawingCaption zone that specifies the text zone
 @return The caption text to display in this zone, or `nil` for no caption text
 */
- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone;

/**
 Whether the code allows for marker bars to reach into the bottom caption region. If yes, then the percentage of overlap can be specified with the BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption.
 */
@property (nonatomic, readonly) BOOL markerBarsCanOverlapBottomCaption;

/**
 Whether the code allows for quite zones to be filled with angle brackets. If yes, then quite zones are filled if the BCKCodeDrawingFillEmptyQuietZonesOption is specified
 */
@property (nonatomic, readonly) BOOL allowsFillingOfEmptyQuietZones;

/**
 The font name to use for captions if no other is specified via BCKCodeDrawingCaptionFontNameOption
 */
@property (nonatomic, readonly) NSString *defaultCaptionFontName;


/**
 @name Getting Information about Bar Codes
 */

/**
 The string for the receiver that will be converted into the barcode
 */
@property (nonatomic, readonly) NSString *content;

/**
 The barcode class' international standard
 */
+ (NSString *)barcodeStandard;

/**
 Human readable description of the barcode class (e.g. EAN-8)
 */
+ (NSString *)barcodeDescription;

/**
 Checks whether contents is encodable by the BCKCode class.
 @param content The barcode to be encoded by the BCKCode subclass
 @return YES if the contents is encodable, in which case the error object is set to nil. NO if it is not, the error object contains error information
 */
+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error;

@end
