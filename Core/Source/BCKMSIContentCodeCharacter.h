//
//  BCKMSIContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 10/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKMSICodeCharacter.h"

/**
 Specialized class of BCKMSICodeCharacter used for generating MSI codes and representing content characters.
 */
@interface BCKMSIContentCodeCharacter : BCKMSICodeCharacter

/**
 Initialise a content code character using a character. Only supports numeric characters.
 @param character The character.
 @returns The content code character for the character.
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 Initialise a content code character using its character value.
 @param characterValue The character value to encode.
 @param isCheckDigit Whether the character is a check digit (`YES`) or a regular check digit (`NO`).
 @returns The content code character for the character value.
 */
- (instancetype)initWithCharacterValue:(NSUInteger)characterValue isCheckDigit:(BOOL)isCheckDigit;

/**
 Return a content code character's value. Only supports numeric characters.
 @returns The content code character's value.
 */
- (NSUInteger)characterValue;

/**
 The character encoded by the content code character.
 */
@property (nonatomic, readonly) NSString *character;

/**
 Whether the content code character is a check digit character.
 */
@property (nonatomic, readonly, getter = isCheckDigit) BOOL isCheckDigit;

@end
