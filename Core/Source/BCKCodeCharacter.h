//
//  BCKCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarString.h"

/**
 Root class representing a code character. Can be marker, spacing, start/stop, check digits or characters.
 */

@interface BCKCodeCharacter : NSObject

/**
 @name Creating Characters
 */

/**
 Creates a new character with a given bit string and whether it is a marker character.
 @warning This method is deprecated, use - [BCKCodeCharacter initWithBars:isMarker:] instead.
 @param bitString The bit string containing ones and zeroes as `NSString` that encode the character.
 @param isMarker Whether the character acts as a marker or a regular character.
*/
- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker __attribute((deprecated("use initWithBars:isMarker: instead")));

/**
 Creates a new character with an array of given bars and whether it is a marker character.
 @param barArray The array containing bar types.
 @param isMarker Whether the character acts as a marker or a regular character.
 */
- (instancetype)initWithBars:(BCKBarString *)barString isMarker:(BOOL)isMarker;

/**
 @name Enumerating Bits
 */

/**
 Enumerates the bits of the character's bit string from left to right.
 @warning This method is deprecated, use - [BCKCodeCharacter enumerateBitsUsingBlock:] instead.
 @param block The enumeration block that gets executed for each bit
 */
- (void)enumerateBitsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block __attribute((deprecated("use enumerateBarUsingBlock: instead")));

/**
 Enumerates the bars of the character's bar string from left to right.
 @param block The enumeration block that gets executed for each bar
 */
- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block;

/**
 @name Getting Information about Code Characters
 */

/**
 Whether the receiver is a marker character (as opposed to being a digit or letter).
 */
@property (nonatomic, readonly, getter = isMarker) BOOL marker;

/**
 The bit string representing the character.
 @warning This property is deprecated, use barString instead.
 */
@property (nonatomic, readonly) NSString *bitString __attribute((deprecated("use barString instead")));

/**
 The array of bars representing the character.
 */
@property (nonatomic, readonly) BCKBarString *barString;

@end
