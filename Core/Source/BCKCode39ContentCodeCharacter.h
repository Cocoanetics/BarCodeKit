//
//  BCKCode39ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39CodeCharacter.h"

@interface BCKCode39ContentCodeCharacter : BCKCode39CodeCharacter

- (instancetype)initWithCharacter:(NSString *)character;


/**
 Initialise a content code character using its character value. Only supports the 43 regular characters and 7 special characters
 @returns the content code character
 */
- (instancetype)initWithValue:(NSUInteger)characterValue;

/**
 Return a content code character's value. Only supports the 43 regular characters and 7 special characters
 @returns the content code character's value
 */
- (NSUInteger)characterValue;

@end
