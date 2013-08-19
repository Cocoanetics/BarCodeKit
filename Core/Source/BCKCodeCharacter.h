//
//  BCKCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 Root class representing a code character, that is either a marker or content (character/digit) character
 */

@interface BCKCodeCharacter : NSObject

/**
 @name Creating Characters
 */

/**
 Creates a new character with a given bit string and wheter it is a marker character
 @param bitString The bit string as `NSString` to make up the character
 @param isMarker Whether the character acts as a marker or content
*/
- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker;

/**
 @name Enumerating Bits
 */

/**
 Enumerates the bits of the character from left to right
 @param block The enumeration block that gets executed for each bit
 */
- (void)enumerateBitsUsingBlock:(void (^)(BOOL isBar, NSUInteger idx, BOOL *stop))block;

/**
 @name Getting Information about Code Characters
 */

/**
 Whether the receiver is a marker character (as opposed to being a digit or letter)
 */
@property (nonatomic, readonly, getter = isMarker) BOOL marker;

/**
 The bit string representing the receiver
 */
@property (nonatomic, readonly) NSString *bitString;

@end
