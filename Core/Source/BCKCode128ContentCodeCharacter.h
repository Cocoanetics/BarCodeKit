//
//  BCKCode128ContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128CodeCharacter.h"

/**
 Specialized subclass of BCKCode128CodeCharacter used to represent content code characters in Code128.
 */
@interface BCKCode128ContentCodeCharacter : BCKCode128CodeCharacter

- (instancetype)initWithCharacter:(NSString *)character codeVersion:(BCKCode128Version)codeVersion;

/**
 Returns the binary string for character at a given position in the Code128 table.
 @param position The position in the Code128 table to return.
 @returns The binary string of the character at the provided position.
 */
+ (BCKBarString *)binaryStringAtPosition:(NSUInteger)position;

/**
 Returns the Code128 version needed to encode a provided string.
 @param content The string to be encoded using Code128.
 @param error If there is a problem determining the required Code128 version for encoding the instance of `NSError` contains error details.
 @returns The Code128 version needed to encode the content string.
 */
+ (BCKCode128Version)code128VersionNeeded:(NSString *)content error:(NSError **)error;

@end
