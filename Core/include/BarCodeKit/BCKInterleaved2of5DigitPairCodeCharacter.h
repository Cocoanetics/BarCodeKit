//
//  BCKInterleaved2of5DigitPairCodeCharacter.h
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKInterleaved2of5CodeCharacter.h"

/**
 Specialized subclass of BCKInterleaved2of5CodeCharacter which represents two digits.
 */
@interface BCKInterleaved2of5DigitPairCodeCharacter : BCKInterleaved2of5CodeCharacter

/**
 Initialises the class with a pair of characters to be interleaved together.
 @param digit1 The first digit.
 @param digit2 The second digit.
 @returns The encoded digit code character.
 */
- (instancetype)initWithDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;

@end


