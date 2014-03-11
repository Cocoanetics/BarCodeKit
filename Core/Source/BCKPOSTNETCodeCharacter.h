//
//  BCKPOSTNETCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating POSTNET code characters.
 */
@interface BCKPOSTNETCodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a POSTNET frame bar code character. POSTNET frame bar code characters are not treated as markers.
 @returns The frame bar code character.
 */
+ (BCKPOSTNETCodeCharacter *)frameBarCodeCharacter;

/**
 Generates a POSTNET spacing code character. POSTNET spacing code characters are not treated as markers.
 @returns The spacing marker code character.
 */
+ (BCKPOSTNETCodeCharacter *)spacingCodeCharacter;

/**
 Generates a code character to represent a POSTNET content character.
 @param character The character to encode.
 @returns The content code character for the character.
 */
+ (BCKPOSTNETCodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
