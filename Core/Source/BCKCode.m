//
//  BCKCode.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"
#import "BarCodeKit.h"

@implementation BCKCode

- (instancetype)initWithContent:(NSString *)content
{
	self = [super init];
	
	if (self)
	{
		_content = [content copy];
	}
	
	return self;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 0;
}

- (NSString *)bitString
{
	NSMutableString *tmpString = [NSMutableString string];
	
	for (BCKEANCodeCharacter *oneCharacter in [self codeCharacters])
	{
		[tmpString appendString:[oneCharacter bitString]];
	}
	
	return tmpString;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ content='%@'>", NSStringFromClass([self class]), [self bitString]];
}

- (NSArray *)codeCharacters
{
	return nil;
}

#pragma mark - Caption
- (NSString *)leftQuietZoneText
{
	return nil;
}

- (NSString *)rightQuietZoneText
{
	return nil;
}

#pragma mark - Drawing

- (UIImage *)image
{
	CGFloat barScale = 1.5;
	CGFloat imageHeight = 120;
	
	NSUInteger horizontalQuietZoneWidth = [self horizontalQuietZoneWidth];
	
	NSString *bitString = [self bitString];
	NSUInteger length = [bitString length];
	
	CGSize size = CGSizeMake((length + 2.0f * horizontalQuietZoneWidth) * barScale, imageHeight);
	
	UIGraphicsBeginImageContextWithOptions(size, YES, 0);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor whiteColor] setFill];
	CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
	
//	CGContextSetAllowsAntialiasing(context, NO);
	
	__block NSUInteger index = 0;
	
	__block CGRect leftQuietZoneNumberRegion = CGRectZero;
	__block CGRect leftNumberRegion = CGRectNull;
	__block CGRect rightNumberRegion = CGRectNull;
	__block CGRect rightQuietZoneNumberRegion = CGRectZero;
	
	NSString *leftQuietZoneText = [self leftQuietZoneText];
	NSMutableString *leftDigits = [NSMutableString string];
	NSMutableString *rightDigits = [NSMutableString string];
	NSString *rightQuietZoneText = [self rightQuietZoneText];
	
	__block BOOL metMiddleMarker = NO;
	
	// enumerate the code characters
	[[self codeCharacters] enumerateObjectsUsingBlock:^(BCKEANCodeCharacter *character, NSUInteger charIndex, BOOL *stop) {

		// walk through the bits of the character
		
		__block CGRect characterRect = CGRectNull;

		[character enumerateBitsUsingBlock:^(BOOL isBar, NSUInteger idx, BOOL *stop) {
			
			CGFloat x = (index + horizontalQuietZoneWidth) * barScale;
			
			CGFloat barPercent = 1.0f;
			
			CGRect barRect = CGRectMake(x, 0, barScale, imageHeight*barPercent);
			
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
				CGContextAddRect(context, barRect);
			}
			
			index++;
		}];
		
		if ([character isKindOfClass:[BCKEANMiddleMarkerCodeCharacter class]])
		{
			metMiddleMarker = YES;
		}
		else if ([character isKindOfClass:[BCKEANEndMarkerCodeCharacter class]])
		{
			if (CGRectIsEmpty(leftQuietZoneNumberRegion))
			{
				leftQuietZoneNumberRegion.origin.y = characterRect.origin.y;
				leftQuietZoneNumberRegion.size.width = characterRect.origin.x;
				leftQuietZoneNumberRegion.size.height = size.height;
			}
		}
		
		if ([character isKindOfClass:[BCKEANDigitCodeCharacter class]])
		{
			BCKEANDigitCodeCharacter *digitChar = (BCKEANDigitCodeCharacter *)character;
			
			if (metMiddleMarker)
			{
				if (CGRectIsNull(rightNumberRegion))
				{
					rightNumberRegion = characterRect;
				}
				else
				{
					rightNumberRegion = CGRectUnion(characterRect, rightNumberRegion);
				}
				
				[rightDigits appendFormat:@"%d", [digitChar digit]];
			}
			else
			{
				if (CGRectIsNull(leftNumberRegion))
				{
					leftNumberRegion = characterRect;
				}
				else
				{
					leftNumberRegion = CGRectUnion(characterRect, leftNumberRegion);
				}
				
				[leftDigits appendFormat:@"%d", [digitChar digit]];
			}
		}
		
		rightQuietZoneNumberRegion.origin.x = CGRectGetMaxX(characterRect);
		rightQuietZoneNumberRegion.origin.y = characterRect.origin.y;
		rightQuietZoneNumberRegion.size.width = size.width - rightQuietZoneNumberRegion.origin.x;
		rightQuietZoneNumberRegion.size.height = size.height;
	}];
	
	[[UIColor blackColor] setFill];
	CGContextFillPath(context);

	// insure at least 1 bar width space between bars and caption
	leftNumberRegion.origin.x += barScale;
	leftNumberRegion.size.width -= barScale;
	
	rightNumberRegion.size.width -= barScale;
	
	leftQuietZoneNumberRegion.size.width -= barScale;
	
	rightQuietZoneNumberRegion.origin.x += barScale;
	rightQuietZoneNumberRegion.size.width -= barScale;
	
	
	CGFloat optimalCaptionFontSize = size.height;
	
	if ([leftQuietZoneText length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:leftQuietZoneText insideWidth:leftQuietZoneNumberRegion.size.width]);
	}

	if ([leftDigits length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:leftDigits insideWidth:leftNumberRegion.size.width]);
	}

	if ([rightDigits length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:rightDigits insideWidth:rightNumberRegion.size.width]);
	}

	if ([rightQuietZoneText length])
	{
		optimalCaptionFontSize = MIN(optimalCaptionFontSize, [self _optimalFontSizeToFitText:rightQuietZoneText insideWidth:rightQuietZoneNumberRegion.size.width]);
	}

	UIFont *font = [self _captionFontWithSize:optimalCaptionFontSize];
	CGFloat captionHeight = ceilf(font.ascender);
	
	CGRect bottomCaptionRegion = CGRectMake(0, size.height-captionHeight - barScale, size.width, captionHeight + barScale);
	
	leftNumberRegion = CGRectIntersection(bottomCaptionRegion, leftNumberRegion);
	rightNumberRegion = CGRectIntersection(bottomCaptionRegion, rightNumberRegion);
	leftQuietZoneNumberRegion = CGRectIntersection(bottomCaptionRegion, leftQuietZoneNumberRegion);
	rightQuietZoneNumberRegion = CGRectIntersection(bottomCaptionRegion, rightQuietZoneNumberRegion);

	[[UIColor whiteColor] setFill];
	CGContextFillRect(context, leftNumberRegion);
	CGContextFillRect(context, rightNumberRegion);

	// insure at least 1 bar width space between bars and caption
	leftNumberRegion.origin.y += barScale;
	leftNumberRegion.size.height -= barScale;
	
	rightNumberRegion.origin.y += barScale;
	rightNumberRegion.size.height -= barScale;
	
	leftQuietZoneNumberRegion.origin.y += barScale;
	leftQuietZoneNumberRegion.size.height -= barScale;

	rightQuietZoneNumberRegion.origin.y += barScale;
	rightQuietZoneNumberRegion.size.height -= barScale;


	[self _drawCaptionText:leftDigits fontSize:optimalCaptionFontSize inRect:leftNumberRegion context:context];
	[self _drawCaptionText:rightDigits fontSize:optimalCaptionFontSize inRect:rightNumberRegion context:context];
	
	if (leftQuietZoneText)
	{
		[self _drawCaptionText:leftQuietZoneText fontSize:optimalCaptionFontSize inRect:leftQuietZoneNumberRegion context:context];
	}
	
	if (rightQuietZoneText)
	{
		[self _drawCaptionText:rightQuietZoneText fontSize:optimalCaptionFontSize inRect:rightQuietZoneNumberRegion context:context];
	}
	
