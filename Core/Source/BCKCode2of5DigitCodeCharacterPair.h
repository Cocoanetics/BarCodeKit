//
//  BCKCode2of5DigitCodeCharacter.h
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode2of5CodeCharacterPair.h"

@interface BCKCode2of5DigitCodeCharacterPair : BCKCode2of5CodeCharacterPair

- (instancetype)initWithDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;

@end


