//
//  BCKEAN13CodeTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import XCTest;

#import <BarCodeKit/BCKEAN13Code.h>
#import <BarCodeKit/BCKBarStringFunctions.h>

@interface BCKEAN13Code () // private

- (BCKBarString *)barString;
- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options;

@end


@interface BCKEAN13CodeTest : XCTestCase

@end

@implementation BCKEAN13CodeTest

// tests encoding a basic word
- (void)testEncode
{
	NSError *error;
	BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"9780596516178" error:&error];
	XCTAssertNotNil(code, @"%@", [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"10101110110001001010011101100010010111010111101010100111011001101010000110011010001001001000101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	XCTAssertTrue(isEqual, @"Result from encoding incorrect");
}

// text cannot be encoded
- (void)testEncodeInvalidText
{
	NSError *error;
	BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"foo" error:&error];
	XCTAssertNil(code, @"Should not be able to encode non-digits in EAN13");
	XCTAssertNotNil(error, @"No error message returned");
}

- (void)testEncodeInvalidNumber
{
	NSError *error;
	BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"978059651617" error:&error];
	XCTAssertNil(code, @"Should not be able to too few digits in EAN13");
	XCTAssertNotNil(error, @"No error message returned");
}

- (void)testCaptionSizesSimilarWhenQuiteZonesOnOrOff
{
	NSError *error;
	BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"9780596516178" error:&error];
	XCTAssertNotNil(code, @"%@", [error localizedDescription]);
	
	CGFloat heightWithFill = [code _captionFontSizeWithOptions:@{BCKCodeDrawingFillEmptyQuietZonesOption : @(YES)}];
	CGFloat heightWithoutFill = [code _captionFontSizeWithOptions:@{BCKCodeDrawingFillEmptyQuietZonesOption : @(NO)}];
	XCTAssertEqualWithAccuracy(heightWithFill, heightWithoutFill, 1, @"Caption size should be similar. Expected ~%f, but got %f", heightWithFill, heightWithoutFill);
}

@end
