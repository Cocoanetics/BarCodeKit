//
//  BCKCode.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"
#import "BarCodeKit.h"
#import "NSError+BCKCode.h"

#import <CoreText/CoreText.h>

// options
NSString * const BCKCodeDrawingBarScaleOption = @"BCKCodeDrawingBarScale";
NSString * const BCKCodeDrawingPrintCaptionOption = @"BCKCodeDrawingPrintCaption";
NSString * const BCKCodeDrawingCaptionFontNameOption = @"BCKCodeDrawingCaptionFontName";
NSString * const BCKCodeDrawingCaptionFontPointSizeOption = @"BCKCodeDrawingCaptionFontPointSize";
NSString * const BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption = @"BCKCodeDrawingMarkerBarsOverlapCaptionPercent";
NSString * const BCKCodeDrawingFillEmptyQuietZonesOption = @"BCKCodeDrawingFillEmptyQuietZones";
NSString * const BCKCodeDrawingDebugOption = @"BCKCodeDrawingDebug";
NSString * const BCKCodeDrawingShowCheckDigitsOption = @"BCKCodeDrawingShowCheckDigits";
NSString * const BCKCodeDrawingBackgroundColorOption = @"BCKCodeDrawingBackgroundColor";
NSString * const BCKCodeDrawingReduceBleedOption = @"BCKCodeDrawingReduceBleed";
NSString * const BCKCodeDrawingSizeWidthOption = @"BCKCodeDrawingSizeWidthOption";
NSString * const BCKCodeDrawingSizeHeightOption = @"BCKCodeDrawingSizeHeightOption";
NSString * const BCKCodeDrawingBarcodeHasQuiteZones = @"BCKCodeDrawingBarcodeHasQuiteZones";

#define ENCODE_ERROR_MESSAGE @"BCKCode is an abstract class that cannot encode anything"

@implementation BCKCode

#pragma mark Helper Methods

// The NSError object is ignored in BCKCode's initWithContent method. BCKCode subclasses are required to initialise it in case of errors, for example if canEncodeContent: returns NO
- (instancetype)initWithContent:(NSString *)content error:(NSError**)error
{
	self = [super init];
	
	if (self)
	{
		NSError *encodeError = nil;
		
		if (![content length])
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Unable to encoded empty string in %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return nil;
		}
		
		
		// query the sub-classes method to check if this can be encoded
		if (![[self class] canEncodeContent:content error:&encodeError])
		{
			if (error)
			{
				*error = encodeError;
			}
			else
			{
				NSLog(@"%s %@", __PRETTY_FUNCTION__, [encodeError localizedDescription]);
			}
			
			return nil;
		}
		
		_content = [content copy];
	}
	
	return self;
}

- (BCKBarString *)barString
{
	BCKMutableBarString	*tmpString = [BCKMutableBarString string];
	
	for (BCKCodeCharacter *oneCharacter in [self codeCharacters])
	{
		[tmpString appendBarString:[oneCharacter barString]];
	}
	
	return tmpString;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ content='%@'>", NSStringFromClass([self class]), BCKBarStringToNSString([self barString])];
}

#pragma mark - Options Helper Methods

// returns the actually displayed left quiet zone text based on the options
- (NSString *)_leftQuietZoneDisplayTextWithOptions:(NSDictionary *)options
{
	NSString *leftQuietZoneText = [self captionTextForZone:BCKCodeDrawingCaptionLeftQuietZone withRenderOptions:options];
	
	if (self.allowsFillingOfEmptyQuietZones && [[options objectForKey:BCKCodeDrawingFillEmptyQuietZonesOption] boolValue])
	{
		if (!leftQuietZoneText)
		{
			leftQuietZoneText = @"<";
		}
	}
	
	return leftQuietZoneText;
}

// returns the actually displayed right quiet zone text based on the options
- (NSString *)_rightQuietZoneDisplayTextWithOptions:(NSDictionary *)options
{
	NSString *rightQuietZoneText = [self captionTextForZone:BCKCodeDrawingCaptionRightQuietZone withRenderOptions:options];
	
	if (self.allowsFillingOfEmptyQuietZones && [[options objectForKey:BCKCodeDrawingFillEmptyQuietZonesOption] boolValue])
	{
		if (!rightQuietZoneText)
		{
			rightQuietZoneText = @">";
		}
	}
	
	return rightQuietZoneText;
}

