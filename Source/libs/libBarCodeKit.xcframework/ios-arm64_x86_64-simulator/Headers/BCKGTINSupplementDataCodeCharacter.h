//
//  BCKGTINSupplementDataCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKGTINSupplementCodeCharacter.h"

/**
 Specialized class of BCKGTINSupplementCodeCharacter used for representing EAN-2/5 Supplement digit characters.
 */
@interface BCKGTINSupplementDataCodeCharacter : BCKGTINSupplementCodeCharacter

/**
 Generates a code character to represent a EAN-2/5 Supplement digit with a specific BCKGTINSupplementCodeCharacterEncoding.
 @param digit The digit to encode.
 @param encoding The BCKGTINSupplementCodeCharacterEncoding to use.
 @returns The digit code character.
 */
- (instancetype)initWithDigit:(NSUInteger)digit encoding:(BCKGTINSupplementCodeCharacterEncoding)encoding;

@end
