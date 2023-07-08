//
//  BCKUPCECodeTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import XCTest;

#import "BCKUPCECode.h"
#import "BCKEANCodeCharacter.h"

@interface BCKUPCECode () // private

- (BCKBarString *)barString;

@end


@interface BCKUPCECodeTest : XCTestCase

@end

@implementation BCKUPCECodeTest

// tests encoding a basic word
- (void)testEncode
{
	NSError *error;
	BCKUPCECode *code = [[BCKUPCECode alloc] initWithContent:@"12345670" error:&error];
	XCTAssertNotNil(code, @"%@", [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"101001001101111010100011011100100001010010001010101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	XCTAssertTrue(isEqual, @"Result from encoding incorrect");
}

// text cannot be encoded
- (void)testEncodeInvalidText
{
	NSError *error;
	BCKUPCECode *code = [[BCKUPCECode alloc] initWithContent:@"1234567x" error:&error];
	XCTAssertNil(code, @"Should not be able to encode non-digits in UPC-E");
	XCTAssertNotNil(error, @"No error message returned");
}

// only 8 digit numbers can be encoded
- (void)testEncodeInvalidNumber
{
	NSError *error;
	BCKUPCECode *code = [[BCKUPCECode alloc] initWithContent:@"1234567" error:&error];
	XCTAssertNil(code, @"Should not be able to too few digits in UPC-E");
	XCTAssertNotNil(error, @"No error message returned");
}

@end
