//
//  BCKUPCECode.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKUPCECode.h"
#import "BarCodeKit.h"

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

- (instancetype)initWithContent:(NSString *)content
{
	self = [super initWithContent:content];
	
	if (self)
	{
		if ([self _digitAtIndex:0]>1)
		{
			NSLog(@"Invalid content for UPC-E, should start with 0 or 1");
			return nil;
		}
		
		if ([[self content] length] != 8)
		{
			NSLog(@"Invalid content for UPC-E, length should be 8 digits");
			return nil;
		}
	}
	
	return self;
}

- (NSUInteger)_digitAtIndex:(NSUInteger)index
{
	NSString *digitStr = [self.content substringWithRange:NSMakeRange(index, 1)];
	return [digitStr integerValue];
}

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

- (NSUInteger)horizontalQuietZoneWidth
{
	return 7;
}

- (NSArray *)codeCharacters
{
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	// variant pattern derives from first and last digits
	NSUInteger firstDigit = [self _digitAtIndex:0];
	NSUInteger checkDigit = [self _digitAtIndex:7];
	
	char *variant_pattern = variant_patterns[checkDigit][firstDigit];
	
	// start marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index = 1; index < 7; index ++)
	{
		NSUInteger digit = [self _digitAtIndex:index];
		BCKEANCodeCharacterEncoding encoding = [self _codeVariantIndexForDigitAtIndex:index-1 withVariantPattern:variant_pattern];
		
		[tmpArray addObject:[BCKEANCodeCharacter codeCharacterForDigit:digit encoding:encoding]];
	}
	
	// end marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacterForUPCE]];
	
	return [tmpArray copy];
}

#pragma mark - Caption
- (NSString *)leftQuietZoneText
{
	return [self.content substringToIndex:1];
}

- (NSString *)rightQuietZoneText
{
	return [self.content substringFromIndex:7];
}

@end
