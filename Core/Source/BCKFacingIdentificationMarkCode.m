//
//  BCKFacingIdentificationMarkCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 24/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKFacingIdentificationMarkCode.h"
#import "BCKFacingIdentificationMarkCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKFacingIdentificationMarkCode
{
	BCKFacingIdentificationMarkType _fimType;
}

// To ensure the DemoApp can display this class take the integer value of the content string and passes it as the BCKFacingIdentificationMarkTypes to the designated initialiser
- (instancetype)initWithContent:(NSString *)content error:(NSError**)error
{
	BCKFacingIdentificationMarkType fimType = [[self class] _fimTypeFromContent:content];
	
	if (!fimType)
	{
		if (error)
		{
			NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"'%@' is not a supported FIM type for %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), content, [[self class] barcodeDescription]];
			*error = [NSError BCKCodeErrorWithMessage:message];
			
			return nil;
		}
	}
	
	return [self initWithFIMType:fimType error:error];
}

- (instancetype)initWithFIMType:(BCKFacingIdentificationMarkType)fimType error:(NSError *__autoreleasing *)error;
{
	NSString *content = [[self class] _contentForFimType:fimType];
	
	self = [super initWithContent:content error:error];
	
	if (self)
	{
		_fimType = fimType;
	}
    
	return self;
}

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"Facing Identification Mark";
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error
{
	// convert content to fimType
	BCKFacingIdentificationMarkType fimType = [self _fimTypeFromContent:content];

	if (fimType)
	{
		return YES;
	}
	
	if (error)
	{
		NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%d is not a supported FIM type for %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), fimType, [[self class] barcodeDescription]];
		*error = [NSError BCKCodeErrorWithMessage:message];
	}
	
	return NO;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
	
	_codeCharacters = [NSArray arrayWithObject:[BCKFacingIdentificationMarkCodeCharacter facingIdentificationMarkCode:_fimType]];

	return _codeCharacters;
}

#pragma mark - Utilities

+ (BCKFacingIdentificationMarkType)_fimTypeFromContent:(NSString *)content
{
	if ([content isEqualToString:@"1"] || [[content lowercaseString] isEqualToString:@"a"])
	{
		return BCKFIMTypeA;
	}
	
	if ([content isEqualToString:@"2"] || [[content lowercaseString] isEqualToString:@"b"])
	{
		return BCKFIMTypeB;
	}

	if ([content isEqualToString:@"3"] || [[content lowercaseString] isEqualToString:@"c"])
	{
		return BCKFIMTypeC;
	}

	if ([content isEqualToString:@"4"] || [[content lowercaseString] isEqualToString:@"d"])
	{
		return BCKFIMTypeD;
	}

	if ([content isEqualToString:@"5"] || [[content lowercaseString] isEqualToString:@"e"])
	{
		return BCKFIMTypeE;
	}

	return 0; // invalid
}

+ (NSString *)_contentForFimType:(BCKFacingIdentificationMarkType)fimType
{
	switch (fimType)
	{
		case BCKFIMTypeA:
		{
			return @"A";
		}
			
		case BCKFIMTypeB:
		{
			return @"B";
		}

		case BCKFIMTypeC:
		{
			return @"C";
		}

		case BCKFIMTypeD:
		{
			return @"D";
		}

		case BCKFIMTypeE:
		{
			return @"E";
		}
	}
	
	return nil;
}


@end
