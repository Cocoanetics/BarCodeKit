//
//  BCKEANCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

typedef NS_ENUM(NSUInteger, BCKEANCodeCharacterEncoding)
{
	BCKEANCodeCharacterEncoding_L = 0,
	BCKEANCodeCharacterEncoding_G = 1,
	BCKEANCodeCharacterEncoding_R = 2
};

@interface BCKEANCodeCharacter : BCKCodeCharacter

+ (BCKEANCodeCharacter *)endMarkerCodeCharacter;
+ (BCKEANCodeCharacter *)endMarkerCodeCharacterForUPCE;

+ (BCKEANCodeCharacter *)middleMarkerCodeCharacter;

+ (BCKEANCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEANCodeCharacterEncoding)encoding;

@end
