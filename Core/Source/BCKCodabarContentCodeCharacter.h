//
//  BCKCodabarContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodabarCodeCharacter.h"

@interface BCKCodabarContentCodeCharacter : BCKCodabarCodeCharacter

/**
Initialise a content code character using a character. Only supports the 10 numeric characters and '-', '$', ':', '/', '.' and '+' (without the apostrophs)
@param character The character
@returns the content code character
*/
- (instancetype)initWithCharacter:(NSString *)character;

/**
 The character encoded by the Content Code Character
 */
@property (nonatomic, readonly) NSString *character;

@end
