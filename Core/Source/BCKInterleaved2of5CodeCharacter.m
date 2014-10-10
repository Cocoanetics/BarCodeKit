//
//  BCKInterleaved2of5CodeCharacter.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKInterleaved2of5CodeCharacter.h"
#import "BCKInterleaved2of5DigitPairCodeCharacter.h"

@implementation BCKInterleaved2of5CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKInterleaved2of5CodeCharacter *)startMarkerCodeCharacter
{
	// bwbw
	return [[BCKInterleaved2of5CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1010") isMarker:YES];
}

+ (BCKInterleaved2of5CodeCharacter *)endMarkerCodeCharacter
{
	// Bwb
    return [[BCKInterleaved2of5CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1101") isMarker:YES];
}


+ (BCKInterleaved2of5CodeCharacter *)codeCharacterForDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;
{
	return [[BCKInterleaved2of5DigitPairCodeCharacter alloc] initWithDigitCharacter1:digit1 andDigitCharacter2:digit2];
}


@end
