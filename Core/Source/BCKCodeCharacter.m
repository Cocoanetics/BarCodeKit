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

- (void)enumerateBitsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block
{
	NSParameterAssert(block);

	NSString *bitString = [self bitString];
	NSUInteger length = [bitString length];

	for (NSUInteger i=0; i<length; i++)
	{
		NSString *bit = [bitString substringWithRange:NSMakeRange(i, 1)];
		
        // Every bar type is considered a bar except BCKBarTypeNone (i.e. a space)
		BOOL isBar = ([bit characterAtIndex:0] != BCKBarTypeSpace);
        BOOL shouldStop = NO;
        BCKBarType barType = [bit characterAtIndex:0];

		block(barType, isBar, i, &shouldStop);

		if (shouldStop)
		{
			break;
		}
	}
}

@synthesize bitString = _bitString;
@synthesize marker = _marker;

@end
