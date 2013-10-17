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
 @param barType The BCKBarType to be appended to the bar string
 */
- (void)appendBar:(BCKBarType)barType;

/**
 Appends a bar string to the receiver
 @param string The bar string to append
 */
- (void)appendBarString:(BCKBarString *)string;

/**
 Inserts one bar at the given index
 @param bar The BCKBarType to insert
 @param index The index to insert at
 */
- (void)insertBar:(BCKBarType)bar atIndex:(NSUInteger)index;

@end
