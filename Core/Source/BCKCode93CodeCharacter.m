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
	// An asterisk
	return [[BCKCode93CodeCharacter alloc] initWithBitString:@"101011110" isMarker:YES];
}

+ (BCKCode93CodeCharacter *)stopCodeCharacter;
{
	// An asterisk, for now it is identical to the start code character until it is confirmed they are indeed always the same
	return [[BCKCode93CodeCharacter alloc] initWithBitString:@"101011110" isMarker:YES];
}

+ (BCKCode93CodeCharacter *)terminationBarCodeCharacter;
{
	// This is always a single bar, all other (content) code characters always end with a space
	return [[BCKCode93CodeCharacter alloc] initWithBitString:@"1" isMarker:YES];
}

+ (BCKCode93CodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:character];
}

@end
