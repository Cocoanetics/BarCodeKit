//
//  BCKEAN8CodeTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN8Code.h"

@interface BCKEAN8Code () // private

- (NSString *)bitString;
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
	
	NSString *expected = @"1010010011010001100011010100011010101010000111010010010001001110101";
	NSString *actual = [code bitString];
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

- (void)testCaptionSizeShouldNotBeDifferentDependingOnQuietZoneFill
{
	NSError *error;
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"75032814" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

	CGFloat heightWithFill = [code _captionFontSizeWithOptions:@{BCKCodeDrawingFillEmptyQuietZonesOption : @(YES)}];
	CGFloat heightWithoutFill = [code _captionFontSizeWithOptions:@{BCKCodeDrawingFillEmptyQuietZonesOption : @(NO)}];
	STAssertEqualsWithAccuracy(heightWithFill, heightWithoutFill, 0.1, @"Caption size shoudl be same. Expected %f, but got %f", heightWithFill, heightWithoutFill);
}

@end
