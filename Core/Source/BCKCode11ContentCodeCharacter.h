//
//  BCKCode11ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode11CodeCharacter.h"

/**
 Specialized class of BCKCode11CodeCharacter used for generating Code11 codes and representing content characters
 */
@interface BCKCode11ContentCodeCharacter : BCKCode11CodeCharacter

- (instancetype)initWithCharacter:(NSString *)character;


/**
 Initialise a content code character using its character value. Only supports numeric characters and the dash character
 @param characterValue The character value
 @returns the content code character
 */
- (instancetype)initWithValue:(NSUInteger)characterValue;

/**
 Return a content code character's value. Only supports numeric characters and the dash character
 @returns the content code character's value
 */
- (NSUInteger)characterValue;

@end