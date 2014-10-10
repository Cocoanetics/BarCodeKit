//
//  BCKCode93CodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code93 barcodes.
 */
@interface BCKCode93CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a Code93 start/stop code character.
 @returns The start/stop code character.
 */
+ (BCKCode93CodeCharacter *)startStopCodeCharacter;

/**
 Generates a Code93 termination bar code character. The termination bar is always the last code character of an encoded Code93 barcode.
 @returns The termination bar code character.
 */
+ (BCKCode93CodeCharacter *)terminationBarCodeCharacter;

/**
 Generates a Code93 code character to represent a content character. Valid content characters are 26 upper case letters, 10 digits, 7 special characters and 4 control characters.
 @param character The character to encode.
 @returns The content code character for the character.
 */
+ (BCKCode93CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
