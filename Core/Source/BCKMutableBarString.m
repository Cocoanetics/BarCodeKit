//
//  BCKMutableBarString.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 17.10.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKMutableBarString.h"


@interface BCKBarString ()

@property (nonatomic, copy) NSMutableArray *bars;

@end

@implementation BCKMutableBarString

#pragma mark - Modifying a Bar String

- (void)appendBar:(BCKBarType)barType
{
	if (!_bars)
	{
		_bars = [NSMutableArray array];
	}

	NSAssert([_bars isKindOfClass:[NSMutableArray class]], @"_bars needs to be mutable");
	
	[_bars addObject:@(barType)];
}

- (void)appendBarString:(BCKBarString *)string
{
	if (!_bars)
	{
		_bars = [NSMutableArray array];
	}

	NSAssert([_bars isKindOfClass:[NSMutableArray class]], @"_bars needs to be mutable");

	[_bars addObjectsFromArray:string.bars];
}

- (void)insertBar:(BCKBarType)bar atIndex:(NSUInteger)index
{
	if (!_bars)
	{
		_bars = [NSMutableArray array];
	}
	
	[_bars insertObject:@(bar) atIndex:index];
}

#pragma mark - Properties

- (NSMutableArray *)barArray
{
	return _bars;
}

- (void)setBars:(NSMutableArray *)bars
{
	_bars = [bars mutableCopy];
}

@end
