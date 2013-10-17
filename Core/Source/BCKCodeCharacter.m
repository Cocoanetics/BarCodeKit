//
//  BCKCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"
#import "BCKMutableBarString.h"

@implementation BCKCodeCharacter
{
    BCKBarString *_barString;
	BOOL _marker;
}

#pragma mark Init Methods

- (instancetype)initWithBars:(BCKBarString *)barString isMarker:(BOOL)isMarker
{
	self = [super init];
	
	if (self)
	{
		_barString = [barString copy];
		_marker = isMarker;
	}
	
	return self;
}

#pragma mark Helper Methods

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ bars='%@'", NSStringFromClass([self class]), BCKBarStringToNSString(self.barString)];
}

- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block
{
	NSParameterAssert(block);

    [self.barString enumerateBarsUsingBlock:^(BCKBarType barType, NSUInteger idx, BOOL *stop) {
        // Every bar type is considered a bar except BCKBarTypeSpace (i.e. a space)
		BOOL isBar = (barType != BCKBarTypeSpace);
        BOOL shouldStop = NO;

		block(barType, isBar, idx, &shouldStop);
        
		if (shouldStop)
		{
			*stop = YES;
		}
    }];
}

@synthesize barString = _barString;
@synthesize marker = _marker;

@end
