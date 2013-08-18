//
//  BCKEAN13Code.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN13Code.h"
#import "BCKEANCodeCharacter.h"

// the variant pattern to use based on the first digit
static char *variant_patterns[10] = {"LLLLLLRRRRRR",  // 0
	"LLGLGGRRRRRR",  // 1
	"LLGGLGRRRRRR",  // 2
	"LLGGGLRRRRRR",  // 3
	"LGLLGGRRRRRR",  // 4
	"LGGLLGRRRRRR",  // 5
	"LGGGLLRRRRRR",  // 6
	"LGLGLGRRRRRR",  // 7
	"LGLGGLRRRRRR",  // 8
	"LGGLGLRRRRRR"   // 9
};

@implementation BCKEAN13Code


#pragma mark - Helper Methods
- (NSUInteger)_digitAtIndex:(NSUInteger)index
{
	NSString *digitStr = [self.content substringWithRange:NSMakeRange(index, 1)];
	return [digitStr integerValue];
}

- (NSUInteger)_codeVariantIndexForDigitAtIndex:(NSUInteger)index withVariantPattern:(char *)variantPattern
{
	NSAssert(index>0 && index<13, @"Index must be from 1 to 12");
	
	char variantForDigit = variantPattern[index-1];
	NSUInteger variantIndex = BCKEANCodeCharacterEncoding_L;
	
	if (variantForDigit == 'G')
	{
		variantIndex = BCKEANCodeCharacterEncoding_G;
	}
	else if (variantForDigit == 'R')
	{
		variantIndex = BCKEANCodeCharacterEncoding_R;
	}
	
	return variantIndex;
}

#pragma mark - Subclassing Methods

- (NSUInteger)horizontalQuietZoneWidth
{
	return 7;
}

- (NSArray *)codeCharacters
{
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	// variant pattern derives from first digit
	NSUInteger firstDigit = [self _digitAtIndex:0];
	char *variant_pattern = variant_patterns[firstDigit];
	
	// start marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index = 1; index < 13; index ++)
	{
		NSUInteger digit = [self _digitAtIndex:index];
		BCKEANCodeCharacterEncoding encoding = [self _codeVariantIndexForDigitAtIndex:index withVariantPattern:variant_pattern];
		
		[tmpArray addObject:[BCKEANCodeCharacter codeCharacterForDigit:digit encoding:encoding]];
		
		if (index == 6)
		{
			// middle marker
			[tmpArray addObject:[BCKEANCodeCharacter middleMarkerCodeCharacter]];
		}
	}
	
	// end marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];
	
	return [tmpArray copy];
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone
{
	if (captionZone == BCKCodeDrawingCaptionLeftQuietZone)
	{
		return [self.content substringToIndex:1];
	}
	
	return nil;
}

- (CGFloat)aspectRatio
{
	return 39.29 / 25.91;
}

@end
