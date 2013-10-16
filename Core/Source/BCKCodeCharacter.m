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
    BCKBarString *_barString;
	BOOL _marker;
}

#pragma mark Init Methods

// TO-DO: remove method after removing support for bitString and replacing it with BCKBarString
- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker
{
    NSError *error = nil;
    
	self = [super init];
	
	if (self)
	{
		_marker = isMarker;

        _barString = [[BCKBarString alloc] init];
        for (int i=0; i < [bitString length]; i++)
        {
            [_barString appendBar:[bitString characterAtIndex:i] error:&error];
            
            if(error)
            {
                return nil;
            }
        }
    }
	
	return self;
}

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
    // TO-DO: remove the if statement below and maintain only the else statement after removing support for bitString and replacing it with BCKBarString
    if (self.bitString)
    {
        return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self bitString]];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self.barString description]];
    }
}

// TO-DO: remove the method after removing support for bitString and replacing it with BCKBarString
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

    [self.barString enumerateObjectsUsingBlock:^(BCKBarType barType, NSUInteger idx, BOOL *stop) {
        // Every bar type is considered a bar except BCKBarTypeNone (i.e. a space)
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
