//
//  BCKStandard2of5CodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import XCTest;

#import <BarCodeKit/BCKStandard2of5Code.h>
#import <BarCodeKit/BCKStandard2of5CodeCharacter.h>

@interface BCKStandard2of5Code () // private

- (BCKBarString *)barString;

@end

@interface BCKStandard2of5CodeTest : XCTestCase

@end

@implementation BCKStandard2of5CodeTest

- (void)testEncodeInvalid
{
	NSError *error = nil;
	
	BCKStandard2of5Code *code = [[BCKStandard2of5Code alloc] initWithContent:@"12345a" error:&error];
	XCTAssertNil(code, @"Should not be able to encode alphanumeric characters in Standard 2 of 5");
	XCTAssertNotNil(error, @"Error object should not be nil");
}

- (void)testEncodeValid
{
	NSError *error = nil;
	BCKStandard2of5Code *code;
	BCKBarString *expected;
	BCKBarString *actual;
	BOOL isEqual;
	
	code = [[BCKStandard2of5Code alloc] initWithContent:@"1234" withModulo10:YES error:&error];
	expected = BCKBarStringFromNSString(@"1101101011101010101110101110101011101110111010101010101110101110111010101110101101011");
	actual = [code barString];
	isEqual = [expected isEqualToString:actual];
	XCTAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
	
	error = nil;
	code = [[BCKStandard2of5Code alloc] initWithContent:@"1234" error:&error];
	expected = BCKBarStringFromNSString(@"11011010111010101011101011101010111011101110101010101011101011101101011");
	actual = [code barString];
	isEqual = [expected isEqualToString:actual];
	XCTAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

@end
