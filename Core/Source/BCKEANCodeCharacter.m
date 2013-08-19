//
//  BCKEANCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEANCodeCharacter.h"
#import "BarCodeKit.h"

@implementation BCKEANCodeCharacter

+ (BCKEANCodeCharacter *)endMarkerCodeCharacter
{
	return [[BCKEANCodeCharacter alloc] initWithBitString:@"101" isMarker:YES];
}

+ (BCKEANCodeCharacter *)middleMarkerCodeCharacter
{
	return [[BCKEANCodeCharacter alloc] initWithBitString:@"01010" isMarker:YES];
}

+ (BCKEANCodeCharacter *)endMarkerCodeCharacterForUPCE
{
	return [[BCKEANCodeCharacter alloc] initWithBitString:@"010101" isMarker:YES];
}

+ (BCKEANCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEANCodeCharacterEncoding)encoding
{
	return [[BCKEANDigitCodeCharacter alloc] initWithDigit:digit encoding:encoding];
}

@end
