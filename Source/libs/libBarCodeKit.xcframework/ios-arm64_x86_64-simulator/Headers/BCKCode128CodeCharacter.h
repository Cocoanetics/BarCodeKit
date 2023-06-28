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
 Supported Code128 versions
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
 Specialized class of BCKCodeCharacter used for generating Code128 codes.
 */
@interface BCKCode128CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates a start code for a particular Code128 version.
 @param codeVersion The Code128 version used.
 @returns The start code character
 */
+ (BCKCode128CodeCharacter *)startCodeForVersion:(BCKCode128Version)codeVersion;

/**
 Generates a Code128 stop character.
 @returns The stop marker code character.
 */
+ (BCKCode128CodeCharacter *)stopCharacter;

/**
 Generates a code character to represent a content character.
 @param character The character to encode.
 @param codeVersion The Code128 version to use.
 @returns The content code character.
 */
+ (instancetype)codeCharacterForCharacter:(NSString *)character codeVersion:(BCKCode128Version)codeVersion;

/**
 Return the character representation for a given index in the code table.
 Note: the Code128 version does not matter here because we are interested in binary string at given position.
 @param position The position of the character to return.
 @returns The content code character.
 */
+ (BCKCode128CodeCharacter *)characterAtPosition:(NSUInteger)position;

/**
 Returns the character's position in the Code128 table.
 @returns The position of the character.
 */
- (NSUInteger)position;

/**
 Returns the control character for switching barcodes to a specific version of Code128.
 @param targetVersion The Code 128 version to switch to.
 @returns The character to alter subsequent characters' type.
 */
+ (BCKCode128CodeCharacter *)switchCodeToVersion:(BCKCode128Version)targetVersion;

@end
