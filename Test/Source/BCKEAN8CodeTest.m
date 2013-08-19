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

@end

@interface BCKEAN8CodeTest : SenTestCase

@end

@implementation BCKEAN8CodeTest

// tests encoding a basic word
- (void)testEncode
{
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"24046985"];
	NSString *expected = @"1010010011010001100011010100011010101010000111010010010001001110101";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// text cannot be encoded
- (void)testEncodeInvalidText
{
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"2404698x"];
	STAssertNil(code, @"Should not be able to encode non-digits in EAN13");
}

// only 8 digit numbers can be encoded
- (void)testEncodeInvalidNumber
{
	BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"2404698"];
	STAssertNil(code, @"Should not be able to too few digits in EAN8");
}

@end
