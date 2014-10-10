//
//  BCKMSICode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 10/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKMSICode.h"
#import "BCKMSICodeCharacter.h"
#import "BCKMSIContentCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKMSICode
{
	BCKMSICodeCheckDigitScheme _checkDigitScheme;
}

#pragma mark - Helper Methods

// Create the check digit using Luhn's algorithm (aka Mod 10)
- (BCKMSIContentCodeCharacter *)_generateUsingLuhnAlgorithm:(NSArray *)contentCodeCharacters
{
	__block NSUInteger weightedSum = 0;
    __block NSUInteger counter = 0;
    
	[contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKMSIContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
		
        NSUInteger charValue;
        
        if((counter % 2) != 0)
        {
            charValue = [obj characterValue];
        }
        else
        {
            charValue = [obj characterValue] * 2;
            if (charValue > 9)
            {
                charValue = (charValue % 10) + 1;
            }
        }
		
        counter++;
		weightedSum+=charValue;
    }];
    
    return [[BCKMSIContentCodeCharacter alloc] initWithCharacterValue:((weightedSum * 9) % 10) isCheckDigit:YES];
}

// Create the check digit using the reverse module 11 algorithm (aka Mod 11)
- (BCKMSIContentCodeCharacter *)_generateUsingReverseModulo11:(NSArray *)contentCodeCharacters
{
	__block NSUInteger weightedSum = 0;
	__block NSUInteger weight = 2;
    
	[contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKMSIContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
		
		weightedSum+=weight * [obj characterValue];
		weight++;
        
        if (weight>7)
        {
            weight = 2;
        }
    }];
	
	return [[BCKMSIContentCodeCharacter alloc] initWithCharacterValue:((11 - (weightedSum % 11))) % 11 isCheckDigit:YES];
}

- (instancetype)initWithContent:(NSString *)content andCheckDigitScheme:(BCKMSICodeCheckDigitScheme)checkDigitScheme error:(NSError**)error
{
    self = [super initWithContent:content error:error];

	if (self)
	{
		_checkDigitScheme = checkDigitScheme;
	}
	
	return self;
}

// Default to the most common check digit scheme: BCKMSICodeMod10CheckDigitScheme
- (BCKCode *)initWithContent:(NSString *)content error:(NSError**)error
{
    return [self initWithContent:content andCheckDigitScheme:BCKMSICodeMod10CheckDigitScheme error:error];
}

#pragma mark - BCKCoding Methods

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"MSI (Modified Plessey)";
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error
{
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		BCKMSICodeCharacter *codeCharacter = [[BCKMSIContentCodeCharacter alloc] initWithCharacter:character];

		if (!codeCharacter)
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Character at index %d '%@' cannot be encoded in %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
            
			return NO;
		}
	}
	
	return YES;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
    
	// Array that holds all code characters, including start/stop, spacing, modulo-11 check digits
	NSMutableArray *finalArray = [NSMutableArray array];
	NSMutableArray *contentCharacterArray = [NSMutableArray array]; // Holds the code characters for just the content
    BCKMSICodeCharacter *tmpCharacter = nil;
	
	// Add the start code character
	[finalArray addObject:[BCKMSICodeCharacter startMarkerCodeCharacter]];
    
	// Encode the barcode's content and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKMSICodeCharacter *codeCharacter = [BCKMSICodeCharacter codeCharacterForCharacter:character];
        
		[finalArray addObject:codeCharacter];
        [contentCharacterArray addObject:codeCharacter];
    }
    
    // Add the requested check digit
    switch (_checkDigitScheme)
	{
        case BCKMSINoCheckDigitScheme:
		{
			// No check digit required
            break;
		}
			
        case BCKMSICodeMod10CheckDigitScheme:
		{
            [finalArray addObject:[self _generateUsingLuhnAlgorithm:contentCharacterArray]];
            break;
		}
			
        case BCKMSICodeMod11CheckDigitScheme:
		{
            [finalArray addObject:[self _generateUsingReverseModulo11:contentCharacterArray]];
            break;
		}
			
        case BCKMSICodeMod1010CheckDigitScheme:
		{
            tmpCharacter = [self _generateUsingLuhnAlgorithm:contentCharacterArray];
            [contentCharacterArray addObject:tmpCharacter];
            [finalArray addObject:tmpCharacter];
            tmpCharacter = [self _generateUsingLuhnAlgorithm:contentCharacterArray];
            [finalArray addObject:tmpCharacter];
            break;
		}
			
        case BCKMSICodeMod1110CheckDigitScheme:
		{
            tmpCharacter = [self _generateUsingReverseModulo11:contentCharacterArray];
            [contentCharacterArray addObject:tmpCharacter];
            [finalArray addObject:tmpCharacter];
            tmpCharacter = [self _generateUsingLuhnAlgorithm:contentCharacterArray];
            [finalArray addObject:tmpCharacter];
            break;
		}
    }
    
	// Add the stop code character
	[finalArray addObject:[BCKMSICodeCharacter stopMarkerCodeCharacter]];
	
	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

// The horizontal quiet zone width (starting and trailing) should be at least 6.35mm. With an X-dimension of 0.19mm this equals 34 bars (rounded up)
- (NSUInteger)horizontalQuietZoneWidth
{
	return 17;
}

- (CGFloat)aspectRatio
{
	return 0;
}

// The bar height should be at least 15% of the symbol (barcode) lenght, or 6.35mm (34 bars), whichever is greater. Returning a fixed height of 34 for now.
- (CGFloat)fixedHeight
{
	return 34;
}

- (BOOL)_shouldShowCheckDigitsFromOptions:(NSDictionary *)options
{
	NSNumber *num = [options objectForKey:BCKCodeDrawingShowCheckDigitsOption];
	
	if (num)
	{
		return [num boolValue];
	}
	else
	{
		return 0;  // default
	}
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
    BCKMSIContentCodeCharacter *tmpCharacter = nil;
    NSUInteger numCodeCharacters = 0;
    NSString *tmpContent;

	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
        // Return a copy of _content and add the check digit(s) depending on which scheme is in use
        if ([self _shouldShowCheckDigitsFromOptions:options])
        {
            numCodeCharacters = [self.codeCharacters count];

            switch (_checkDigitScheme)
            {
                case BCKMSINoCheckDigitScheme:
                {
                    // Nothing to do because there are no check digits
                    break;
                }
                    
                case BCKMSICodeMod10CheckDigitScheme:
                case BCKMSICodeMod11CheckDigitScheme:
                {
                    tmpCharacter = self.codeCharacters[numCodeCharacters - 2];
                    tmpContent = [_content stringByAppendingString:tmpCharacter.character];
                    break;
                }
                    
                case BCKMSICodeMod1010CheckDigitScheme:
                case BCKMSICodeMod1110CheckDigitScheme:
                {
                    tmpCharacter = self.codeCharacters[numCodeCharacters - 3];
                    tmpContent = [_content stringByAppendingString:tmpCharacter.character];
                    tmpCharacter = self.codeCharacters[numCodeCharacters - 2];
                    tmpContent = [tmpContent stringByAppendingString:tmpCharacter.character];
                    break;
                }
            }
            
            return tmpContent;
        }
        // Check digits are not to be shown so return the content string as provided to the subclass
        else
        {
            return _content;
        }
	}
	
	return nil;
    
}

- (BOOL)showCheckDigitsInCaption
{
    return YES;
}

@end
