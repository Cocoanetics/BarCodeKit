//
//  BCKMSICodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 10/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating MSI codes
 */
@interface BCKMSICodeCharacter : BCKCodeCharacter

/**
 @name Creating Characters
 */

/**
 Generates an start marker code character, used for MSI barcodes
 @returns the start marker code character
 */
+ (BCKMSICodeCharacter *)startMarkerCodeCharacter;

/**
 Generates a stop marker code character, used for MSI barcodes
 @returns the stop marker code character
 */
+ (BCKMSICodeCharacter *)stopMarkerCodeCharacter;

/**
 Generates a code character to represent an MSI content character
 @param character The character to encode
 @returns The content code character
 */
+ (BCKMSICodeCharacter *)codeCharacterForCharacter:(NSString *)character;

@end
