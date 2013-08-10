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
{
	NSString *_content;
}

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

- (UIImage *)image
{
	CGFloat barScale = 2.5;
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
	NSString *leadingDigit = [self.content substringToIndex:1];
	NSMutableString *leftDigits = [NSMutableString string];
	NSMutableString *rightDigits = [NSMutableString string];
	
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
		
		if ( //[character isKindOfClass:[BCKEANEndMarkerCodeCharacter class]] ||
			 [character isKindOfClass:[BCKEANMiddleMarkerCodeCharacter class]])
		{
			//barPercent = 1.0f;
			metMiddleMarker = YES;
		} else if ([character isKindOfClass:[BCKEANEndMarkerCodeCharacter class]])
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
		
	}];
	
	[[UIColor blackColor] setFill];
	CGContextFillPath(context);

	
	CGFloat optimalFontSizeForLeftDigits = [self _optimalFontSizeToFitText:leftDigits insideWidth:leftNumberRegion.size.width];
	CGFloat optimalFontSizeForRightDigits = [self _optimalFontSizeToFitText:rightDigits insideWidth:rightNumberRegion.size.width];
	
	CGFloat optimalCaptionFontSize = MIN(optimalFontSizeForLeftDigits, optimalFontSizeForRightDigits);
	
	UIFont *font = [self _captionFontWithSize:optimalCaptionFontSize];
	
	CGFloat captionHeight = ceilf(font.ascender);
	
	
	CGRect bottomCaptionRegion = CGRectMake(0, size.height-captionHeight - barScale, size.width, captionHeight + barScale);
	
	leftNumberRegion = CGRectIntersection(bottomCaptionRegion, leftNumberRegion);
	rightNumberRegion = CGRectIntersection(bottomCaptionRegion, rightNumberRegion);
	leftQuietZoneNumberRegion = CGRectIntersection(bottomCaptionRegion, leftQuietZoneNumberRegion);

	[[UIColor whiteColor] setFill];
	CGContextFillRect(context, leftNumberRegion);
	CGContextFillRect(context, rightNumberRegion);

	// insure at least 1 bar width space between bars and caption
	leftNumberRegion.origin.x += barScale;
	leftNumberRegion.origin.y += barScale;
	leftNumberRegion.size.width -= barScale;
	leftNumberRegion.size.height -= barScale;
	
	rightNumberRegion.origin.y += barScale;
	rightNumberRegion.size.width -= barScale;
	rightNumberRegion.size.height -= barScale;
	
	leftQuietZoneNumberRegion.origin.y += barScale;
	leftQuietZoneNumberRegion.size.width -= barScale;
	leftQuietZoneNumberRegion.size.height -= barScale;
	

	[self _drawCaptionText:leftDigits fontSize:optimalCaptionFontSize inRect:leftNumberRegion context:context];
	[self _drawCaptionText:rightDigits fontSize:optimalCaptionFontSize inRect:rightNumberRegion context:context];
	
	if ([self.content length]>8)
	{
		[self _drawCaptionText:leadingDigit fontSize:optimalCaptionFontSize inRect:leftQuietZoneNumberRegion context:context];
	}
	
//	[[UIColor colorWithRed:1 green:0 blue:0 alpha:0.6] set];
//	CGContextFillRect(context, leftNumberRegion);
//	[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.6] set];
//	CGContextFillRect(context, rightNumberRegion);
//	[[UIColor colorWithRed:0 green:0 blue:1 alpha:0.6] set];
//	CGContextFillRect(context, leftQuietZoneNumberRegion);
	
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
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	
	UIFont *font =[UIFont systemFontOfSize:fontSize];
	NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
	
	CGSize leftSize = [text sizeWithAttributes:attributes];
	[[UIColor blackColor] setFill];
	
	[text drawAtPoint:CGPointMake(CGRectGetMidX(rect)-leftSize.width/2.0f, CGRectGetMaxY(rect)-font.ascender-1.0) withAttributes:attributes];
}

@end
