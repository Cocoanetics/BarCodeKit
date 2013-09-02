//
//  BCKCode39CodeModulo43.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 02/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39CodeModulo43.h"
#import "BCKCode39ContentCodeCharacter.h"

@implementation BCKCode39CodeModulo43

#pragma mark - Helper methods

-(BCKCode39ContentCodeCharacter *)_generateModulo43ForContentCodeCharacters:(NSArray*)contentCodeCharacters
{
    __block NSUInteger weightedSum = 0;
    
    // Add the value of each content code character to the weighted sum.
    [contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKCode39ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
        
        weightedSum+=[obj characterValue];
    }];
    
    // Return the check character by taking the weighted sum modulo 43
    return [[BCKCode39ContentCodeCharacter alloc] initWithValue:(weightedSum % 43)];
}

#pragma mark - Subclass Methods

- (NSArray *)codeCharacters
{
    // Array that holds all code characters, including start/stop, spaces, and modulo-43 check character (if required)
    NSMutableArray *finalArray = [NSMutableArray array];
	NSMutableArray *contentCharacterArray = [NSMutableArray array]; // Holds just code characters without spaces
    
	// end marker
	[finalArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		// space
		[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
		
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode39CodeCharacter *codeCharacter = [BCKCode39CodeCharacter codeCharacterForCharacter:character];
		[finalArray addObject:codeCharacter];
        [contentCharacterArray addObject:codeCharacter];
	}
    
	// space
	[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
    
    // Calculate Module 43 check digit
    BCKCode39CodeCharacter *tmpCharacter = [self _generateModulo43ForContentCodeCharacters:contentCharacterArray];
    [finalArray addObject:tmpCharacter];
    
    // space
    [finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
    
	// end marker
	[finalArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	return [finalArray copy];
}

@end
