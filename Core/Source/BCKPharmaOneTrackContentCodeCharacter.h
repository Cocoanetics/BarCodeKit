//
//  BCKPharmaOneTrackContentCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

@interface BCKPharmaOneTrackContentCodeCharacter : BCKCodeCharacter

/**
 Initialise a content code character using an integer value. Pharmacode One Track supports integers between 3 and 131070
 @param integer The integer
 @returns the content code character
 */
- (instancetype)initWithInteger:(NSInteger)integer;

@end
