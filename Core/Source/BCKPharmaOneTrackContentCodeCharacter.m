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

- (BCKBarString *)barString
{
    BCKMutableBarString *tmpString = [BCKMutableBarString string];
    NSInteger integerValue = _integerValue;
    
    while (integerValue > 0)
    {
        if ((integerValue % 2) == 0)
        {
            // Add wide bar
			[tmpString insertBar:BCKBarTypeFull atIndex:0];
			[tmpString insertBar:BCKBarTypeFull atIndex:0];
			[tmpString insertBar:BCKBarTypeFull atIndex:0];
			[tmpString insertBar:BCKBarTypeFull atIndex:0];
			
            integerValue = (integerValue - 2) / 2;
        }
        else
        {
            // Add narrow bar
			[tmpString insertBar:BCKBarTypeFull atIndex:0];
			[tmpString insertBar:BCKBarTypeFull atIndex:0];
			
            integerValue = (integerValue - 1) / 2;
        }

        // Enter a space between bars
        if (integerValue > 0)
		{
			[tmpString insertBar:BCKBarTypeSpace atIndex:0];
			[tmpString insertBar:BCKBarTypeSpace atIndex:0];
		}
    }
    
	return tmpString;
}

@end
