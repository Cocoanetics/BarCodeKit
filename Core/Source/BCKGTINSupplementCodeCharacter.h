//
//  BCKGTINSupplementCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 EAN-2/5 Supplement Character Encoding Types
 */
typedef NS_ENUM(NSUInteger, BCKGTINSupplementCodeCharacterEncoding)
{
	/**
	 The 'L' character encoding type
	 */
	BCKGTINSupplementCodeCharacterEncoding_L = 0,
    
	/**
	 The 'G' character encoding type
	 */
	BCKGTINSupplementCodeCharacterEncoding_G = 1
    
};

/**
 BCKCodeCharacter subclass used for GTIN Supplements.
 */
@interface BCKGTINSupplementCodeCharacter : BCKCodeCharacter

/**
 Generates an EAN-2/5 Supplement start code character.
 @returns The start code character.
 */
+ (BCKGTINSupplementCodeCharacter *)startCodeCharacter;

/**
 Generates an EAN-2/5 Supplement separator code character.
 @returns The separator code character.
 */
+ (BCKGTINSupplementCodeCharacter *)separatorCodeCharacter;

/**
 Generates a code character to represent a EAN-2/5 Supplement digit with a specific BCKGTINSupplementalCodeCharacterEncoding.
 @param digit The digit to encode.
 @param encoding The BCKGTINSupplementalCodeCharacterEncoding to use.
 @returns The digit code character.
 */
+ (BCKGTINSupplementCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKGTINSupplementCodeCharacterEncoding)encoding;

@end
