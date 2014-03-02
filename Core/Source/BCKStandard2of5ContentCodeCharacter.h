//
//  BCKStandard2of5ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKStandard2of5CodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Standard 2 of 5 codes.
 */
@interface BCKStandard2of5ContentCodeCharacter : BCKStandard2of5CodeCharacter

/**
 Initialise a content code character using a character. Only supports numeric characters.
 @param character The character.
 @returns The content code character for the character.
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 Initialise a content code character using its character value.
 @param characterValue The character value to encode.
 @returns The content code character for the character value.
 */
- (instancetype)initWithCharacterValue:(NSUInteger)characterValue;

/**
 The value of the character encoded by the content code character.
 */
- (NSUInteger)characterValue;

@end
