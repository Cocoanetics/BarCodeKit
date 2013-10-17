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

#pragma mark Deprecated Methods

// DEPRECATED: remove the method after removing support for bitString and replacing it with BCKBarString. This method is required by unit tests that have not yet been refactored to use barString.
- (NSString *)bitString __attribute((deprecated))
{
    NSMutableString *tmpBitString = [[NSMutableString alloc] init];
    
    [_barString enumerateBarsUsingBlock:^(BCKBarType bar, NSUInteger idx, BOOL *stop) {
        [tmpBitString stringByAppendingFormat:@"%c", (int)bar];
    }];
    
    return tmpBitString;
}

// DEPRECATED: remove the method after removing support for bitString and replacing it with BCKBarString
- (void)enumerateBitsUsingBlock:(void (^)(BCKBarType barType, BOOL isBar, NSUInteger idx, BOOL *stop))block __attribute((deprecated("use enumerateBarsUsingBlock: instead")))
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

// DEPRECATED: remove method after removing support for bitString and replacing it with BCKBarString
- (instancetype)initWithBitString:(NSString *)bitString isMarker:(BOOL)isMarker __attribute((deprecated("use initWithBars:isMarker: instead")))
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
            
            if (error)
            {
                return nil;
            }
        }
    }
	
	return self;
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
    // DEPRECATED: remove the else statement below and maintain only the if part after dropping support for bitString
    if (self.barString)
    {
        return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self.barString description]];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@ bits='%@'", NSStringFromClass([self class]), [self bitString]];
    }
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
