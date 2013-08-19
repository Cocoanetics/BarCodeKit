//
//  BCKCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCKCodeCharacter : NSObject

/**
 @name Creating Characters
 */
- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker;

/**
 @name Enumerating Bits
 */

/**
 Enumerates the bits of the character from left to right
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
