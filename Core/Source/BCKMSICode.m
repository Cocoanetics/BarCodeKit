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

@implementation BCKMSICode
{
	BCKMSICodeCheckDigitScheme _checkDigitScheme;
}

#pragma mark - Subclass Methods

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"MSI (Modified Plessey)";
}

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
    
    return [[BCKMSIContentCodeCharacter alloc] initWithCharacterValue:((weightedSum * 9) % 10)];
}

- (BCKMSIContentCodeCharacter *)_generateReverseModulo11:(NSArray *)contentCodeCharacters
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

	return [[BCKMSIContentCodeCharacter alloc] initWithCharacterValue:((11 - (weightedSum % 11))) % 11];
}

- (instancetype)initWithContent:(NSString *)content andCheckDigitScheme:(BCKMSICodeCheckDigitScheme)checkDigitScheme
{
    self = [super initWithContent:content];
	
	if (self)
	{
		_checkDigitScheme = checkDigitScheme;
		_content = [content copy];
	}
	
	return self;

}

- (BCKCode *)initWithContent:(NSString *)content
{
    return [self initWithContent:content andCheckDigitScheme:BCKMSINoCheckDigitScheme];
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
    BCKMSIContentCodeCharacter *tmpCharacter = nil;
	
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
    switch (_checkDigitScheme) {
        case BCKMSINoCheckDigitScheme:          // No check digit required
            break;
        case BCKMSICodeMod10CheckDigitScheme:
            [finalArray addObject:[self _generateUsingLuhnAlgorithm:contentCharacterArray]];
            break;
        case BCKMSICodeMod11CheckDigitScheme:
            [finalArray addObject:[self _generateReverseModulo11:contentCharacterArray]];
            break;
        case BCKMSICodeMod1010CheckDigitScheme:
            tmpCharacter = [self _generateUsingLuhnAlgorithm:contentCharacterArray];
            [contentCharacterArray addObject:tmpCharacter];
            [finalArray addObject:tmpCharacter];
            tmpCharacter = [self _generateUsingLuhnAlgorithm:contentCharacterArray];
            [finalArray addObject:tmpCharacter];
            break;
        case BCKMSICodeMod1110CheckDigitScheme:
            tmpCharacter = [self _generateReverseModulo11:contentCharacterArray];
            [contentCharacterArray addObject:tmpCharacter];
            [finalArray addObject:tmpCharacter];
            tmpCharacter = [self _generateUsingLuhnAlgorithm:contentCharacterArray];
            [finalArray addObject:tmpCharacter];
            break;
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

- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options
{
	return 10;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone
{
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
		return _content;
	}
	
	return nil;
}

- (UIFont *)_captionFontWithSize:(CGFloat)fontSize
{
	UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
	
	return font;
}

@end
