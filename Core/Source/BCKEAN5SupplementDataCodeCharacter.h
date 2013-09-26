//
//  BCKEAN5SupplementDataCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN5SupplementCodeCharacter.h"

/**
 Specialized class of BCKEAN5SupplementCodeCharacter.h used for representing EAN-5 Supplement digit characters.
 */
@interface BCKEAN5SupplementDataCodeCharacter : BCKEAN5SupplementCodeCharacter

/**
 Generates a code character to represent a EAN-5 Supplement digit with a specific BCKEAN5SupplementCodeCharacterEncoding.
 @param digit The digit to encode.
 @param encoding The BCKEAN5SupplementCodeCharacterEncoding to use.
 @returns The digit code character.
 */
- (instancetype)initWithDigit:(NSUInteger)digit encoding:(BCKEAN5SupplementCodeCharacterEncoding)encoding;

@end
