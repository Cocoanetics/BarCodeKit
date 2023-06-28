//
//  BCKStandard2of5CodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Standard/Industrial 2 of 5 codes.
 */
@interface BCKStandard2of5CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a Standard/Industrial 2 of 5 start marker code character.
 @returns The start marker code character.
 */
+ (BCKStandard2of5CodeCharacter *)startMarkerCodeCharacter;

/**
 Generates a Standard/Industrial 2 of 5 spacing character. Spacing characters are not treated as a marker.
 @returns The spacing code character.
 */
+ (BCKStandard2of5CodeCharacter *)spacingCodeCharacter;

/**
 Generates a Standard/Industrial 2 of 5 stop marker code character.
 @returns The stop marker code character.
 */
+ (BCKStandard2of5CodeCharacter *)stopMarkerCodeCharacter;

/**
 Generates a code character to represent a Standard/Industrial 2 of 5 content character. Only supports numeric characters.
 @param character The character to encode.
 @returns The content code character for the character.
 */
+ (BCKStandard2of5CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
