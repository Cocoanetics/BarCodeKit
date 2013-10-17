//
//  BCKBarString.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 16/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarString.h"
#import "NSError+BCKCode.h"

@interface BCKBarString ()

@property (nonatomic, readwrite) NSMutableArray *barArray;

@end

@implementation BCKBarString

#pragma mark Helper Methods

- (instancetype)initWithString:(NSString *)barString
{
    NSError *error;
    
    self = [super init];
    
    if (self) {

        for (int i=0; i < [barString length]; i++)
        {
            [self appendBar:[barString characterAtIndex:i] error:&error];

            if (error)
            {
                return nil;
            }
        }
    }

    return self;
}

- (NSString *)description
{
    return [_barArray componentsJoinedByString:@""];
}

- (NSUInteger)count
{
    if (_barArray)
    {
        return [_barArray count];
    }
    else
    {
        return 0;
    }
}

- (BOOL)appendBar:(BCKBarType)bar error:(NSError *__autoreleasing *)error
{
    if (!_barArray)
    {
        _barArray = [[NSMutableArray alloc] init];
    }

    if (![[BCKBarString _supportedBarTypes] member:@(bar)])
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"Bar type %c not supported by %@", (int)bar, NSStringFromClass([self class])];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return NO;
    }

    [_barArray addObject:@(bar)];

    return YES;
}

- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType bit, NSUInteger idx, BOOL *stop))block
{
	NSParameterAssert(block);

    [_barArray enumerateObjectsUsingBlock:^(NSNumber *bar, NSUInteger idx, BOOL *stop)
    {
        BCKBarType barType = [bar integerValue];
        BOOL shouldStop = NO;
        
		block(barType, idx, &shouldStop);
        
		if (shouldStop)
		{
			*stop = YES;
		}
    }];
}

+ (NSSet*)_supportedBarTypes
{
    return [NSSet setWithObjects:@(BCKBarTypeBottomHalf),
            @(BCKBarTypeBottomTwoThirds),
            @(BCKBarTypeCentreOneThird),
            @(BCKBarTypeFull),
            @(BCKBarTypeSpace),
            @(BCKBarTypeTopHalf),
            @(BCKBarTypeTopTwoThirds),
            nil];
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setBarArray:[_barArray copy]];
    }
    
    return copy;
}

@synthesize barArray = _barArray;

@end
