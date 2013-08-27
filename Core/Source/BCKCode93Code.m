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

-(BCKCode93ContentCodeCharacter *)firstModulo47CheckCodeCharacter:(NSArray *)contentCodeCharacters
{
    __block NSUInteger weightedSum = 0;
    __block NSUInteger weight = 1;
    
    // Add the product of each content code character's value and their weights to the weighted sum. Weights start at 1 from the rightmost
    // content code character. The weight increases until 20 then starts from 1 again
    [contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKCode93ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
        
        weightedSum+=weight * [obj characterValue];
        
        weight++;
        if(weight==21)
            weight = 1;
    }];
    
    // Return the check character by taking the weightedsum modulo 47
    return [[BCKCode93ContentCodeCharacter alloc] initWithValue:(weightedSum % 47)];
}

#pragma mark - Subclass Methods

- (NSArray *)codeCharacters
{
	NSMutableArray *tmpArray = [NSMutableArray array];
    NSMutableArray *finalArray = [NSMutableArray array];
    
	// Add the start code character *
	[finalArray addObject:[BCKCode93CodeCharacter startCodeCharacter]];
	
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode93CodeCharacter *codeCharacter = [BCKCode93CodeCharacter codeCharacterForCharacter:character];
		[tmpArray addObject:codeCharacter];
	}
    
    [finalArray addObjectsFromArray:tmpArray];
    
    // Add the first modulo-47 check character "C"
    [finalArray addObject:[self firstModulo47CheckCodeCharacter:tmpArray]];
    
	// Add the stop code character *
	[finalArray addObject:[BCKCode93CodeCharacter stopCodeCharacter]];

    // Add the termination bar
	[finalArray addObject:[BCKCode93CodeCharacter terminationBarCodeCharacter]];
    
	return [finalArray copy];
}

@end
