//
//  BCKInterleaved2of5Code.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKInterleaved2of5Code.h"
#import "BCKInterleaved2of5CodeCharacter.h"

@implementation BCKInterleaved2of5Code

- (instancetype)initWithContent:(NSString *)content
{
	self = [super init];
	
	if (self)
	{
		// If the content length is even, all is good
		// otherwise 0 prefix it to make it even
		NSString *dataString;
		if ( content.length % 2 == 0 )
			dataString = content;
		else
			dataString = [@"0" stringByAppendingString:content];
		
		if (![self _isValidContent:dataString])
		{
			return nil;
		}
		
		_content = [dataString copy];
		
	}
	
	return self;
}

#pragma mark - Helper Methods

- (BOOL)_isValidContent:(NSString *)content
{
	// Must be of even length - this should always be the (as we 0 prefix this) but just in case...
	if ( content.length % 2 != 0 )
	{
		NSLog(@"Code2of5 codes must have even length " );
		return NO;
	}
	
	for (NSUInteger index=0; index<[content length]; index+= 2)
	{
		// Interleave each pair of digits together
		NSString *digit1 = [content substringWithRange:NSMakeRange(index, 1)];
		NSString *digit2 = [content substringWithRange:NSMakeRange(index+1, 1)];
		
		BCKInterleaved2of5CodeCharacter *codeCharacter = [BCKInterleaved2of5CodeCharacter codeCharacterForDigitCharacter1:digit1 andDigitCharacter2:digit2];
		
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
	
	// start marker
	[tmpArray addObject:[BCKInterleaved2of5CodeCharacter startMarkerCodeCharacter]];
	
	for (NSUInteger index=0; index<[_content length]; index+=2)
	{
		// Interleave each pair of digits together
		NSString *digit1 = [_content substringWithRange:NSMakeRange(index, 1)];
		NSString *digit2 = [_content substringWithRange:NSMakeRange(index+1, 1)];
		
		BCKInterleaved2of5CodeCharacter *codeCharacter = [BCKInterleaved2of5CodeCharacter codeCharacterForDigitCharacter1:digit1 andDigitCharacter2:digit2];
		
		[tmpArray addObject:codeCharacter];
	}
   
	// end marker
	[tmpArray addObject:[BCKInterleaved2of5CodeCharacter endMarkerCodeCharacter]];
	
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

@end
