//
//  BCKCode11ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode11CodeCharacter.h"

/**
 Specialized class of BCKCode11CodeCharacter used for generating Code11 codes and representing content characters.
 */
@interface BCKCode11ContentCodeCharacter : BCKCode11CodeCharacter

/**
 Initialise a Code11 content code character using a character. Only supports the 10 numeric characters and the dash character ('-').
 @param character The character.
@returns The content code character for the character.
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 Initialise a Code11 content code character using its character value. Only supports the 10 numeric characters and the dash character ('-').
 @param characterValue The character value.
@returns The content code character for the character value.
 */
- (instancetype)initWithCharacterValue:(NSUInteger)characterValue;

/**
 Return a content code character's value. Only supports the 10 numeric characters and the dash character.
 @returns The content code character's value.
 */
- (NSUInteger)characterValue;

@end