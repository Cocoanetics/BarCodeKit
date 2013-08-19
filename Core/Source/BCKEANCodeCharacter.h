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


/**
 Specialized class of BCKCodeCharacter used for generating UPC/EAN codes
 */
@interface BCKEANCodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates an end marker code character, used for EAN-13 and EAN-8
 @returns the end marker code character
 */
+ (BCKEANCodeCharacter *)endMarkerCodeCharacter;

/**
 Generates an end marker code character, used for UPC-E
 @returns the end marker code character
 */
+ (BCKEANCodeCharacter *)endMarkerCodeCharacterForUPCE;

/**
 Generates a middle marker code character, used for EAN-13
 @returns the middle marker code character
 */
+ (BCKEANCodeCharacter *)middleMarkerCodeCharacter;

/**
 Generates a code character to represent a digit with a specific BCKEANCodeCharacterEncoding
 @param digit The digit to encode
 @param encoding The BCKEANCodeCharacterEncoding to use
 @returns The digit code character
 */
+ (BCKEANCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEANCodeCharacterEncoding)encoding;

@end
