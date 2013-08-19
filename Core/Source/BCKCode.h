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
extern NSString * const BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption;
extern NSString * const BCKCodeDrawingFillEmptyQuietZonesOption;
extern NSString * const BCKCodeDrawingDebugOption;

/**
 Caption Zones
 */
typedef NS_ENUM(NSUInteger, BCKCodeDrawingCaption)
{
	/**
	 The quiet zone left of the left start marker
	 */
	BCKCodeDrawingCaptionLeftQuietZone,
	
	/**
	 The digit zone between left start marker and middle marker
	 */
	BCKCodeDrawingCaptionLeftNumberZone,
	
	/**
	 The digit zone between middle marker and right end marker
	 */
	BCKCodeDrawingCaptionRightNumberZone,
	
	/**
	 The quiet zone right of the right end marker
	 */
	BCKCodeDrawingCaptionRightQuietZone,
	
	/**
	 The text zone between left and right outer markers
	 */
	BCKCodeDrawingCaptionTextZone
};

/**
 This is the base class for all variants of codes:
 
 - BCKEAN8Code: EAN-8
 - BCKEAN13Code: EAN-13 (13-digit EAN or 12-digit UPC-A)
 - BCKUPCECode: UPC-E (shortened UPC)
 - BCKCode39Code: Code 39

 For rendering codes several options can be combined in an options dictionary:
 
 - BCKCodeDrawingBarScaleOption: Multiplier for the bar width (default 1)
 - BCKCodeDrawingPrintCaptionOption: Whether the code caption should be printed (default NO)
 - BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption: How many percent of the caption height are covered by elongated marker bars (default 1.0)
 - BCKCodeDrawingFillEmptyQuietZonesOption: Whether quiet zones should be filled with angle brackes (default NO)
 - BCKCodeDrawingDebugOption: Whether the caption areas should be tinted for debugging (default NO)
*/
@interface BCKCode : NSObject
{
	NSString *_content;
}

/**
 @name Creating Bar Codes
 */

/**
 Root initializer for sub-classes of the BCKCode class cluster. You should not call this on BCKCode directly, but always on concrete subclasses based on which kind of code you want to generate.
 @param content The number string for the code
 */
- (instancetype)initWithContent:(NSString *)content;

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
 @param options The rendering options
 @returns The size required to fit the receiver's rendered representation
 */
- (CGSize)sizeWithRenderOptions:(NSDictionary *)options;

/**
 @name Methods for Subclassing
 */

/**
 The individual code characters that the bar code is consisting of. When subclassing BCKCode this generates an array of BCKCodeCharacter instances which make up the bit string representation of the bar code
 */
@property (nonatomic, readonly) NSArray *codeCharacters;

/**
 The width of the horizontal quiet zone (in bar units) on left and right sides of the bar code.
 */
- (NSUInteger)horizontalQuietZoneWidth;

/**
 The text to display in the given caption zone, or `nil`. Defaults to `nil`. Subclasses can return the check digit or other text. 
 @param captionZone The BCKCodeDrawingCaption zone that specifies the text zone
 @return The caption text to display in this zone, or `nil` for no text
 */
- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone;

/**
 Whether the code allows for marker bars to reach into the bottom caption region. If yes, then the percentage of overlap can be specified with the BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption.
 */
@property (nonatomic, readonly) BOOL markerBarsCanOverlapBottomCaption;

/**
 @name Getting Information about Bar Codes
 */

/**
 The number string for the receiver
 */
@property (nonatomic, readonly) NSString *content;

@end
