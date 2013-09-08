//
//  BCKCode128CodeCharacter.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"
#import "BCKCode128ContentCodeCharacter.h"

/**
 Types of Code128
 */
typedef NS_ENUM(char, BCKCode128Version) {
	/**
	 Code128 Type A
	 */
    Code128A = 0,
	
	/**
	 Code128 Type B
	 */
    Code128B,
	
	/**
	 Code128 Type C
	 */
    Code128C,
	
	/**
	 Code128 Unsupported
	 */
    Code128Unsupported
};

/**
 Specialized class of BCKCodeCharacter used for generating Code128 codes
 */
@interface BCKCode128CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates an start code for given Code 128 version.
 @param codeVersion the Code 128 version used
 @returns the start code character
 */
+ (BCKCode128CodeCharacter *)startCodeForVersion:(BCKCode128Version)codeVersion;

/**
 Generates an stop character, used for Code 128.
 @returns the stop marker code character
 */
+ (BCKCode128CodeCharacter *)stopCharacter;

/**
 Generates a code character to represent a content character
 @param character The character to encode
 @param codeVersion The version of Code128 used
 @returns The content code character
 */
+ (instancetype)codeCharacterForCharacter:(NSString *)character codeVersion:(BCKCode128Version)codeVersion;

/**
 Return character representation on given index in code table.
 Note - Code 128 version does not matter here because we are interested in binary string at given position.
 @param position of character to return
 @returns The content code character
 */
+ (BCKCode128CodeCharacter *)characterAtPosition:(NSUInteger)position;

/**
 Returns given characters position in Code 128 table
 @returns the position of character
 */
- (NSUInteger)position;

/**
 Returns control character for switching barcode write to given Code128 version
 @param targetVersion the Code128 needed next
 @returns the character to alter next characters type
 */
+ (BCKCode128CodeCharacter *)switchCodeToVersion:(BCKCode128Version)targetVersion;

@end
