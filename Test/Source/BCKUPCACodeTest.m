//
//  BCKUPCACodeTest.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKUPCACode.h"
#import "BCKEANCodeCharacter.h"

@interface BCKUPCACode ()

- (BCKBarString *)barString;

@end

@interface BCKUPCACodeTest : XCTestCase

@end

@implementation BCKUPCACodeTest

- (void)testEncode
{
	NSError *error;
	BCKUPCACode *code = [[BCKUPCACode alloc] initWithContent:@"088345100517" error:&error];
	XCTAssertNotNil(code, @"%@", [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"10100011010110111011011101111010100011011000101010110011011100101110010100111011001101000100101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	XCTAssertTrue(isEqual, @"Result from encoding incorrect");
}

// text cannot be encoded
- (void)testEncodeInvalidText
{
	NSError *error;
	BCKUPCACode *code = [[BCKUPCACode alloc] initWithContent:@"A8834510051B" error:&error];
	XCTAssertNil(code, @"Should not be able to encode non-digits in UPC-A");
	XCTAssertNotNil(error, @"No error message returned");
}

- (void)testCheckDigitVerified
{
	NSError *error;
	BCKUPCACode *code = [[BCKUPCACode alloc] initWithContent:@"088345100510" error:&error];
	XCTAssertNil(code, @"Should have verified UPC-A check digit");
	XCTAssertNotNil(error, @"No error message returned");
}

@end
