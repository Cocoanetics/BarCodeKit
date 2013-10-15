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
 Generates a POSTNET frame bar code character.
 @returns the frame bar code character.
 */
+ (BCKPOSTNETCodeCharacter *)frameBarCodeCharacter;

/**
 Generates a POSTNET spacing code character. Does not count as a marker.
 @returns the spacing marker code character.
 */
+ (BCKPOSTNETCodeCharacter *)spacingCodeCharacter;

/**
 Generates a code character to represent a POSTNET content character.
 @param character The character to encode.
 @returns The content code character for the character.
 */
+ (BCKPOSTNETCodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