// returns the actually displayed left caption zone text based on the options
- (NSString *)_leftCaptionZoneDisplayTextWithOptions:(NSDictionary *)options
{
	if (![self _shouldDrawCaptionFromOptions:options])
	{
		return nil;
	}
	
	NSString *leftCaptionString = [self captionTextForZone:BCKCodeDrawingCaptionLeftNumberZone withRenderOptions:options];
	if ([leftCaptionString length])
	{
		return [leftCaptionString copy];
	}
	
	return nil;
}

// returns the actually displayed left caption zone text based on the options
- (NSString *)_rightCaptionZoneDisplayTextWithOptions:(NSDictionary *)options
{
	if (![self _shouldDrawCaptionFromOptions:options])
	{
		return nil;
	}
	
	NSString *rightCaptionString = [self captionTextForZone:BCKCodeDrawingCaptionRightNumberZone withRenderOptions:options];
	if ([rightCaptionString length])
	{
		return [rightCaptionString copy];
	}
	
	return nil;
}

- (CGFloat)_horizontalQuietZoneWidthWithOptions:(NSDictionary *)options
{
	CGFloat quiteZone = ([self horizontalQuietZoneWidth]-1) * [self _barScaleFromOptions:options];
	return quiteZone;
}

- (CGFloat)_leftCaptionZoneWidthWithOptions:(NSDictionary *)options
{
	__block NSUInteger bitsBeforeMiddle = 0;
	__block BOOL metContent = NO;
	
	// aggregate digits before marker
	[[self codeCharacters] enumerateObjectsUsingBlock:^(BCKCodeCharacter *character, NSUInteger charIndex, BOOL *stop) {
		
		if ([character isMarker])
		{
			if (metContent)
			{
				*stop = YES;
				return;
			}
		}
		else
		{
			bitsBeforeMiddle += [character.barString length];
			metContent = YES;
		}
	}];
	
	if (bitsBeforeMiddle>0)
	{
		bitsBeforeMiddle -= 2; // to space text away from width
	}
	
	return bitsBeforeMiddle * [self _barScaleFromOptions:options];
}

- (CGFloat)_rightCaptionZoneWidthWithOptions:(NSDictionary *)options
{
	__block NSUInteger bitsAfterMiddle = 0;
	__block BOOL metMiddleMarker = NO;
	__block BOOL metContent = NO;
	
	// aggregate digits before marker
	[[self codeCharacters] enumerateObjectsUsingBlock:^(BCKCodeCharacter *character, NSUInteger charIndex, BOOL *stop) {
		
		if ([character isMarker])
		{
			if (metContent && !metMiddleMarker)
			{
				metMiddleMarker = YES;
			}
		}
		else
		{
			if (metMiddleMarker)
			{
				bitsAfterMiddle += [character.barString length];
			}
			
			metContent = YES;
		}
	}];
	
	if (bitsAfterMiddle>0)
	{
		bitsAfterMiddle -= 2; // to space text away from width
	}
	
	return bitsAfterMiddle * [self _barScaleFromOptions:options];
}

- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options
{
	// for sizing the caption we always assume that quiet zones are filled and check digits are shown
	NSMutableDictionary *tmpOptions = [[NSMutableDictionary alloc] initWithDictionary:options];
	tmpOptions[BCKCodeDrawingFillEmptyQuietZonesOption] = @(YES);
	tmpOptions[BCKCodeDrawingShowCheckDigitsOption] = @(YES);
	
	NSString *leftQuietZoneText = [self _leftQuietZoneDisplayTextWithOptions:tmpOptions];
	NSString *rightQuietZoneText = [self _rightQuietZoneDisplayTextWithOptions:tmpOptions];
	
	NSString *leftDigits = [self _leftCaptionZoneDisplayTextWithOptions:options];
	NSString *rightDigits = [self _rightCaptionZoneDisplayTextWithOptions:options];
	
	NSString *fontName = [self _captionFontNameFromOptions:options];
	
	CGFloat optimalCaptionFontSize = CGFLOAT_MAX;
	
	if ([leftQuietZoneText length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:leftQuietZoneText fontName:fontName insideWidth:[self _horizontalQuietZoneWidthWithOptions:options]]);
	}
	
	if ([leftDigits length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:leftDigits fontName:fontName insideWidth:[self _leftCaptionZoneWidthWithOptions:options]]);
	}
	
	if ([rightDigits length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:rightDigits fontName:fontName insideWidth:[self _rightCaptionZoneWidthWithOptions:options]]);
	}
	
	if ([rightQuietZoneText length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:rightQuietZoneText fontName:fontName insideWidth:[self _horizontalQuietZoneWidthWithOptions:options]]);
	}
   
   if (optimalCaptionFontSize == CGFLOAT_MAX)
   {
      // have no caption font size calculated yet
      NSNumber *number = options[BCKCodeDrawingCaptionFontPointSizeOption];
      
      // check if there is a fixed point size
      if (number)
      {
         return [number floatValue];
      }
      
      // at this point we need to come up with a sensible caption size ourselves
      CGSize size = [self sizeWithRenderOptions:options];
      optimalCaptionFontSize = roundf(size.height / 5.0);
   }
	
	return optimalCaptionFontSize;
}

- (BOOL)_shouldShowCheckDigitsFromOptions:(NSDictionary *)options
{
	NSNumber *num = [options objectForKey:BCKCodeDrawingShowCheckDigitsOption];
	
	if (num)
	{
		return [num boolValue];
	}
	else
	{
		return 0;  // default
	}
}


- (BOOL)_hasQuitezones:(NSDictionary *)options
{
	
	NSNumber *num = [options objectForKey:BCKCodeDrawingBarcodeHasQuiteZones];
	
	if (num)
	{
		return [num boolValue];
	}
	else
	{
		return 0;  // default
	}
}


- (BOOL)_shouldDrawCaptionFromOptions:(NSDictionary *)options
{
	if (![self respondsToSelector:@selector(captionTextForZone:withRenderOptions:)])
	{
		return NO;
	}
	
	NSNumber *num = [options objectForKey:BCKCodeDrawingPrintCaptionOption];
	
	if (num)
	{
		return [num boolValue];
	}
	else
	{
		return 1;  // default
	}
}

- (CGFloat)_markerBarCaptionOverlapFromOptions:(NSDictionary *)options
{
	NSNumber *num = [options objectForKey:BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption];
	
	if (num)
	{
		return [num floatValue];
	}
	
	return 1; // default
}

- (NSString *)_captionFontNameFromOptions:(NSDictionary *)options
{
	NSString *fontName = [options objectForKey:BCKCodeDrawingCaptionFontNameOption];
	
	if (fontName)
	{
		return fontName;
	}
	
	return [self defaultCaptionFontName];
}

#pragma mark - Caption Text

- (NSAttributedString *)_attributedStringForCaptionText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize
{
	// create a centered paragraph style
	CTTextAlignment alignment = kCTTextAlignmentCenter;
	CTParagraphStyleSetting settings[] = {{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}};
	CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);
	
	CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)(fontName), fontSize, NULL);
	
	// fall back
	if (!font)
	{
		font = CTFontCreateWithName(CFSTR("Helvetica"), fontSize, NULL);
	}
	
	NSDictionary *attributes = @{(id)kCTParagraphStyleAttributeName: CFBridgingRelease(paragraphStyle),
								 (id)kCTFontAttributeName: CFBridgingRelease(font)};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CTFrameRef)_frameWithCaptionText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize constraintedToWidth:(CGFloat)constraintWidth
{
	if (!constraintWidth)
	{
		constraintWidth = CGFLOAT_MAX;
	}
	
	NSAttributedString *attributedString = [self _attributedStringForCaptionText:text fontName:fontName fontSize:fontSize];
	
	CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attributedString));
	CTTypesetterRef typesetter = CTFramesetterGetTypesetter(framesetter);
	CGRect rect = CGRectMake(0, 0, constraintWidth, 10000);
	CFIndex length = CTTypesetterSuggestLineBreak(typesetter, 0, rect.size.width);
	CFRange stringRange = CFRangeMake(0, length);
	CGPathRef path = CGPathCreateWithRect(rect, NULL);
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, stringRange, path, NULL);
	
	CGPathRelease(path);
	CFRelease(framesetter);
	
	return frame;
}

