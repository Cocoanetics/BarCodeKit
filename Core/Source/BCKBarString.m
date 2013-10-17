//
//  BCKBarString.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 16/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarString.h"
#import "BCKMutableBarString.h"
#import "NSError+BCKCode.h"

@interface BCKBarString ()

@property (nonatomic, copy) NSArray *bars;

@end


@implementation BCKBarString

#pragma mark - Initializing a Bar String

// this is a BCKBarString or BCKMutableBarString
+ (instancetype)string
{
	return [[self alloc] init];
}

// internal method for transferring a bar array to a new instance
- (instancetype)initWithBars:(NSArray *)bars
{
	self = [super init];
	
	if (self)
	{
		// here this is a normal copy, in the mutable subclass this is a mutableCopy
		self.bars = bars;
	}
	
	return self;
}

#pragma mark - Getting Information about Bar Strings

- (NSString *)description
{
	NSString *contents = [_bars componentsJoinedByString:@""];

	return [NSString stringWithFormat:@"<%@ bars='%@'>", NSStringFromClass([self class]), contents];
}

- (NSUInteger)length
{
	return [self.bars count];
}

- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType bar, NSUInteger idx, BOOL *stop))block
{
	NSParameterAssert(block);

    [self.bars enumerateObjectsUsingBlock:^(NSNumber *barNum, NSUInteger idx, BOOL *stop)
    {
        BCKBarType barType = [barNum integerValue];
        BOOL shouldStop = NO;
        
		block(barType, idx, &shouldStop);
        
		if (shouldStop)
		{
			*stop = YES;
		}
    }];
}

- (BOOL)isEqual:(BCKBarString *)otherString
{
	return [self.bars isEqualToArray:otherString.bars];
}

#pragma mark - NSMutableCopying Protocol

- (id)copyWithZone:(NSZone *)zone
{
   return [[BCKBarString allocWithZone:zone] initWithBars:_bars];
}

#pragma mark - NSMutableCopying Protocol

- (id)mutableCopyWithZone:(NSZone *)zone
{
	return [[BCKMutableBarString allocWithZone:zone] initWithBars:_bars];
}

#pragma mark - Properties

@synthesize  bars = _bars;

@end
