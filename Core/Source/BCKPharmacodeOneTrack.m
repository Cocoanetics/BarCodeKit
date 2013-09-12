//
//  BCKPharmacodeOneTrack.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPharmacodeOneTrack.h"
#import "BCKPharmaOneTrackContentCodeCharacter.h"
#import "NSError+BCKCode.h"

#define ENCODE_ERROR_MESSAGE @"Pharmacode One Track only supports integer values between 3 and 131070"

// source: http://www.gomaro.ch/ftproot/Laetus_PHARMA-CODE.pdf

@implementation BCKPharmacodeOneTrack

- (instancetype)initWithContent:(NSString *)content error:(NSError**)error
{
    self = [super initWithContent:content];
    
	if (self)
	{
        if (![BCKPharmacodeOneTrack canEncodeContent:content error:error])
		{
			return nil;
		}
    }
	
	return self;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}

    NSMutableArray *finalArray = [NSMutableArray array];

    // The content is encoded as one Content Code Character
    BCKPharmaOneTrackContentCodeCharacter *tmpCharacter = [[BCKPharmaOneTrackContentCodeCharacter alloc] initWithInteger:
                                                           [_content integerValue]];
    [finalArray addObject:tmpCharacter];

	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

#pragma mark - Subclass Methods

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"Pharmacode One Track";
}

// Pharmacode One Track only supports integer values from 3 to 131070
+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    BOOL success = NO;

    if ([content rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        NSInteger integerValue = [content integerValue];
        if((integerValue < 3) || (integerValue > 131070))
        {
            *error = [NSError BCKCodeErrorWithMessage:ENCODE_ERROR_MESSAGE];
        }
        else
        {
            success = YES;
        }
    }
    else
    {
        *error = [NSError BCKCodeErrorWithMessage:ENCODE_ERROR_MESSAGE];
    }
	
	return success;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 17;
}

- (CGFloat)aspectRatio
{
	return 1.9;
}

- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options
{
	return 10;
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
