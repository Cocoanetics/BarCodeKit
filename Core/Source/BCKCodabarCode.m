//
//  BCKCodabarCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodabarCode.h"
#import "BCKCodabarCodeCharacter.h"
#import "BCKCodabarContentCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKCodabarCode

#pragma mark - BCKCoding Methods

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"Codabar";
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error
{
	BCKCodabarCodeCharacter *codeCharacter;
	NSString *message;
	
	if ([content length] < 3)
	{
		if (error)
		{
			message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ requires at least three characters", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
			
			if (error)
			{
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
	}
	
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		
		// If it is the first or last character create a start/stop characters. For all others create a content code character
		if ((index==0) || (index==[content length]-1))
		{
			codeCharacter = [BCKCodabarCodeCharacter startStopCodeCharacter:character];
		}
		else
		{
			codeCharacter = [[BCKCodabarContentCodeCharacter alloc] initWithCharacter:character];
		}
		
		if (!codeCharacter)
		{
			if (error)
			{
				if (index==0)
				{
					message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Character at index %d '%@' is an invalid start character for %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				}
				else if (index==[content length]-1)
				{
					message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Character at index %d '%@' is an invalid stop character for %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				}
				else {
					message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Character at index %d '%@' cannot be encoded in %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				}
				
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
	}
	
	return YES;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
	
	// Array that holds all code characters, including start/stop and space characters
	NSMutableArray *finalArray = [NSMutableArray array];
	
	// Encode the barcode's content and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		
		// Start character
		if (index==0)
		{
			[finalArray addObject:[BCKCodabarCodeCharacter startStopCodeCharacter:character]];
			[finalArray addObject:[BCKCodabarCodeCharacter spacingCodeCharacter]];
		}
		// Stop character
		else if (index == [_content length]-1)
		{
			[finalArray addObject:[BCKCodabarCodeCharacter startStopCodeCharacter:character]];
		}
		// All other characters
		else
		{
			[finalArray addObject:[BCKCodabarCodeCharacter codeCharacterForCharacter:character]];
			[finalArray addObject:[BCKCodabarCodeCharacter spacingCodeCharacter]];
		}
	}
	
	_codeCharacters = [finalArray copy];
	
	return _codeCharacters;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 17;
}

- (CGFloat)aspectRatio
{
	return 0;
}

- (CGFloat)fixedHeight
{
	return 34;
}

- (BOOL)_shouldShowCheckDigitsFromOptions:(NSDictionary *)options
{
	NSNumber *num = [options objectForKey:BCKCodeDrawingShowCheckDigitsOption];
	
	if (num)
	{
		return [num boolValue];
	}
	else
	{
		return 0;  // default
	}
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
    NSString *contentWithoutStartStop = @"";
    
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
        // Check digits must not be shown, remove the start and end code characters
        if (![self _shouldShowCheckDigitsFromOptions:options])
        {
            for (NSUInteger index=0; index<[_content length]; index++)
            {
                if ( (index !=0 ) && (index != ([_content length] - 1)) )
                {
                    contentWithoutStartStop = [contentWithoutStartStop stringByAppendingString:[_content substringWithRange:NSMakeRange(index, 1)]];
                }
            }
                
            return contentWithoutStartStop;
        }
        // Check digits are to be shown so return the content string as provided to the subclass, including the start and stop character
        else
        {
            return _content;
        }
	}
	
	return nil;
}

- (BOOL)showCheckDigitsInCaption
{
	return YES;
}

@end
