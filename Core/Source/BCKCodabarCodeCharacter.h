//
//  BCKCodabarCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Codabar code characters.
 */
@interface BCKCodabarCodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a Codabar start/stop code character. Supported start/stop characters are A, B, C, D, T, N, * and E. Does not count as a marker.
 @param character The start/stop code character.
 @returns the start/stop code character.
 */
+ (BCKCodabarCodeCharacter *)startStopCodeCharacter:(NSString *)character;

/**
 Generates a Codabar spacing code character. Does not count as a marker.
 @returns the spacing marker code character.
 */
+ (BCKCodabarCodeCharacter *)spacingCodeCharacter;

/**
 Generates a code character to represent a Codabar content character.
 @param character The character to encode.
 @returns The content code character for the character.
 */
+ (BCKCodabarCodeCharacter *)codeCharacterForCharacter:(NSString *)character;

/**
 Whether the code character is a start/stop character.
 */
@property (nonatomic, readonly, getter = isStartStop) BOOL isStartStop;

@end
