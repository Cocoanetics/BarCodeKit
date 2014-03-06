//
//  BCKCode39CodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code39 code characters.
 */
@interface BCKCode39CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a Code39 end marker code character.
 @returns The end marker code character.
 */
+ (BCKCode39CodeCharacter *)endMarkerCodeCharacter;

/**
 Generates a Code39 spacing character. Code39 spacing characters are not treated as markers.
 @returns The spacing code character.
 */
+ (BCKCode39CodeCharacter *)spacingCodeCharacter;

/**
 Generates a code character to represent a Code39 content character.
 @param character The character to encode.
 @returns The content code character for the character.
 */
+ (BCKCode39CodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
