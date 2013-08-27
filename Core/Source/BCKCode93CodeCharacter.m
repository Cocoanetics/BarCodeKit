//
//  BCKCode93CodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93CodeCharacter.h"
#import "BCKCode93ContentCodeCharacter.h"

@implementation BCKCode93CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKCode93CodeCharacter *)startCodeCharacter;
{
	// an asterisk
	return [[BCKCode93CodeCharacter alloc] initWithBitString:@"101011110" isMarker:YES];
}

+ (BCKCode93CodeCharacter *)stopCodeCharacter;
{
	// an asterisk, for now this is identical as the start code character until I confirm the reverse stop code character is not used
	return [[BCKCode93CodeCharacter alloc] initWithBitString:@"101011110" isMarker:YES];
}

+ (BCKCode93CodeCharacter *)terminationBarCodeCharacter;
{
	// this is always a single bar, all content code characters always end with a space
	return [[BCKCode93CodeCharacter alloc] initWithBitString:@"1" isMarker:YES];
}

+ (BCKCode93CodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:character];
}

@end
