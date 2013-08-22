//
//  BCKCode2of5Code.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode2of5Code.h"

#import "BCKCode2of5CodeCharacterPair.h"
#import "BCKCode2of5DigitCodeCharacterPair.h"

@implementation BCKCode2of5Code

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

#pragma mark - Helper Methods

- (BOOL)_isValidContent:(NSString *)content
{
    if ( content.length % 2 != 0 )
    {
        NSLog(@"Code2of5 codes must have even length " );
        return NO;
    }
    
	for (NSUInteger index=0; index<[content length]; index+= 2)
	{
		NSString *digit1 = [content substringWithRange:NSMakeRange(index, 1)];
		NSString *digit2 = [content substringWithRange:NSMakeRange(index+1, 1)];
		BCKCode2of5CodeCharacterPair *codeCharacter = [[BCKCode2of5DigitCodeCharacterPair alloc] initWithDigitCharacter1:digit1 andDigitCharacter2:digit2];
		if (!codeCharacter)
		{
			NSLog(@"Characters '%@' and '%@' cannot be encoded in Code2of5", digit1, digit2);
			return NO;
		}
	}
	
	return YES;
}

#pragma mark - Subclass Methods

- (NSArray *)codeCharacters
{
	NSMutableArray *tmpArray = [NSMutableArray array];
    
	// end marker
	[tmpArray addObject:[BCKCode2of5CodeCharacterPair startMarkerCodeCharacter]];
	
	for (NSUInteger index=0; index<[_content length]; index+=2)
	{
        NSString *digit1 = [_content substringWithRange:NSMakeRange(index, 1)];
		NSString *digit2 = [_content substringWithRange:NSMakeRange(index+1, 1)];
		BCKCode2of5CodeCharacterPair *codeCharacter = [[BCKCode2of5DigitCodeCharacterPair alloc] initWithDigitCharacter1:digit1 andDigitCharacter2:digit2];
		[tmpArray addObject:codeCharacter];
	}
    
    
    [tmpArray addObject:[BCKCode2of5CodeCharacterPair endMarkerCodeCharacter]];

	return [tmpArray copy];
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
	return 75;
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

@end
