//
//  BCKEAN5Code.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN5SupplementCode.h"
#import "BCKEAN5SupplementCodeCharacter.h"
#import "BCKEAN5SupplementDataCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKEAN5SupplementCode

#pragma mark - Helper Methods

+ (BCKEAN5SupplementCodeCharacterEncoding)_encodingAtIndex:(NSUInteger)index forParityPattern:(NSString *)parityPattern
{
	NSString *digitStr = [parityPattern substringWithRange:NSMakeRange(index, 1)];
    
    if ([digitStr isEqualToString:@"L"])
    {
        return BCKEAN5SupplementCodeCharacterEncoding_L;
    }
    else if ([digitStr isEqualToString:@"G"])
    {
        return BCKEAN5SupplementCodeCharacterEncoding_G;
    }
    
	return -1;
}

// Determine the parity pattern, which depends on the checksum digit
+ (NSString *)_parityPatternForChecksumDigit:(NSUInteger)checksumDigit
{
    switch (checksumDigit) {
        case 0:
            return @"GGLLL";
            break;
        case 1:
            return @"GLGLL";
            break;
        case 2:
            return @"GLLGL";
            break;
        case 3:
            return @"GLLLG";
            break;
        case 4:
            return @"LGGLL";
            break;
        case 5:
            return @"LLGGL";
            break;
        case 6:
            return @"LLLGG";
            break;
        case 7:
            return @"LGLGL";
            break;
        case 8:
            return @"LGLLG";
            break;
        case 9:
            return @"LLGLG";
            break;
    }
    
	return nil;
}

// Calculate the checksum digit for a content string
+ (NSUInteger)_checksumDigitForContent:(NSString *)content
{
	NSUInteger runningTotal = 0;
    
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
        
		if (index % 2 == 0)
		{
			runningTotal += [character integerValue] * 3;
		}
		else
		{
			runningTotal += [character integerValue] * 9;
		}
	}
    
	return (runningTotal % 10);
}

- (NSUInteger)_digitAtIndex:(NSUInteger)index
{
	NSString *digitStr = [self.content substringWithRange:NSMakeRange(index, 1)];

	return [digitStr integerValue];
}

#pragma mark - Subclass Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    BCKEAN5SupplementCodeCharacter *codeCharacter;
	NSUInteger checksumDigit;
	NSString *parityPattern;
    NSString *character;
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSCharacterSet *invalidFirstDigits;
	
    // Ensure there are always 5 digits
    if ([content length] != 5)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"%@ requires content strings with exactly 5 characters",  NSStringFromClass([self class])];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return NO;
    }
    
	// Ensure the first digit is always a 0, 1, 3, 4, 5 or 6
    invalidFirstDigits = [NSCharacterSet characterSetWithCharactersInString:@"2789"];
    character = [content substringWithRange:NSMakeRange(0, 1)];
    if (!([character rangeOfCharacterFromSet:invalidFirstDigits].location == NSNotFound)) {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"%@ requires the first digit to be a 0, 1, 3, 4, 5 or 6",  NSStringFromClass([self class])];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return NO;
    }

    // Ensure the content string only contains numeric characters
	if (!([content rangeOfCharacterFromSet:notDigits].location == NSNotFound))
	{
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"%@ does not support alpha-numeric characters",  NSStringFromClass([self class])];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return NO;
    }

    // Determine the check digit and parity pattern
    checksumDigit = [[self class] _checksumDigitForContent:content];
    parityPattern = [[self class] _parityPatternForChecksumDigit:checksumDigit];

    // Atttempt to encode each digit
	for (NSUInteger index=0; index<[content length]; index++)
	{
		character = [content substringWithRange:NSMakeRange(index, 1)];
        
		codeCharacter = [[BCKEAN5SupplementDataCodeCharacter alloc] initWithDigit:[character integerValue] encoding:[self _encodingAtIndex:index forParityPattern:parityPattern]];

		if (!codeCharacter)
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:@"Digit at index %d '%@' cannot be encoded in %@", (int)index, character, NSStringFromClass([self class])];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
    }
	
	return YES;
}

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"EAN 5 Supplement";
}

- (NSArray *)codeCharacters
{
	NSString *parityPattern;
	NSUInteger checksumDigit;
    BCKEAN5SupplementCodeCharacter *codeCharacter;
	NSMutableArray *finalArray = [NSMutableArray array];

	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}

	// Determine the check digit and with it the parity pattern
    checksumDigit = [[self class]_checksumDigitForContent:_content];
    parityPattern = [[self class] _parityPatternForChecksumDigit:checksumDigit];

	// Add the start code character
	[finalArray addObject:[BCKEAN5SupplementCodeCharacter startCodeCharacter]];

    for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
        
		codeCharacter = [[BCKEAN5SupplementDataCodeCharacter alloc] initWithDigit:[character integerValue] encoding:[[self class ]_encodingAtIndex:index forParityPattern:parityPattern]];

        [finalArray addObject:codeCharacter];
        
        if (index != 4)
        {
            // Add the separator code character except after the last digit character
            [finalArray addObject:[BCKEAN5SupplementCodeCharacter separatorCodeCharacter]];
        }
    }

	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

@end
