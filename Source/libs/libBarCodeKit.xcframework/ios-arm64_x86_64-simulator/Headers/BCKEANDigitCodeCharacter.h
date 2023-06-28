//
//  BCKEANNumberCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEANCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating UPC/EAN digit codes.
 */
@interface BCKEANDigitCodeCharacter : BCKEANCodeCharacter

- (instancetype)initWithDigit:(NSUInteger)digit encoding:(BCKEANCodeCharacterEncoding)encoding;

@property (nonatomic, readonly) NSUInteger digit;

@end
