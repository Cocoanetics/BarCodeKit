//
//  BCKCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"

@implementation BCKCodeCharacter
{
	NSString *_bitString;
	BOOL _marker;
}

- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker
{
	self = [super init];
	
	if (self)
	{
		_bitString = [bitString copy];
		_marker = isMarker;
	}
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self bitString]];
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

@synthesize bitString = _bitString;
@synthesize marker = _marker;

@end
