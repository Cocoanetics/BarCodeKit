//
//  BCKEAN2CodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <BarCodeKit/BarCodeKit.h>

/**
 EAN-2 Supplement Character Encoding Types
 */
typedef NS_ENUM(NSUInteger, BCKEAN2CodeCharacterEncoding)
{
	/**
	 The 'L' character encoding type
	 */
	BCKEAN2CodeCharacterEncoding_L = 0,
    
	/**
	 The 'G' character encoding type
	 */
	BCKEAN2CodeCharacterEncoding_G = 1
    
};

/**
 Specialized class of BCKCodeCharacter used for generating EAN-2  Supplement codes
 */
@interface BCKEAN2CodeCharacter : BCKCodeCharacter

/**
 Generates an EAN-2  Supplement start code character.
 @returns the start code character
 */
+ (BCKEAN2CodeCharacter *)startCodeCharacter;

/**
 Generates an EAN-2  Supplement separator code character.
 @returns the separator code character
 */
+ (BCKEAN2CodeCharacter *)separatorCodeCharacter;

/**
 Generates a code character to represent a EAN-2  Supplement digit with a specific BCKEAN2CodeCharacterEncoding.
 @param digit The digit to encode.
 @param encoding The BCKEAN2CodeCharacterEncoding to use.
 @returns The digit code character.
 */
+ (BCKEAN2CodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEAN2CodeCharacterEncoding)encoding;

@end
