//
//  BCKCode128CodeCharacter.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Code128 codes
 */
@interface BCKCode128CodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates an start code A character, used for Code 128
 @returns the start code character
 */
+ (BCKCode128CodeCharacter *)startCodeA;

/**
 Generates an start code B character, used for Code 128
 @returns the start code character
 */
+ (BCKCode128CodeCharacter *)startCodeB;

/**
 Generates an start code C character, used for Code 128
 @returns the start code character
 */
+ (BCKCode128CodeCharacter *)startCodeC;

/**
 Generates an stop character, used for Code 128.
 @returns the stop marker code character
 */
+ (BCKCode128CodeCharacter *)stopCharacter;

/**
 Generates a code character to represent a content character
 @param character The character to encode
 @returns The content code character
 */
+ (instancetype)codeCharacterForCharacter:(NSString *)character;

/**
 Return character representation on given index in code table
 @param position of character to return
 @returns The content code character
 */
+ (BCKCode128CodeCharacter *)characterAtPosition:(NSUInteger)position;

@end
