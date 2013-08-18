//
//  BCKCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

@implementation BCKCodeCharacter

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self bitString]];
}

- (NSString *)bitString
{
	return nil;
}

- (void)enumerateBitsUsingBlock:(void (^)(BOOL isBar, NSUInteger idx, BOOL *stop))block
{
	NSParameterAssert(block);
	
	NSString *bitString = [self bitString];
	NSUInteger length = [bitString length];
	
	for (NSUInteger i=0; i<length; i++)
	{
		NSString *bit = [bitString substringWithRange:NSMakeRange(i, 1)];
		
		BOOL isBar = [bit isEqualToString:@"1"];
		
		BOOL shouldStop = NO;
		
		block(isBar, i, &shouldStop);
		
		if (shouldStop)
		{
			break;
		}
	}
}

- (BOOL)isMarkerCharacter
{
	return NO;
}

@end
