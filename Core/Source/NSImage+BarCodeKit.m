//
//  NSImage+BarCodeKit.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 10/4/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import Foundation;

#if TARGET_OS_OSX

@import AppKit;

#import "NSImage+BarCodeKit.h"
#import "BarCodeKit.h"

@implementation NSImage (BarCodeKit)

+ (NSImage *)imageWithBarCode:(BCKCode *)barCode options:(NSDictionary *)options
{

	CGSize neededSize = [barCode sizeWithRenderOptions:options];
	
	if (!neededSize.width || !neededSize.height)
	{
		return nil;
	}
	
	NSBitmapImageRep *offscreenRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
																									 pixelsWide:neededSize.width
																									 pixelsHigh:neededSize.height
																								 bitsPerSample:8
																							  samplesPerPixel:4
																										hasAlpha:YES
																										isPlanar:NO
																								colorSpaceName:NSDeviceRGBColorSpace
																								  bitmapFormat:NSAlphaFirstBitmapFormat
																									bytesPerRow:0
																								  bitsPerPixel:0];
	
	// set offscreen context
	NSGraphicsContext *graphicsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep];
	[NSGraphicsContext setCurrentContext:graphicsContext];
	CGContextRef context = [graphicsContext graphicsPort];
	
	// need to flip context
	CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, neededSize.height);
	CGContextConcatCTM(context, flipVertical);
	
	// render the bar code
	[barCode renderInContext:context options:options];
	
	// create an NSImage and add the rep to it
	NSImage *image = [[NSImage alloc] initWithSize:neededSize];
	[image addRepresentation:offscreenRep];
	
	return image;
}

@end
#endif
