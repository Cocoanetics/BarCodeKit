//
//  UIImage+BarCodeKit.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@class BCKCode;

/**
 Helper methods for `UIImage` to generate bitmap images from BCKCode instances.
 */
@interface UIImage (BarCodeKit)

/**
 @name Rendering Bitmaps
 */

/**
 Creates a bitmap rendering of a BCKCode with rendering options.
 @param barCode A BCKCode.
 @param options The rendering options.
 @returns A `UIImage` with the bar code.
 */
+ (UIImage *)imageWithBarCode:(BCKCode *)barCode options:(NSDictionary *)options;

@end
