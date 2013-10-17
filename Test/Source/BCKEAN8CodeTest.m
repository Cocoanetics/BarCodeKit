//
//  BCKEAN8CodeTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN8Code.h"
#import "BCKCodeCharacter.h"

@interface BCKEAN8Code () // private

- (BCKBarString *)barString;
- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options;

@end


@interface BCKEAN8CodeTest : SenTestCase

@end

@implementation BCKEAN8CodeTest

// tests encoding a basic word
- (void)testEncode
{
	NSError *error;
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"24046985" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"1010010011010001100011010100011010101010000111010010010001001110101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// text cannot be encoded
- (void)testEncodeInvalidText
{
	NSError *error;
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"2404698x" error:&error];
	STAssertNil(code, @"Should not be able to encode non-digits in EAN13");
	STAssertNotNil(error, @"No error message returned");
}

// only 8 digit numbers can be encoded
- (void)testEncodeInvalidNumber
{
	NSError *error;
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"2404698" error:&error];
	STAssertNil(code, @"Should not be able to too few digits in EAN8");
	STAssertNotNil(error, @"No error message returned");
}

- (void)testCaptionSizesSimilarWhenQuiteZonesOnOrOff
{
	NSError *error;
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"75032814" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

	CGFloat heightWithFill = [code _captionFontSizeWithOptions:@{BCKCodeDrawingFillEmptyQuietZonesOption : @(YES)}];
	CGFloat heightWithoutFill = [code _captionFontSizeWithOptions:@{BCKCodeDrawingFillEmptyQuietZonesOption : @(NO)}];
	STAssertEqualsWithAccuracy(heightWithFill, heightWithoutFill, 1, @"Caption size should be similar. Expected ~%f, but got %f", heightWithFill, heightWithoutFill);
}

@end