- (CGSize)_sizeNeededByFirstLineInFrame:(CTFrameRef)frame
{
	NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
	
	if (![lines count])
	{
		return CGSizeZero;
	}
	
	CTLineRef line = (__bridge CTLineRef)(lines[0]);
	
	// determine size of line
	CGFloat ascent;
	CGFloat descent;
	CGFloat leading;
	
	CGSize neededSize;
	
	neededSize.width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	neededSize.height = ascent + descent;
	
	return neededSize;
}

- (CGFloat)_optimalFontSizeToFitText:(NSString *)text fontName:(NSString *)fontName insideWidth:(CGFloat)width
{
	CGFloat fontSize = 1;
	
	do
	{
		CTFrameRef frame = [self _frameWithCaptionText:text fontName:fontName fontSize:fontSize constraintedToWidth:CGFLOAT_MAX];
		
		if (!frame)
		{
			break;
		}
		
		CGSize neededSize = [self _sizeNeededByFirstLineInFrame:frame];
		
		CFRelease(frame);
		
		if (neededSize.width >= width)
		{
			break;
		}
		
		fontSize++;
	}
	while (1);
	
	return fontSize;
}

- (CGFloat)_barScaleFromOptions:(NSDictionary *)options
{
	NSNumber *barScaleNum = [options objectForKey:BCKCodeDrawingBarScaleOption];
	
	if (barScaleNum)
	{
		return [barScaleNum floatValue];
	}
	else
	{
		return 1;  // default
	}
}


- (CGFloat)_barcodeWidthFromOptions:(NSDictionary *)options
{
	NSNumber *barWidth = [options objectForKey:BCKCodeDrawingSizeWidthOption];
	
	if (barWidth)
	{
		return [barWidth floatValue];
	}
	else
	{
		return 120;  // default
	}
}

- (CGFloat)_barcodeHeightFromOptions:(NSDictionary *)options
{
	NSNumber *barHeight = [options objectForKey:BCKCodeDrawingSizeHeightOption];
	
	if (barHeight)
	{
		return [barHeight floatValue];
	}
	else
	{
		return 40;  // default
	}
}


#pragma mark - BCKCoding Methods

+ (NSString *)barcodeStandard
{
	return nil;
}

+ (NSString *)barcodeDescription
{
	return nil;
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error
{
	if (error)
	{
		*error = [NSError BCKCodeErrorWithMessage:ENCODE_ERROR_MESSAGE];
	}
	
	return NO;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 0;
}

- (NSArray *)codeCharacters
{
	return nil;
}

- (CGFloat)aspectRatio
{
	return 1;
}

- (CGFloat)fixedHeight
{
	return 0;
}

- (BOOL)markerBarsCanOverlapBottomCaption
{
	return NO;
}

- (BOOL)allowsFillingOfEmptyQuietZones
{
	return NO;
}

- (BOOL)showCheckDigitsInCaption
{
	return NO;
}

- (NSString *)defaultCaptionFontName
{
	return @"Helvetica";
}

#pragma mark - Drawing

- (void)_drawBackgroundColorInContext:(CGContextRef)context bounds:(CGRect)bounds options:(NSDictionary *)options
{
	id backgroundColor = [options objectForKey:BCKCodeDrawingBackgroundColorOption];
	
	if (!backgroundColor)
	{
		return;
	}
	
	CGContextSaveGState(context);
	
#if TARGET_OS_IPHONE
	UIColor *uiColor = (UIColor *)backgroundColor;
	CGContextSetFillColorWithColor(context, [uiColor CGColor]);
#else
	NSColor *nsColor = (NSColor *)backgroundColor;
	CGContextSetFillColorWithColor(context, [nsColor CGColor]);
#endif
	
	CGContextFillRect(context, bounds);
	
	CGContextRestoreGState(context);
}

- (void)_drawCaptionText:(NSString *)text fontName:fontName fontSize:(CGFloat)fontSize inRect:(CGRect)rect context:(CGContextRef)context
{
	if (![text length])
	{
		return;
	}
	
	CTFrameRef frame = [self _frameWithCaptionText:text fontName:fontName fontSize:fontSize constraintedToWidth:rect.size.width];
	
	if (!frame)
	{
		return;
	}
	
	NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
	
	if (![lines count])
	{
		CFRelease(frame);
		return;
	}
	
	CTLineRef line = (__bridge CTLineRef)(lines[0]);
	
	CGFloat ascent;
	CGFloat descent;
	CGFloat leading;
	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	
	CGContextSaveGState(context);
	
	// Flip the text matrix
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1));
   
   // specify baseline origin relative to rect parameter
	CGFloat x = CGRectGetMidX(rect) - width/2.0f;
	CGFloat y = CGRectGetMaxY(rect) - descent;
	CGContextSetTextPosition(context, x, y);
	
	// draw the text line
	CTLineDraw(line, context);
	
	CGContextRestoreGState(context);
	CFRelease(frame);
}

