//
//  BCKBarStringFunctions.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 17.10.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarStringFunctions.h"
#import "BCKMutableBarString.h"

@interface BCKBarString ()

@property (nonatomic, readonly) NSArray *bars;

@end

BCKBarString *BCKBarStringFromNSString(NSString *string)
{
	BCKMutableBarString *tmpString = [BCKMutableBarString string];
	
	NSUInteger length = [string length];
	
	for (NSUInteger i=0; i<length; i++)
	{
		unichar ch = [string characterAtIndex:i];
		
		// spaces are ignored
		if (ch == ' ')
		{
			continue;
		}
		
		if (ch == '1')
		{
			[tmpString appendBar:BCKBarTypeFull];
			continue;
		}
		else if (ch == '0')
		{
			[tmpString appendBar:BCKBarTypeSpace];
			continue;
		}
		
		BCKBarType type = (BCKBarType)ch;
		
		switch (type)
		{
			case BCKBarTypeBottomHalf:
			case BCKBarTypeSpace:
			case BCKBarTypeFull:
			case BCKBarTypeTopTwoThirds:
			case BCKBarTypeCentreOneThird:
			case BCKBarTypeBottomTwoThirds:
			case BCKBarTypeTopHalf:
			{
				[tmpString appendBar:(BCKBarType)ch];
				continue;
			}
		}
		
		NSLog(@"Warning: illegal bar type %d at index %lu in '%@'", ch, (unsigned long)i, string);
	}

	return [tmpString copy];
}

NSString *BCKBarStringToNSString(BCKBarString *string)
{
	NSMutableString *tmpString = [NSMutableString string];
	
	[string enumerateBarsUsingBlock:^(BCKBarType bar, NSUInteger idx, BOOL *stop) {
		[tmpString appendFormat:@"%c", bar];
	}];
	
	return [tmpString copy];
}