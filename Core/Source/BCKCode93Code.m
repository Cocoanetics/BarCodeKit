//
//  BCKCode93Code.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93Code.h"
#import "BCKCode93CodeCharacter.h"

@implementation BCKCode93Code

-(BCKCode93ContentCodeCharacter*)firstModulo47CheckCharacter
{
    return nil;
}

-(BCKCode93ContentCodeCharacter*)secondModulo47CheckCharacter
{
    return nil;
}

#pragma mark - Subclass Methods

- (NSArray *)codeCharacters
{
	NSMutableArray *tmpArray = [NSMutableArray array];
    
	// Add the start code character *
	[tmpArray addObject:[BCKCode93CodeCharacter startCodeCharacter]];
	
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode93CodeCharacter *codeCharacter = [BCKCode93CodeCharacter codeCharacterForCharacter:character];
		[tmpArray addObject:codeCharacter];
	}
    
    // Add the first modulo-47 check character "C"
    // to-do
    
    // Add the second modulo-47 check character "K"
    // to-do

	// Add the stop code character *
	[tmpArray addObject:[BCKCode93CodeCharacter stopCodeCharacter]];

    // Add the termination bar
	[tmpArray addObject:[BCKCode93CodeCharacter terminationBarCodeCharacter]];
    
	return [tmpArray copy];
}

@end
