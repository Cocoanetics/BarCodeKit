//
//  BCKPharmaOneTrackContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for generating Pharma One Track codes.
 */
@interface BCKPharmaOneTrackContentCodeCharacter : BCKCodeCharacter

/**
 Initialise a content code character using an integer value. Pharmacode One Track supports integers between 3 and 131070.
 @param integer The integer.
 @returns The content code character for the integer.
 */
- (instancetype)initWithInteger:(NSInteger)integer;

@end
