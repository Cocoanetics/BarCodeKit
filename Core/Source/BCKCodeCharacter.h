//
//  BCKCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarString.h"
#import "BCKMutableBarString.h"
#import "BCKBarStringFunctions.h"

/**
 Root class representing a code character. Can be marker, spacing, start/stop, check digits or characters.
 */

@interface BCKCodeCharacter : NSObject

/**
 @name Creating Characters
 */

/**
 Creates a new character with an array of given bars and whether it is a marker character
 @param barString The bar string
 @param isMarker Whether the character acts as a marker or a regular character
 */
- (instancetype)initWithBars:(BCKBarString *)barString isMarker:(BOOL)isMarker;

/**
 @name Enumerating Bars
 */

/**
 Enumerates the bars of the character's bar string from left to right
 @param block The enumeration block that gets executed for each bar
 */
- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block;

/**
 @name Getting Information about Code Characters
 */

/**
 Whether the receiver is a marker character (as opposed to being a digit or letter)
 */
@property (nonatomic, readonly, getter = isMarker) BOOL marker;

/**
 The array of bars representing the character
 */
@property (nonatomic, readonly) BCKBarString *barString;

@end