- (CGSize)sizeWithRenderOptions:(NSDictionary *)options
{
	CGFloat barScale = [self _barScaleFromOptions:options];
	NSUInteger horizontalQuietZoneWidth = [self horizontalQuietZoneWidth];
	NSUInteger length = [[self barString] length];

	CGSize size = CGSizeZero;
	
	size.width = (length + 2.0f * horizontalQuietZoneWidth) * barScale;
	
	CGFloat aspectRatio = [self aspectRatio];
	
	if (aspectRatio)
	{
		size.height = ceilf(size.width / [self aspectRatio]);
	}
	else
	{
		size.height = [self fixedHeight];
	}
	
	
	if ([options objectForKey:BCKCodeDrawingSizeWidthOption])
	{
		size.width = [self _barcodeWidthFromOptions:options];
	}
	if ([options objectForKey:BCKCodeDrawingSizeHeightOption]) {
		size.height = [self _barcodeHeightFromOptions:options];
	}
	

	return size;
}

- (CGRect)_calculateBarRectForType:(BCKBarType)barType andXOffset:(CGFloat)x andBarScale:(CGFloat)barScale andBarLength:(CGFloat)barLength
{
    CGRect barRect;
    
    switch (barType)
    {
        case BCKBarTypeFull:
        case BCKBarTypeSpace:
        {
            barRect = CGRectMake(x, 0, barScale, barLength);
            break;
        }
        case BCKBarTypeBottomHalf:
        {
            barRect = CGRectMake(x, 0 + barLength / 2, barScale, barLength / 2);
            break;
        }
        case BCKBarTypeBottomTwoThirds:
        {
            barRect = CGRectMake(x, 0 + barLength * 1 / 3, barScale, barLength / 3 * 2);
            break;
        }
        case BCKBarTypeCentreOneThird:
        {
            barRect = CGRectMake(x, 0 + barLength * 1 / 3, barScale, barLength / 3);
            break;
        }
        case BCKBarTypeTopHalf:
        {
            barRect = CGRectMake(x, 0, barScale, barLength / 2);
            break;
        }
        case BCKBarTypeTopTwoThirds:
        {
            barRect = CGRectMake(x, 0, barScale, barLength / 3 * 2);
            break;
        }
    }
    
    return barRect;
}

