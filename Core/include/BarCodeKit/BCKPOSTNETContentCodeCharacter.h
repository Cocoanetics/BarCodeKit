//
//  BCKPOSTNETContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPOSTNETCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating POSTNET content codes.
 */
@interface BCKPOSTNETContentCodeCharacter : BCKPOSTNETCodeCharacter

/**
 Initialise a content code character using a character. Only supports the 10 numeric characters.
 @param character The character.
 @returns The content code character for the character.
 */
- (instancetype)initWithCharacter:(NSString *)character;

/**
 The character encoded by the content code character.
 */
@property (nonatomic, readonly) NSString *character;

@end
