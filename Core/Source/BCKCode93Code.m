//
//  BCKCode93Code.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93Code.h"
#import "BCKCode93CodeCharacter.h"

@implementation BCKCode93Code

#define FIRSTMODULO47MAXWEIGHT 20
#define SECONDMODULO47MAXWEIGHT 15

NSString * const BCKCode93Modulo47CheckCharacterFirstOption = @"BCKCode93Modulo47CheckCharacterFirst";
NSString * const BCKCode93Modulo47CheckCharacterSecondOption = @"BCKCode93Modulo47CheckCharacterSecond";

// Generate the modulo-47 check character "C" or "K"
-(BCKCode93ContentCodeCharacter *)_generateModulo47:(NSString*)checkCharacterOption forContentCodeCharacters:(NSArray*)contentCodeCharacters
{
    __block NSUInteger weightedSum = 0;
    __block NSUInteger weight = 1;
    
    if(![checkCharacterOption isEqualToString:BCKCode93Modulo47CheckCharacterFirstOption] && ![checkCharacterOption isEqualToString:BCKCode93Modulo47CheckCharacterSecondOption] )
        return nil;
    
    // Add the product of each content code character's value and their weights to the weighted sum.
    // Weights start at 1 from the rightmost content code character, increasing to 20 then starting from 1 again
    [contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKCode93ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
        
        weightedSum+=weight * [obj characterValue];
        weight++;
        
        if([checkCharacterOption isEqualToString:BCKCode93Modulo47CheckCharacterFirstOption])
        {
            if(weight>FIRSTMODULO47MAXWEIGHT)
                weight = 1;
        }
        else
        {
            if(weight>SECONDMODULO47MAXWEIGHT)
                weight = 1;
        }
    }];
    
    // Return the check character by taking the weightedsum modulo 47
    return [[BCKCode93ContentCodeCharacter alloc] initWithValue:(weightedSum % 47)];
}

#pragma mark - Subclass Methods

- (NSArray *)codeCharacters
{
	NSMutableArray *characterArray = [NSMutableArray array];
    NSMutableArray *finalArray = [NSMutableArray array];
    BCKCode93CodeCharacter *tmpCharacter = nil;
    
	// Add the start code character *
	[finalArray addObject:[BCKCode93CodeCharacter startCodeCharacter]];

	// Encode the barcode and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode93CodeCharacter *codeCharacter = [BCKCode93CodeCharacter codeCharacterForCharacter:character];
		[characterArray addObject:codeCharacter];
	}
    [finalArray addObjectsFromArray:characterArray];

    // Add the first modulo-47 check character "C"
    tmpCharacter = [self _generateModulo47:BCKCode93Modulo47CheckCharacterFirstOption forContentCodeCharacters:characterArray];
    [finalArray addObject:tmpCharacter];
    [characterArray addObject:tmpCharacter];

    // Add the second modulo-47 check character "K" (ensure to also provide the first mdulo-47 check character code "C")
    tmpCharacter = [self _generateModulo47:BCKCode93Modulo47CheckCharacterSecondOption forContentCodeCharacters:characterArray];
    [finalArray addObject:tmpCharacter];
    
	// Add the stop code character *
	[finalArray addObject:[BCKCode93CodeCharacter stopCodeCharacter]];

    // Add the termination bar
	[finalArray addObject:[BCKCode93CodeCharacter terminationBarCodeCharacter]];
    
	return [finalArray copy];
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 10;
}

- (CGFloat)aspectRatio
{
	return 0;  // do not use aspect
}

- (CGFloat)fixedHeight
{
	return 30;
}

- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options
{
	return 10;
}

- (BOOL)markerBarsCanOverlapBottomCaption
{
	return NO;
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

- (BOOL)allowsFillingOfEmptyQuietZones
{
	return NO;
}

@end
