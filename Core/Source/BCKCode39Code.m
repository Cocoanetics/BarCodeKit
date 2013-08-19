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

- (BOOL)_isValidContent:(NSString *)content
{
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		BCKCode39CodeCharacter *codeCharacter = [[BCKCode39ContentCodeCharacter alloc] initWithCharacter:character];
		if (!codeCharacter)
		{
			NSLog(@"Character '%@' cannot be encoded in Code39", character);
			return NO;
		}
	}
	
	return YES;
}

- (NSArray *)codeCharacters
{
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

@end