- (void)renderInContext:(CGContextRef)context options:(NSDictionary *)options
{
	CGContextSaveGState(context);
	
	CGFloat barScale = [self _barScaleFromOptions:options];
	
	CGSize size = [self sizeWithRenderOptions:options];
	
	CGRect bounds = (CGRect){CGPointZero, size};
	
	[self _drawBackgroundColorInContext:context bounds:bounds options:options];
	
	CGFloat captionHeight = 0;
	CGFloat optimalCaptionFontSize = 0;
	CGRect bottomCaptionRegion = CGRectMake(0, size.height, size.width, 0);
	
	NSString *leftQuietZoneText = nil;
	NSString *leftDigits = nil;
	NSString *rightDigits = nil;
	NSString *rightQuietZoneText = nil;
	
	// determine height of caption if needed
	if ([self _shouldDrawCaptionFromOptions:options])
	{
		leftQuietZoneText = [self _leftQuietZoneDisplayTextWithOptions:options];
		leftDigits = [self _leftCaptionZoneDisplayTextWithOptions:options];
		rightDigits = [self _rightCaptionZoneDisplayTextWithOptions:options];
		rightQuietZoneText = [self _rightQuietZoneDisplayTextWithOptions:options];
		
		optimalCaptionFontSize = [self _captionFontSizeWithOptions:options];
		NSString *fontName = [self _captionFontNameFromOptions:options];
		
		NSString *entireCaption = [NSString stringWithFormat:@"%@%@%@%@", leftQuietZoneText, leftDigits, rightDigits, rightQuietZoneText];
		
		CTFrameRef frame = [self _frameWithCaptionText:entireCaption fontName:fontName fontSize:optimalCaptionFontSize constraintedToWidth:0];
		CGSize neededSize = [self _sizeNeededByFirstLineInFrame:frame];
		CFRelease(frame);
		
		captionHeight = neededSize.height;
		
		bottomCaptionRegion = CGRectMake(0, size.height-captionHeight - barScale, size.width, captionHeight + barScale);
	}
	
	// determine bar lengths, bars for digits are usually shorter than bars for markers
	CGFloat captionOverlap = [self _markerBarCaptionOverlapFromOptions:options];
	CGFloat digitBarLength = CGRectGetMinY(bottomCaptionRegion);
	CGFloat markerBarLength = CGRectGetMinY(bottomCaptionRegion) + captionOverlap * bottomCaptionRegion.size.height;
	
	__block NSUInteger drawnBitIndex = 0;
	__block BOOL metMiddleMarker = NO;
	__block CGRect leftQuietZoneNumberFrame = CGRectNull;
	__block CGRect leftNumberFrame = CGRectNull;
	__block CGRect rightNumberFrame = CGRectNull;
	__block CGRect frameBetweenEndMarkers = CGRectNull;
	__block CGRect rightQuietZoneNumberFrame = CGRectZero;
	NSUInteger horizontalQuietZoneWidth = 0;
	if ([self _hasQuitezones:options]) {
		horizontalQuietZoneWidth = [self horizontalQuietZoneWidth];
	}
	
	BOOL useOverlap = [self markerBarsCanOverlapBottomCaption];
	
	__block BOOL metContent = NO;
	__block CGRect middleMarkerFrame = CGRectNull;
	
	NSArray *codeCharacters = [self codeCharacters];

	// enumerate the code characters
	[codeCharacters enumerateObjectsUsingBlock:^(BCKCodeCharacter *character, NSUInteger charIndex, BOOL *stop) {
		
		// bar length is different for markers and digits
		CGFloat barLength = digitBarLength;
		
		if (useOverlap && [character isMarker])
		{
			barLength = markerBarLength;
		}
		
		__block CGRect characterRect = CGRectNull;

		// walk through the bars of the character
		[character enumerateBarsUsingBlock:^(BCKBarType bar, BOOL isBar, NSUInteger idx, BOOL *stop) {
			CGFloat x = (drawnBitIndex + horizontalQuietZoneWidth) * barScale;
			
			CGRect barRect;
			barRect = [self _calculateBarRectForType:bar andXOffset:x andBarScale:barScale andBarLength:barLength];
			
			if (CGRectIsNull(characterRect))
			{
				characterRect = barRect;
			}
			else
			{
				characterRect = CGRectUnion(characterRect, barRect);
			}
			
			if (isBar)
			{
            if ([options[BCKCodeDrawingReduceBleedOption] boolValue])
            {
               // decrease bar width slightly because on thermo printers they might become too wide otherwise
               CGRect fillRect = CGRectInset(barRect, 0.13, 0);
               CGContextAddRect(context, fillRect);
            }
            else
            {
               CGContextAddRect(context, barRect);
            }
			}
			
			drawnBitIndex++;
		}];
        
		if ([character isMarker])
		{
			if (metContent)
			{
				if (!metMiddleMarker)
				{
					// middle marker
					metMiddleMarker = YES;
					middleMarkerFrame = characterRect;
				}
			}
			else
			{
				// left outer marker
				if (CGRectIsNull(leftQuietZoneNumberFrame))
				{
					leftQuietZoneNumberFrame = CGRectMake(0, 0, characterRect.origin.x, size.height);
				}
			}
			
			// right outer marker
			CGFloat x = CGRectGetMaxX(characterRect);
			rightQuietZoneNumberFrame = CGRectMake(x, 0, size.width - x, size.height);
		}
		else
		{
			metContent = YES;
			
			if (CGRectIsNull(frameBetweenEndMarkers))
			{
				frameBetweenEndMarkers = CGRectMake(characterRect.origin.x, characterRect.origin.y, characterRect.size.width, size.height);
			}
			else
			{
				frameBetweenEndMarkers = CGRectUnion(frameBetweenEndMarkers, characterRect);
			}
		}
	}];
	
	// paint all bars
	
   //CGContextSaveGState(context);
	CGContextSetGrayFillColor(context, 0, 1);
   //CGContextSetShouldAntialias(context, NO);
	CGContextFillPath(context);
	//CGContextRestoreGState(context);
   
	if ([self _shouldDrawCaptionFromOptions:options])
	{
		NSString *fontName = [self _captionFontNameFromOptions:options];
		
		// indent quiet zones to have 1 px distance
		leftQuietZoneNumberFrame.size.width -= barScale;
		
		rightQuietZoneNumberFrame.origin.x += barScale;
		rightQuietZoneNumberFrame.size.width -= barScale;
		
		// determine if there is a middle marker
		BOOL hasMiddleMarker = (middleMarkerFrame.origin.x < CGRectGetMaxX(frameBetweenEndMarkers));
		
		if (hasMiddleMarker)
		{
			// split left and right number areas at the middle marker
			leftNumberFrame = frameBetweenEndMarkers;
			leftNumberFrame.size.width = middleMarkerFrame.origin.x - leftNumberFrame.origin.x;
			
			if (middleMarkerFrame.origin.x < CGRectGetMaxX(frameBetweenEndMarkers))
			{
				rightNumberFrame = frameBetweenEndMarkers;
				rightNumberFrame.origin.x = CGRectGetMaxX(middleMarkerFrame);
				rightNumberFrame.size.width = CGRectGetMaxX(frameBetweenEndMarkers) - rightNumberFrame.origin.x;
			}
			
			
			// we have number zones
			
			// insure at least 1 bar width space between bars and caption
			leftNumberFrame.origin.x += barScale;
			leftNumberFrame.size.width -= barScale;
			
			rightNumberFrame.size.width -= barScale;
			
			// reduce the bar regions to the caption region
			leftNumberFrame = CGRectIntersection(bottomCaptionRegion, leftNumberFrame);
			rightNumberFrame = CGRectIntersection(bottomCaptionRegion, rightNumberFrame);
			leftQuietZoneNumberFrame = CGRectIntersection(bottomCaptionRegion, leftQuietZoneNumberFrame);
			rightQuietZoneNumberFrame = CGRectIntersection(bottomCaptionRegion, rightQuietZoneNumberFrame);
			
			// insure at least 1 bar width space between bars and caption
			leftNumberFrame.origin.y += barScale;
			leftNumberFrame.size.height -= barScale;
			
			rightNumberFrame.origin.y += barScale;
			rightNumberFrame.size.height -= barScale;
			
			leftQuietZoneNumberFrame.origin.y += barScale;
			leftQuietZoneNumberFrame.size.height -= barScale;
			
			rightQuietZoneNumberFrame.origin.y += barScale;
			rightQuietZoneNumberFrame.size.height -= barScale;
			
			
			// DEBUG Option
			if ([[options objectForKey:BCKCodeDrawingDebugOption] boolValue])
			{
				CGContextSetRGBFillColor(context, 1, 0, 0, 0.6);
				CGContextFillRect(context, leftNumberFrame);
				
				CGContextSetRGBFillColor(context, 0, 1, 0, 0.6);
				CGContextFillRect(context, rightNumberFrame);
				
				CGContextSetRGBFillColor(context, 0, 0, 1, 0.6);
				CGContextFillRect(context, leftQuietZoneNumberFrame);
				
				CGContextSetRGBFillColor(context, 0, 0, 1, 0.6);
				CGContextFillRect(context, rightQuietZoneNumberFrame);
			}
			
			// Draw Captions
			if (leftDigits)
			{
				[self _drawCaptionText:leftDigits fontName:fontName fontSize:optimalCaptionFontSize inRect:leftNumberFrame context:context];
			}
			
			if (rightDigits)
			{
				[self _drawCaptionText:rightDigits fontName:fontName fontSize:optimalCaptionFontSize inRect:rightNumberFrame context:context];
			}
			
			if (leftQuietZoneText)
			{
				[self _drawCaptionText:leftQuietZoneText fontName:fontName fontSize:optimalCaptionFontSize inRect:leftQuietZoneNumberFrame context:context];
			}
			
			if (rightQuietZoneText)
			{
				[self _drawCaptionText:rightQuietZoneText fontName:fontName fontSize:optimalCaptionFontSize inRect:rightQuietZoneNumberFrame context:context];
			}
		}
		else
		{
			// one big caption area
			
			// reduce the bar regions to the caption region
			leftQuietZoneNumberFrame = CGRectIntersection(bottomCaptionRegion, leftQuietZoneNumberFrame);
			rightQuietZoneNumberFrame = CGRectIntersection(bottomCaptionRegion, rightQuietZoneNumberFrame);
			frameBetweenEndMarkers = CGRectIntersection(bottomCaptionRegion, frameBetweenEndMarkers);
			
			// indent by 1 bar width if left marker ends with a bar
			BCKCodeCharacter *leftOuterMarker = codeCharacters[0];
			
			if ([[leftOuterMarker barString] endsWithBar:BCKBarTypeFull])
			{
				frameBetweenEndMarkers.origin.x += barScale;
				frameBetweenEndMarkers.size.width -= barScale;
			}
			
			// indent by 1 bar width if right marker begins with a bar
			BCKCodeCharacter *rightOuterMarker = [codeCharacters lastObject];
			
			if ([[rightOuterMarker barString] endsWithBar:BCKBarTypeFull])
			{
				frameBetweenEndMarkers.size.width -= barScale;
			}
			
			// space 1px from bars
			frameBetweenEndMarkers.origin.y += barScale;
			frameBetweenEndMarkers.size.height -= barScale;
			
			leftQuietZoneNumberFrame.origin.y += barScale;
			leftQuietZoneNumberFrame.size.height -= barScale;
			
			rightQuietZoneNumberFrame.origin.y += barScale;
			rightQuietZoneNumberFrame.size.height -= barScale;
			
			// DEBUG Option
			if ([[options objectForKey:BCKCodeDrawingDebugOption] boolValue])
			{
				CGContextSetRGBFillColor(context, 1, 0, 0, 0.6);
				CGContextFillRect(context, frameBetweenEndMarkers);
				
				CGContextSetRGBFillColor(context, 0, 0, 1, 0.6);
				CGContextFillRect(context, leftQuietZoneNumberFrame);
				
				CGContextSetRGBFillColor(context, 0, 0, 1, 0.6);
				CGContextFillRect(context, rightQuietZoneNumberFrame);
			}
			
			NSString *text = [self captionTextForZone:BCKCodeDrawingCaptionTextZone withRenderOptions:options];
			
			if (text)
			{
				[self _drawCaptionText:text fontName:fontName fontSize:[self _captionFontSizeWithOptions:options] inRect:frameBetweenEndMarkers context:context];
			}
			
			if (leftQuietZoneText)
			{
				[self _drawCaptionText:leftQuietZoneText fontName:fontName fontSize:optimalCaptionFontSize inRect:leftQuietZoneNumberFrame context:context];
			}
			
			if (rightQuietZoneText)
			{
				[self _drawCaptionText:rightQuietZoneText fontName:fontName fontSize:optimalCaptionFontSize inRect:rightQuietZoneNumberFrame context:context];
			}
		}
	}
	
	CGContextRestoreGState(context);
}

@end
