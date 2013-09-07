//
//  BCKCode39Code.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39Code.h"

#import "BCKCode39CodeCharacter.h"
#import "BCKCode39ContentCodeCharacter.h"

@implementation BCKCode39Code

+(NSString *)barcodeStandard
{
    return @"International standard ISO/IEC 16388";
}

+(NSString *)barcodeDescription
{
    return @"Code 39";
}

- (instancetype)initWithContent:(NSString *)content
{
	self = [super init];
	
	if (self)
	{
		if (![self _isValidContent:content])
		{
			return nil;
		}
		
		_content = [content copy];
	}
	
	return self;
}

-(BCKCode39ContentCodeCharacter *)generateModulo43ForContentCodeCharacter:(NSArray*)contentCodeCharacters
{
    __block NSUInteger weightedSum = 0;
    
    // Add the value of each content code character to the weighted sum.
    [contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKCode39ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
        
        weightedSum+=[obj characterValue];
    }];
    
    // Return the check character by taking the weighted sum modulo 43
    return [[BCKCode39ContentCodeCharacter alloc] initWithValue:(weightedSum % 43)];
}

#pragma mark - Helper Methods

- (BOOL)_isValidContent:(NSString *)content
{
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		BCKCode39CodeCharacter *codeCharacter = [[BCKCode39ContentCodeCharacter alloc] initWithCharacter:character];
		if (!codeCharacter)
		{
			//NSLog(@"Character '%@' cannot be encoded in Code39", character);
			return NO;
		}
	}
	
	return YES;
}

#pragma mark - Subclass Methods

- (NSArray *)codeCharacters
{
    // If the array was created earlier just return it
    if(_codeCharacters)
        return _codeCharacters;
	
    NSMutableArray *tmpArray = [NSMutableArray array];

	// end marker
	[tmpArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		// space
		[tmpArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
		
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode39CodeCharacter *codeCharacter = [BCKCode39CodeCharacter codeCharacterForCharacter:character];
		[tmpArray addObject:codeCharacter];
	}

	// space
	[tmpArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];

	// end marker
	[tmpArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
    _codeCharacters = [tmpArray copy];
	return _codeCharacters;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 10;
}

- (CGFloat)aspectRatio
{
	return 0;  // do not use aspect
}

- (CGFloat)fixedHeight
{
	return 30;
}

- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options
{
	return 10;
}

- (BOOL)markerBarsCanOverlapBottomCaption
{
	return NO;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone
{
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
		return _content;
	}
	
	return nil;
}

- (UIFont *)_captionFontWithSize:(CGFloat)fontSize
{
	UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
	
	return font;
}

- (BOOL)allowsFillingOfEmptyQuietZones
{
	return NO;
}

@end
