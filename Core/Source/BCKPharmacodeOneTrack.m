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

// source: http://www.gomaro.ch/ftproot/Laetus_PHARMA-CODE.pdf

@implementation BCKPharmacodeOneTrack

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

#pragma mark - BCKCoding Methods

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
	NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	
	if ([content rangeOfCharacterFromSet:notDigits].location == NSNotFound)
	{
		NSInteger integerValue = [content integerValue];
		if ((integerValue < 3) || (integerValue > 131070))
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Contents cannot be encoded in %@, only integer values between 3 and 131070 are supported", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
	}
	else
	{
		if (error)
		{
			NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Contents cannot be encoded in %@, only integer values between 3 and 131070 are supported", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
		
		return NO;
	}
	
	return YES;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 17;
}

- (CGFloat)aspectRatio
{
	return 1.9;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
		return _content;
	}
	
	return nil;
}

@end
