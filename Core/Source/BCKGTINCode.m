//
//  BCKGTINCode.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 26.09.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKGTINCode.h"
#import "BCKCodeCharacter.h"
#import "BCKEANDigitCodeCharacter.h"

/**
 Common root class for BCKEAN13Code, BCKEAN8Code, BCKUPACode and BCKUPCECode
 */
@implementation BCKGTINCode

#pragma mark - Helper Methods

- (NSUInteger)digitAtIndex:(NSUInteger)index
{
	NSString *digitStr = [self.content substringWithRange:NSMakeRange(index, 1)];
	return [digitStr integerValue];
}

#pragma mark - BCKCoding Methods

+ (NSString *)barcodeStandard
{
	return @"International standard ISO/IEC 15420";
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionLeftNumberZone || captionZone == BCKCodeDrawingCaptionTextZone)
	{
		NSMutableString *tmpString = [NSMutableString string];
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
				if ([character isKindOfClass:[BCKEANDigitCodeCharacter class]])
				{
					BCKEANDigitCodeCharacter *digitChar = (BCKEANDigitCodeCharacter *)character;
					[tmpString appendFormat:@"%d", (int)[digitChar digit]];
				}
				
				metContent = YES;
			}
		}];
		
		if ([tmpString length])
		{
			return [tmpString copy];
		}
	}
	else if (captionZone == BCKCodeDrawingCaptionRightNumberZone)
	{
		NSMutableString *tmpString = [NSMutableString string];
		
		__block BOOL metMiddleMarker = NO;
		__block BOOL metContent = NO;
		
		// aggregate digits after marker
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
					if ([character isKindOfClass:[BCKEANDigitCodeCharacter class]])
					{
						BCKEANDigitCodeCharacter *digitChar = (BCKEANDigitCodeCharacter *)character;
						[tmpString appendFormat:@"%d", (int)[digitChar digit]];
					}
				}
				
				metContent = YES;
			}
			
		}];
		
		if ([tmpString length])
		{
			return [tmpString copy];
		}

	}
	
	return nil;
}

- (BOOL)markerBarsCanOverlapBottomCaption
{
	return YES;
}

- (NSString *)defaultCaptionFontName
{
	return @"OCRB";
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 7;
}

@end
