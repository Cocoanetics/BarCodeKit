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

- (BOOL)appendBar:(BCKBarType)barType error:(NSError *__autoreleasing *)error
{
    if (!_barArray)
    {
        _barArray = [[NSMutableArray alloc] init];
    }

    // TO-DO: return an error if the barType is not supported
    if (NO)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"Bar type %c not supported by %@", (int)barType, NSStringFromClass([self class])];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return NO;
    }

    [_barArray addObject:@(barType)];

    return YES;
}

- (void)enumerateObjectsUsingBlock:(void (^)(BCKBarType bit, NSUInteger idx, BOOL *stop))block
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
