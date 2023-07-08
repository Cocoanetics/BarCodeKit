//
//  NSImage+BarCodeKit.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 10/4/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#if TARGET_OS_OSX

@import AppKit;

@class BCKCode;

/**
 Helper methods for `NSImage` to generate bitmap images from BCKCode instances.
 */
@interface NSImage (BarCodeKit)

/**
 @name Rendering Bitmaps
 */

/**
 Creates a bitmap rendering of a BCKCode with rendering options.
 @param barCode A BCKCode.
 @param options The rendering options.
 @returns An `NSImage` with the bar code.
 */
+ (NSImage *)imageWithBarCode:(BCKCode *)barCode options:(NSDictionary *)options;

@end

#endif
