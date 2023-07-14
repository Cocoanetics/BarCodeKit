//
//  NSError+BCKCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import Foundation;

/**
 Helper methods for `NSError` to create BarCodeKit specific `NSError` instances.
 */
@interface NSError (BCKCode)

/**
 @name Initialising NSError objects
 */

/**
 Creates an `NSError` instance with default BarCodeKit settings and a custom error message.
 @param message The error message the `NSError` object should be initialised with.
 @returns A BarCodeKit specific `NSError` object initialised with the error message.
 */
+ (NSError *)BCKCodeErrorWithMessage:(NSString *)message;

@end
