//
//  UIImage+BarCodeKit.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCKCode;

@interface UIImage (BarCodeKit)

/**
 Creates a bitmap rendering of a BCKCode with rendering options
 @param barCode A BCKCode 
 @param options The rendering options
 @returns A `UIImage` with the bar code
 */
+ (UIImage *)imageWithBarCode:(BCKCode *)barCode options:(NSDictionary *)options;

@end
