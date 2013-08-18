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
	return [[BCKEANEndMarkerCodeCharacter alloc] init];
}

+ (BCKEANCodeCharacter *)endMarkerCodeCharacterForUPCE
{
	return [[BCKUPCEEndMarkerCodeCharacter alloc] init];
}

+ (BCKEANCodeCharacter *)middleMarkerCodeCharacter
{
	return [[BCKEANMiddleMarkerCodeCharacter alloc] init];
}

+ (BCKEANCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEANCodeCharacterEncoding)encoding
{
	return [[BCKEANDigitCodeCharacter alloc] initWithDigit:digit encoding:encoding];
}

@end
