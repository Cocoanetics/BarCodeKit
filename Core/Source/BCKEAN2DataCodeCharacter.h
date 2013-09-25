//
//  BCKEAN2DataCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN2CodeCharacter.h"

/**
 Specialized class of BCKEAN2CodeCharacter.h used for representing EAN-2  Supplement digit characters.
 */
@interface BCKEAN2DataCodeCharacter : BCKEAN2CodeCharacter

/**
 Generates a code character to represent a EAN-2 Supplement digit with a specific BCKEAN2CodeCharacterEncoding.
 @param digit The digit to encode.
 @param encoding The BCKEAN2CodeCharacterEncoding to use.
 @returns The digit code character.
 */
- (instancetype)initWithDigit:(NSUInteger)digit encoding:(BCKEAN2CodeCharacterEncoding)encoding;

@end
