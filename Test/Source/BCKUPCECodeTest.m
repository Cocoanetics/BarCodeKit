//
//  BCKUPCECodeTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKUPCECode.h"

@interface BCKUPCECode () // private

- (NSString *)bitString;

@end

@interface BCKUPCECodeTest : SenTestCase

@end

@implementation BCKUPCECodeTest

// tests encoding a basic word
- (void)testEncode
{
	BCKUPCECode *code = [[BCKUPCECode alloc] initWithContent:@"12345670"];
	
	NSString *expected = @"101001001101111010100011011100100001010010001010101";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// text cannot be encoded
- (void)testEncodeInvalidText
{
	BCKUPCECode *code = [[BCKUPCECode alloc] initWithContent:@"1234567x"];
	STAssertNil(code, @"Should not be able to encode non-digits in UPC-E");
}

// only 8 digit numbers can be encoded
- (void)testEncodeInvalidNumber
{
	BCKUPCECode *code = [[BCKUPCECode alloc] initWithContent:@"1234567"];
	STAssertNil(code, @"Should not be able to too few digits in UPC-E");
}

@end
