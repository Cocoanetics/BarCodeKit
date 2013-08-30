//
//  BCKCode93CodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code93 barcodes
 */
@interface BCKCode93CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a Code93 start/stop code character.
 @returns the start/stop code character
 */
+ (BCKCode93CodeCharacter *)startStopCodeCharacter;

/**
 Generates a Code93 termination bar code character. The termination bar is always the last code character of an encoded Code93 barcode.
 @returns the termination bar code character
 */
+ (BCKCode93CodeCharacter *)terminationBarCodeCharacter;

/**
 Generates a code character to represent a content character. Valid content characters are 26 upper case letters, 10 digits, 7 special characters and 4 special characters. The start/stop code character is initialised using startStopCodeCharacter.
 @param character The character to encode
 @returns The content code character
 */
+ (BCKCode93CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
