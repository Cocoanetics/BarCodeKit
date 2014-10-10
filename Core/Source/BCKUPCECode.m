//
//  BCKUPCECode.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKUPCECode.h"
#import "BCKEANCodeCharacter.h"
#import "NSError+BCKCode.h"

// the variant pattern to use based on the check digit (last) and first digit
static char *variant_patterns[10][2] = {{"EEEOOO", "OOOEEE"},  // 0
	{"EEOEOO", "OOEOEE"},  // 1
	{"EEOOEO", "OOEEOE"},  // 2
	{"EEOOOE", "OOEEEO"},  // 3
	{"EOEEOO", "OEOOEE"},  // 4
	{"EOOEEO", "OOEOEE"},  // 5
	{"EOOOEE", "OEEEOO"},  // 6
	{"EOEOEO", "OEOEOE"},  // 7
	{"EOEOOE", "OEOEEO"},  // 8
	{"EOOEOE", "OEEOEO"}   // 9
};

@implementation BCKUPCECode

#pragma mark - Helper Methods

- (NSUInteger)_codeVariantIndexForDigitAtIndex:(NSUInteger)index withVariantPattern:(char *)variantPattern
{
	NSAssert(index>=0 && index<8, @"Index must be from 0 to 7");
	
	char variantForDigit = variantPattern[index];
	NSUInteger variantIndex = BCKEANCodeCharacterEncoding_G;  // even
	
	if (variantForDigit == 'O')
	{
		variantIndex = BCKEANCodeCharacterEncoding_L;  // odd
	}
	
	return variantIndex;
}

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	NSUInteger length = [content length];
	
	if (length != 8)
	{
		if (error)
		{
			NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ requires content to be 8 digits", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
		
		return NO;
	}
	
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		char c = [character UTF8String][0];
		
		if (index==0)
		{
			if (c!='0' && c!='1')
			{
				if (error)
				{
					NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ requires first digit to be 0 or 1", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
					*error = [NSError BCKCodeErrorWithMessage:message];
				}
				
				return NO;
			}
		}
		
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
	return @"UPC-E";
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 7;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
   
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	// variant pattern derives from first and last digits
	NSUInteger firstDigit = [self digitAtIndex:0];
	NSUInteger checkDigit = [self digitAtIndex:7];
	
	char *variant_pattern = variant_patterns[checkDigit][firstDigit];
	
	// start marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index = 1; index < 7; index ++)
	{
		NSUInteger digit = [self digitAtIndex:index];
		BCKEANCodeCharacterEncoding encoding = [self _codeVariantIndexForDigitAtIndex:index-1 withVariantPattern:variant_pattern];
		
		[tmpArray addObject:[BCKEANCodeCharacter codeCharacterForDigit:digit encoding:encoding]];
	}
	
	// end marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacterForUPCE]];
	
	_codeCharacters = [tmpArray copy];
	return _codeCharacters;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionLeftQuietZone)
	{
		return [self.content substringToIndex:1];
	}
	else if (captionZone == BCKCodeDrawingCaptionRightQuietZone)
	{
		return [self.content substringFromIndex:7];
	}
	
	// get digit zones from code characters
	return [super captionTextForZone:captionZone withRenderOptions:options];
}

- (CGFloat)aspectRatio
{
	return 26.73 / 21.31;
}

@end
