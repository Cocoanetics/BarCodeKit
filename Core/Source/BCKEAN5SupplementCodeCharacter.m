//
//  BCKEAN5SupplementCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN5SupplementCodeCharacter.h"
#import "BCKEAN5SupplementDataCodeCharacter.h"

@implementation BCKEAN5SupplementCodeCharacter

+ (BCKEAN5SupplementCodeCharacter *)startCodeCharacter
{
	return [[BCKEAN5SupplementCodeCharacter alloc] initWithBitString:@"01011" isMarker:NO];
}

+ (BCKEAN5SupplementCodeCharacter *)separatorCodeCharacter
{
	return [[BCKEAN5SupplementCodeCharacter alloc] initWithBitString:@"01" isMarker:NO];
}

+ (BCKEAN5SupplementCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEAN5SupplementCodeCharacterEncoding)encoding
{
	return [[BCKEAN5SupplementDataCodeCharacter alloc] initWithDigit:digit encoding:encoding];
}

@end
