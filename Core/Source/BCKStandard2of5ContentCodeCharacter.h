//
//  BCKStandard2of5ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKStandard2of5CodeCharacter.h"

@interface BCKStandard2of5ContentCodeCharacter : BCKStandard2of5CodeCharacter

/**
 Initialise a content code character using a character. Only supports numeric characters
 @param character The character
 @returns the content code character
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 Initialise a content code character using its character value.
 @param characterValue The character value to encode
 @returns the content code character
 */
- (instancetype)initWithCharacterValue:(NSUInteger)characterValue;

/**
 Return a content code character's value. Only supports numeric characters
 @returns the content code character's value
 */
- (NSUInteger)characterValue;

@end
