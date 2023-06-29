//
//  BCKCode39ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39CodeCharacter.h"

/**
 Specialized class of BCKCode39CodeCharacter used for generating Code39 codes and representing content characters.
 */
@interface BCKCode39ContentCodeCharacter : BCKCode39CodeCharacter

/**
 Initialise a content code character using a character. Only supports the 43 regular characters and 7 special characters.
 @param character The character.
 @returns The content code character for the character.
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 Initialise a content code character using its character value. Only supports the 43 regular characters and 7 special characters.
 @param characterValue The character value.
 @returns The content code character for the character value.
 */
- (instancetype)initWithValue:(NSUInteger)characterValue;

/**
 Return a content code character's value. Only supports the 43 regular characters and 7 special characters.
 @returns The content code character's value.
 */
- (NSUInteger)characterValue;

@end
