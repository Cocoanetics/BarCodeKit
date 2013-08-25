//
//  BCKCode128ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128CodeCharacter.h"

@interface BCKCode128ContentCodeCharacter : BCKCode128CodeCharacter

- (instancetype)initWithCharacter:(NSString *)character;

/**
 Returns given characters position in Code 128 table
 @returns the position of character
 */
- (NSUInteger)position;

/**
 Returns binary string for character at given position in Code 128 table
 @returns the binary string of character at given position
 */
+ (NSString *)binaryStringAtPosition:(NSUInteger)position;

@end
