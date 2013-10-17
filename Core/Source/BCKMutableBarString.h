//
//  BCKMutableBarString.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 17.10.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarString.h"

/**
 Mutable version of BCKBarString, a string of bars
 */
@interface BCKMutableBarString : BCKBarString

/**
 @name Modifying a Bar String
 */

/**
 Append a single bar to the end of the existing bar string.
 @param barType The BCKBarType to be appended to the bar string.
 */
- (void)appendBarWithType:(BCKBarType)barType;

@end
