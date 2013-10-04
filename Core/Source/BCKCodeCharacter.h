//
//  BCKCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 Root class representing a code character. Can be marker, spacing, start/stop, check digits or characters.
 */

@interface BCKCodeCharacter : NSObject

/**
 @name Creating Characters
 */

/**
 Creates a new character with a given bit string and whether it is a marker character.
 @param bitString The bit string containing ones and zeroes as `NSString` that encode the character.
 @param isMarker Whether the character acts as a marker or a regular character.
*/
- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker;

/**
 @name Enumerating Bits
 */

/**
 Enumerates the bits of the character's bit string from left to right.
 @param block The enumeration block that gets executed for each bit
 */
- (void)enumerateBitsUsingBlock:(void (^)(BOOL isBar, NSUInteger idx, BOOL *stop))block;

/**
 @name Getting Information about Code Characters
 */

/**
 Whether the receiver is a marker character (as opposed to being a digit or letter).
 */
@property (nonatomic, readonly, getter = isMarker) BOOL marker;

/**
 The bit string representing the character.
 */
@property (nonatomic, readonly) NSString *bitString;

@end
