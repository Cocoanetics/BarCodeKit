//
//  BCKPharmaOneTrackContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPharmaOneTrackContentCodeCharacter.h"

@implementation BCKPharmaOneTrackContentCodeCharacter
{
	NSInteger _integerValue;
}

- (instancetype)initWithInteger:(NSInteger )integer
{
	self = [super init];
	
	if (self)
	{
		_integerValue = integer;
	}
	
	return self;
}

- (NSString *)bitString
{
    NSMutableString *tmpString = [NSMutableString string];
    NSInteger integerValue = _integerValue;
    
    while (integerValue > 0)
    {
        if((integerValue % 2) == 0)
        {
            // Add wide bar
            [tmpString insertString:@"1111" atIndex:0];
            integerValue = (integerValue - 2) / 2;
        }
        else
        {
            // Add narrow bar
            [tmpString insertString:@"11" atIndex:0];
            integerValue = (integerValue - 1) / 2;
        }

        // Enter a space between bars
        if(integerValue > 0)
            [tmpString insertString:@"00" atIndex:0];
    }
    
	return tmpString;
}

@end
