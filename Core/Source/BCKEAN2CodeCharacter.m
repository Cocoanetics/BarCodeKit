//
//  BCKEAN2CodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN2CodeCharacter.h"
#import "BCKEAN2DataCodeCharacter.h"

@implementation BCKEAN2CodeCharacter

+ (BCKEAN2CodeCharacter *)startCodeCharacter
{
	return [[BCKEAN2CodeCharacter alloc] initWithBitString:@"01011" isMarker:NO];
}

+ (BCKEAN2CodeCharacter *)separatorCodeCharacter
{
	return [[BCKEAN2CodeCharacter alloc] initWithBitString:@"01" isMarker:NO];
}

+ (BCKEAN2CodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEAN2CodeCharacterEncoding)encoding
{
	return [[BCKEAN2DataCodeCharacter alloc] initWithDigit:digit encoding:encoding];
}

@end
