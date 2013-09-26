//
//  BCKEAN2Code.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN2SupplementCode.h"
#import "BCKEAN2CodeCharacter.h"
#import "BCKEAN2DataCodeCharacter.h"
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

- (NSUInteger)_digitAtIndex:(NSUInteger)index
{
	NSString *digitStr = [self.content substringWithRange:NSMakeRange(index, 1)];

	return [digitStr integerValue];
}

#pragma mark - Subclass Methods

+ (void)_parityPatternForContent:(NSString *)content digitOneTable:(BCKEAN2CodeCharacterEncoding *)digitOneTable digitTwoTable:(BCKEAN2CodeCharacterEncoding *)digitTwoTable
{
    switch ([content integerValue] % 4)
	{
        case 0:
		{
            *digitOneTable = BCKEAN2CodeCharacterEncoding_L;
            *digitTwoTable = BCKEAN2CodeCharacterEncoding_L;
            break;
		}
			
        case 1:
		{
            *digitOneTable = BCKEAN2CodeCharacterEncoding_L;
            *digitTwoTable = BCKEAN2CodeCharacterEncoding_G;
            break;
		}
			
        case 2:
		{
            *digitOneTable = BCKEAN2CodeCharacterEncoding_G;
            *digitTwoTable = BCKEAN2CodeCharacterEncoding_L;
            break;
		}
			
        case 3:
		{
            *digitOneTable = BCKEAN2CodeCharacterEncoding_G;
            *digitTwoTable = BCKEAN2CodeCharacterEncoding_G;
            break;
		}
    }
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    BCKEAN2CodeCharacterEncoding tableOne, tableTwo;
    BCKEAN2CodeCharacter *codeCharacter;

    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	
	if (!([content rangeOfCharacterFromSet:notDigits].location == NSNotFound))
	{
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"%@ does not support alpha-numeric characters",  NSStringFromClass([self class])];
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
            NSString *message = [NSString stringWithFormat:@"%@ supports content equal or greater than 0 and less than 100",  NSStringFromClass([self class])];
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

		codeCharacter = [[BCKEAN2DataCodeCharacter alloc] initWithDigit:[character integerValue] encoding:tableOne];

		if (!codeCharacter)
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:@"Digit at index %d '%@' cannot be encoded in %@", (int)index, character, NSStringFromClass([self class])];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}

        codeCharacter = [[BCKEAN2DataCodeCharacter alloc] initWithDigit:[character integerValue] encoding:tableTwo];
		
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
	return @"EAN 2 Supplement";
}

- (BOOL)requiresCaptionText
{
    return NO;
    
}

- (NSArray *)codeCharacters
{
    BCKEAN2CodeCharacterEncoding tableOne, tableTwo;
	NSMutableArray *finalArray = [NSMutableArray array];

	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
    
    // Determine the parity pattern
    [[self class] _parityPatternForContent:_content digitOneTable:&tableOne digitTwoTable:&tableTwo];

	// Add the start code character
	[finalArray addObject:[BCKEAN2CodeCharacter startCodeCharacter]];

    // Add the digit code character for the first digit
	[finalArray addObject:[BCKEAN2DataCodeCharacter codeCharacterForDigit:[self _digitAtIndex:0] encoding:tableOne]];
	
    // Add the separator code character
	[finalArray addObject:[BCKEAN2CodeCharacter separatorCodeCharacter]];

    // Add the digit code character for the second digit
	[finalArray addObject:[BCKEAN2DataCodeCharacter codeCharacterForDigit:[self _digitAtIndex:1] encoding:tableTwo]];
    
	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

@end
