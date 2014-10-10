//
//  BCKCode93CodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93CodeCharacter.h"
#import "BCKCode93ContentCodeCharacter.h"
#import "BCKBarStringFunctions.h"

@implementation BCKCode93CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKCode93CodeCharacter *)startStopCodeCharacter;
{
	// An asterisk
	return [[BCKCode93CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"101011110") isMarker:YES];
}

+ (BCKCode93CodeCharacter *)terminationBarCodeCharacter;
{
	// This is always a single bar, all other (content) code characters always end with a space
	return [[BCKCode93CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1") isMarker:YES];
}

+ (BCKCode93CodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
    // Encode regular characters, only the 43 regular and 4 special characters are valid
    return [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:character];
}

@end
