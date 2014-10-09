//
//  BCKEAN13Code.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN13Code.h"
#import "BCKEANCodeCharacter.h"
#import "NSError+BCKCode.h"

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

// Returns the check digit for a 12-character string.
- (NSString *)generateEAN13CheckDigit:(NSString *)characterString
{
    NSUInteger weightedSum = 0;
    NSUInteger checkDigit;
    
    for (NSUInteger index=0; index<([characterString length]); index++)
	{
		NSString *character = [characterString substringWithRange:NSMakeRange(index, 1)];
        
        if (index % 2 == 0)
        {
            weightedSum += [character integerValue] * 1;
        }
        else
        {
            weightedSum += [character integerValue] * 3;
        }
    }
    
    checkDigit = 10 - weightedSum % 10;
    
    if (checkDigit == 10)
    {
        checkDigit = 0;
    }
    
    return [NSString stringWithFormat:@"%lu", (unsigned long)checkDigit];
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

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	NSUInteger length = [content length];
	
	if (length != 13)
	{
		if (error)
		{
			NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ requires content to be 13 digits", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
		
		return NO;
	}
	
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		char c = [character UTF8String][0];
		
		if (!(c>='0' && c<='9'))
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ cannot encode '%@' at index %d", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription], character, (int)index];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
	}
	
	return YES;
}

+ (NSString *)barcodeDescription
{
	return @"EAN-13";
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
   
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	// variant pattern derives from first digit
	NSUInteger firstDigit = [self digitAtIndex:0];
	char *variant_pattern = variant_patterns[firstDigit];
	
	// start marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index = 1; index < 13; index ++)
	{
		NSUInteger digit = [self digitAtIndex:index];
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
	
	_codeCharacters = [tmpArray copy];
	return _codeCharacters;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionLeftQuietZone)
	{
		return [self.content substringToIndex:1];
	}
	
	// get digit zones from code characters
	return [super captionTextForZone:captionZone withRenderOptions:options];
}

- (CGFloat)aspectRatio
{
	return 39.29 / 25.91;
}

- (BOOL)allowsFillingOfEmptyQuietZones
{
	return YES;
}

@end
