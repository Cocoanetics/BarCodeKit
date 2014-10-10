//
//  BCKCode11Code.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode11Code.h"
#import "BCKCode11CodeCharacter.h"
#import "BCKCode11ContentCodeCharacter.h"
#import "NSError+BCKCode.h"


@implementation BCKCode11Code

#define FIRSTMODULO11MAXWEIGHT 10       // the weight ranges from 1 to 10 for the first modulo-11 check
#define SECONDMODULO11MAXWEIGHT 9       // the weight ranges from 1 to 9 for the second modulo-11 check

// Pass the appropriate option to generate the first or second modulo-11 check character
NSString * const BCKCode11Modulo11CheckCharacterFirstOption = @"BCKCode11Modulo11CheckCharacterFirst";
NSString * const BCKCode11Modulo11CheckCharacterSecondOption = @"BCKCode11Modulo11CheckCharacterSecond";

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		BCKCode11CodeCharacter *codeCharacter = [[BCKCode11ContentCodeCharacter alloc] initWithCharacter:character];
		
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

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"Code 11";
}

// Generate the modulo-11 check character "C" (first) or "K" (second)
- (BCKCode11ContentCodeCharacter *)_generateModulo11:(NSString *)checkCharacterOption forContentCodeCharacters:(NSArray *)contentCodeCharacters
{
	__block NSUInteger weightedSum = 0;
	__block NSUInteger weight = 1;
	
	if (![checkCharacterOption isEqualToString:BCKCode11Modulo11CheckCharacterFirstOption] && ![checkCharacterOption isEqualToString:BCKCode11Modulo11CheckCharacterSecondOption])
	{
		return nil;
	}
    
	// Add the product of each content code character's value and their weights to the weighted sum.
	// Weights start at 1 from the rightmost content code character, increasing to a maximum depending on whether the "C" or "K" check is being generated, then starting from 1 again
	[contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKCode11ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
		
		weightedSum+=weight * [obj characterValue];
		weight++;

        if ([checkCharacterOption isEqualToString:BCKCode11Modulo11CheckCharacterFirstOption])
		{
			if (weight>FIRSTMODULO11MAXWEIGHT)
			{
				weight = 1;
			}
		}
		else
		{
			if (weight>SECONDMODULO11MAXWEIGHT)
			{
				weight = 1;
			}
		}
    }];
	
	// Return the check character by taking the weighted sum modulo 11
	return [[BCKCode11ContentCodeCharacter alloc] initWithCharacterValue:(weightedSum % 11)];
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
	BCKCode11CodeCharacter *tmpCharacter = nil;
	
	// Add the start code character *
	[finalArray addObject:[BCKCode11CodeCharacter endMarkerCodeCharacter]];

	// Encode the barcode's content and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
        // space
        [finalArray addObject:[BCKCode11CodeCharacter spacingCodeCharacter]];

		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode11CodeCharacter *codeCharacter = [BCKCode11CodeCharacter codeCharacterForCharacter:character];

		[finalArray addObject:codeCharacter];
        [contentCharacterArray addObject:codeCharacter];
    }

    // space
    [finalArray addObject:[BCKCode11CodeCharacter spacingCodeCharacter]];

	// Add the first modulo-11 check digit "C" to the contentCharacterArray and the finalArray
	tmpCharacter = [self _generateModulo11:BCKCode11Modulo11CheckCharacterFirstOption forContentCodeCharacters:contentCharacterArray];
	[finalArray addObject:tmpCharacter];
	[contentCharacterArray addObject:tmpCharacter];

    // space
    [finalArray addObject:[BCKCode11CodeCharacter spacingCodeCharacter]];

    // Add the second modulo-11 check digit "K" (include the first modulo-11 check character code "C") if the barcode is longer than 9 digits
    if ([_content length] >= 10)
    {
        tmpCharacter = [self _generateModulo11:BCKCode11Modulo11CheckCharacterSecondOption forContentCodeCharacters:contentCharacterArray];
        [finalArray addObject:tmpCharacter];
        
        // space
        [finalArray addObject:[BCKCode11CodeCharacter spacingCodeCharacter]];
    }
	
	// Add the stop code character
	[finalArray addObject:[BCKCode11CodeCharacter endMarkerCodeCharacter]];
	
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

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
		return _content;
	}
	
	return nil;
}

@end
