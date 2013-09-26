//
//  BCKEAN5SupplementCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <BarCodeKit/BarCodeKit.h>

/**
 EAN-5 Supplement Character Encoding Types
 */
typedef NS_ENUM(NSUInteger, BCKEAN5SupplementCodeCharacterEncoding)
{
	/**
	 The 'L' character encoding type
	 */
	BCKEAN5SupplementCodeCharacterEncoding_L = 0,
    
	/**
	 The 'G' character encoding type
	 */
	BCKEAN5SupplementCodeCharacterEncoding_G = 1
    
};

/**
 Specialized class of BCKCodeCharacter used for generating EAN-5 Supplement codes.
 */
@interface BCKEAN5SupplementCodeCharacter : BCKCodeCharacter

/**
 Generates an EAN-5 Supplement start code character.
 @returns the start code character
 */
+ (BCKEAN5SupplementCodeCharacter *)startCodeCharacter;

/**
 Generates an EAN-5 Supplement separator code character.
 @returns the separator code character
 */
+ (BCKEAN5SupplementCodeCharacter *)separatorCodeCharacter;

/**
 Generates a code character to represent a EAN-5  Supplement digit with a specific BCKEAN5SupplementCodeCharacterEncoding.
 @param digit The digit to encode.
 @param encoding The BCKEAN5SupplementCodeCharacterEncoding to use.
 @returns The digit code character.
 */
+ (BCKEAN5SupplementCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEAN5SupplementCodeCharacterEncoding)encoding;

@end
