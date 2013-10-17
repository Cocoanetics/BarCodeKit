//
//  BCKMutableBarString.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 17.10.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKMutableBarString.h"


@interface BCKBarString ()

@property (nonatomic, copy) NSMutableArray *barArray;

@end

@implementation BCKMutableBarString

#pragma mark - Modifying a Bar String

- (void)appendBarWithType:(BCKBarType)barType
{
	if (!_bars)
	{
		_bars = [NSMutableArray array];
	}

	NSAssert([_bars isKindOfClass:[NSMutableArray class]], @"_bars needs to be mutable");
	
	[_bars addObject:@(barType)];
}

#pragma mark - Properties

- (NSMutableArray *)barArray
{
	return _bars;
}

- (void)setBarArray:(NSMutableArray *)barArray
{
	_bars = [barArray mutableCopy];
}

@end
