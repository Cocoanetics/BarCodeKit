//
//  BCKCode2of5CodeCharacter.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode2of5CodeCharacterPair.h"
#import "BCKCode2of5DigitCodeCharacterPair.h"

@implementation BCKCode2of5CodeCharacterPair

#pragma mark - Generating Special Characters

+ (BCKCode2of5CodeCharacterPair *)startMarkerCodeCharacter
{
	// bwbw
	return [[BCKCode2of5CodeCharacterPair alloc] initWithBitString:@"1010" isMarker:NO];
}

+ (BCKCode2of5CodeCharacterPair *)endMarkerCodeCharacter
{
	// Bwb
    return [[BCKCode2of5CodeCharacterPair alloc] initWithBitString:@"1101" isMarker:NO];
}


+ (BCKCode2of5CodeCharacterPair *)codeCharacterForDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;
{
	return [[BCKCode2of5DigitCodeCharacterPair alloc] initWithDigitCharacter1:digit1 andDigitCharacter2:digit2];
}


@end