//	[[UIColor colorWithRed:1 green:0 blue:0 alpha:0.6] set];
//	CGContextFillRect(context, leftNumberRegion);
//	[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.6] set];
//	CGContextFillRect(context, rightNumberRegion);
//	[[UIColor colorWithRed:0 green:0 blue:1 alpha:0.6] set];
//	CGContextFillRect(context, leftQuietZoneNumberRegion);
//	[[UIColor colorWithRed:0 green:0 blue:1 alpha:0.6] set];
//	CGContextFillRect(context, rightQuietZoneNumberRegion);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

- (UIFont *)_captionFontWithSize:(CGFloat)fontSize
{
	UIFont *font = [UIFont fontWithName:@"OCRB" size:fontSize];
	
	if (!font)
	{
		font = [UIFont systemFontOfSize:fontSize];
	}
	
	return font;
}

- (CGFloat)_optimalFontSizeToFitText:(NSString *)text insideWidth:(CGFloat)width
{
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	
	CGFloat fontSize = 1;
	
	do
	{
		UIFont *font = [self _captionFontWithSize:fontSize];
		
		NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
		
		CGSize neededSize = [text sizeWithAttributes:attributes];
		
		if (neededSize.width >= width)
		{
			break;
		}
		
		fontSize++;
	} while (1);
	
	return fontSize;
}

- (void)_drawCaptionText:(NSString *)text fontSize:(CGFloat)fontSize inRect:(CGRect)rect context:(CGContextRef)context
{
	if (![text length])
	{
		return;
	}
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	
	UIFont *font =[UIFont systemFontOfSize:fontSize];
	NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
	
	CGSize leftSize = [text sizeWithAttributes:attributes];
	[[UIColor blackColor] setFill];
	
	[text drawAtPoint:CGPointMake(CGRectGetMidX(rect)-leftSize.width/2.0f, CGRectGetMaxY(rect)-font.ascender-0.5) withAttributes:attributes];
}

@end
