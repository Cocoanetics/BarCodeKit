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
    NSArray *_barArray;
	BOOL _marker;
}

#pragma mark Bar Creation Methods

+ (BCKBarType)bottomHalfBar
{
    return BCKBarTypeBottomHalf;
}

+ (BCKBarType)spaceBar
{
    return BCKBarTypeSpace;
}

+ (BCKBarType)fullBar
{
    return BCKBarTypeFull;
}

+ (BCKBarType)topTwoThirdsBar
{
    return BCKBarTypeTopTwoThirds;
}

+ (BCKBarType)bottomTwoThirdsBar
{
    return BCKBarTypeBottomTwoThirds;
}

+ (BCKBarType)centreOneThirdBar
{
    return BCKBarTypeCentreOneThird;
}

+ (BCKBarType)topHalfBar
{
    return BCKBarTypeTopHalf;
}

#pragma mark Init Methods

- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker
{
	self = [super init];
	
	if (self)
	{
		_marker = isMarker;

        NSMutableArray *tmpBarArray = [[NSMutableArray alloc] initWithCapacity:[bitString length]];
        for (int i=0; i < [bitString length]; i++)
        {
            [tmpBarArray addObject:[NSNumber numberWithChar:[bitString characterAtIndex:i]]];
        }
        
        _barArray = [NSArray arrayWithArray:tmpBarArray];
    }
	
	return self;
}

- (instancetype)initWithBars:(NSArray *)barArray isMarker:(BOOL)isMarker
{
	self = [super init];
	
	if (self)
	{
		_barArray = [barArray copy];
		_marker = isMarker;
	}
	
	return self;
}

#pragma mark Helper Methods

- (NSString *)description
{
    if (self.bitString)
    {
        return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self bitString]];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self.barArray componentsJoinedByString:@""]];
    }
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

- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block
{
	NSParameterAssert(block);

    [self.barArray enumerateObjectsUsingBlock:^(NSNumber *bit, NSUInteger idx, BOOL *stop) {
        // Every bar type is considered a bar except BCKBarTypeNone (i.e. a space)
        BCKBarType barType = [bit integerValue];
		BOOL isBar = (barType != BCKBarTypeSpace);
        BOOL shouldStop = NO;

		block(barType, isBar, idx, &shouldStop);
        
		if (shouldStop)
		{
			*stop = YES;
		}
    }];
}

@synthesize barArray = _barArray;
@synthesize marker = _marker;

@end
