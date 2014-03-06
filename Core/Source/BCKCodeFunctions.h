//
//  BCKCodeFunctions.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 28.02.14.
//  Copyright (c) 2014 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Determines the maximum bar scale that produces a barcode image to fit in the given size.
 @param code The barcode to use.
 @param size The maximum size for the output.
 @param options Other rendering options that have an effect on sizing or `nil`.
 @returns A maximum bar scale integer. If the size is too small to even fit the smallest value then the mimimum of 1 is returned.
 */
NSUInteger BCKCodeMaxBarScaleThatFitsCodeInSize(BCKCode *code, CGSize size, NSDictionary *options);