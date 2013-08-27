//
//  BCKCode93Code.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"
#import "BCKCode93ContentCodeCharacter.h"

@interface BCKCode93Code : BCKCode

/**
 Calculates the first modulo 47 check code character "C"
 @returns the first module 47 check code character "C"
 */
-(BCKCode93ContentCodeCharacter *)firstModulo47CheckCodeCharacter:(NSArray *)contentCodeCharacters;

@end
