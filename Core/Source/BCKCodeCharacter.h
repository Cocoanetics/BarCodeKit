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
 Root class representing a code character. Code characters can be markers, spacing, start/stop, check digits or regular (alpha-)numeric characters.
 */

@interface BCKCodeCharacter : NSObject

/**
 @name Creating Characters
 */

/**
 Creates a new character with an array of given bars and whether it is a marker character.
 @param barString The Bar String.
 @param isMarker Whether the character acts as a marker or a regular character.
 */
- (instancetype)initWithBars:(BCKBarString *)barString isMarker:(BOOL)isMarker;

/**
 @name Enumerating Bars
 */

/**
 Enumerates the bars of the character's Bar String from left to right.
 @param block The enumeration block that gets executed for each bar.
 */
- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block;

/**
 @name Getting Information about Code Characters
 */

/**
 Whether the receiver is a marker character, as opposed to being a regular (alpha-)numeric character or check digit.
 */
@property (nonatomic, readonly, getter = isMarker) BOOL marker;

/**
 The array of bars representing the character
 */
@property (nonatomic, readonly) BCKBarString *barString;

@end
