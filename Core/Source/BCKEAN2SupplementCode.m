//
//  BCKEAN2SupplementCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN2SupplementCode.h"
#import "BCKGTINSupplementDataCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKEAN2SupplementCode

- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	// Prefix with a 0 if the content string only contains one character
	if (content.length < 2)
	{
		content = [@"0" stringByAppendingString:content];
	}
	
	return [super initWithContent:content error:error];
}

#pragma mark - Helper Methods

- (NSUInteger)digitAtIndex:(NSUInteger)index
{
	NSString *digitStr = [self.content substringWithRange:NSMakeRange(index, 1)];
    
	return [digitStr integerValue];
}

+ (void)_parityPatternForContent:(NSString *)content digitOneTable:(BCKGTINSupplementCodeCharacterEncoding *)digitOneTable digitTwoTable:(BCKGTINSupplementCodeCharacterEncoding *)digitTwoTable
{
    switch ([content integerValue] % 4)
	{
        case 0:
		{
            *digitOneTable = BCKGTINSupplementCodeCharacterEncoding_L;
            *digitTwoTable = BCKGTINSupplementCodeCharacterEncoding_L;
            break;
		}
			
        case 1:
		{
            *digitOneTable = BCKGTINSupplementCodeCharacterEncoding_L;
            *digitTwoTable = BCKGTINSupplementCodeCharacterEncoding_G;
            break;
		}
			
        case 2:
		{
            *digitOneTable = BCKGTINSupplementCodeCharacterEncoding_G;
            *digitTwoTable = BCKGTINSupplementCodeCharacterEncoding_L;
            break;
		}
			
        case 3:
		{
            *digitOneTable = BCKGTINSupplementCodeCharacterEncoding_G;
            *digitTwoTable = BCKGTINSupplementCodeCharacterEncoding_G;
            break;
		}
    }
}

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    BCKGTINSupplementCodeCharacterEncoding tableOne, tableTwo;
    BCKGTINSupplementCodeCharacter *codeCharacter;

    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	
	if (!([content rangeOfCharacterFromSet:notDigits].location == NSNotFound))
	{
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ does not support alpha-numeric characters", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."),  [[self class] barcodeDescription]];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return NO;
    }
    
    // Ensure there are always 2 digits
    content = [NSString stringWithFormat:@"%02ld", (long)[content integerValue]];
    
    if ([content integerValue] > 99 || [content integerValue] < 0)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ supports content equal or greater than 0 and less than 100", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."),  [[self class] barcodeDescription]];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return NO;
    }

    // Determine the parity pattern
    [self _parityPatternForContent:content digitOneTable:&tableOne digitTwoTable:&tableTwo];

    // Atttempt to encode each digit
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];

		codeCharacter = [[BCKGTINSupplementDataCodeCharacter alloc] initWithDigit:[character integerValue] encoding:tableOne];

		if (!codeCharacter)
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Digit at index %d '%@' cannot be encoded in %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}

        codeCharacter = [[BCKGTINSupplementDataCodeCharacter alloc] initWithDigit:[character integerValue] encoding:tableTwo];
		
		if (!codeCharacter)
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Digit at index %d '%@' cannot be encoded in %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
    }
	
	return YES;
}

+ (NSString *)barcodeStandard
{
	return @"International standard ISO/IEC 15420";
}

+ (NSString *)barcodeDescription
{
	return @"EAN-2 Supplement";
}

- (NSArray *)codeCharacters
{
    BCKGTINSupplementCodeCharacterEncoding tableOne, tableTwo;
	NSMutableArray *finalArray = [NSMutableArray array];

	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
    
    // Determine the parity pattern
    [[self class] _parityPatternForContent:_content digitOneTable:&tableOne digitTwoTable:&tableTwo];

	// Add the start code character
	[finalArray addObject:[BCKGTINSupplementCodeCharacter startCodeCharacter]];

    // Add the digit code character for the first digit
	[finalArray addObject:[BCKGTINSupplementDataCodeCharacter codeCharacterForDigit:[self digitAtIndex:0] encoding:tableOne]];
	
    // Add the separator code character
	[finalArray addObject:[BCKGTINSupplementCodeCharacter separatorCodeCharacter]];

    // Add the digit code character for the second digit
	[finalArray addObject:[BCKGTINSupplementDataCodeCharacter codeCharacterForDigit:[self digitAtIndex:1] encoding:tableTwo]];
    
	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

- (CGFloat)aspectRatio
{
	return .5;
}

@end
