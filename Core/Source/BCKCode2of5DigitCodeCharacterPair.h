//
//  BCKCode2of5DigitCodeCharacter.h
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode2of5CodeCharacterPair.h"

@interface BCKCode2of5DigitCodeCharacterPair : BCKCode2of5CodeCharacterPair

/**
 Initialises the class with a par of characters to be interleaved together.
 @param digit1 The first digit
 @param digit2 The second digit
 */

- (instancetype)initWithDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;

@end


