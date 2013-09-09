//
//  BCKEAN13CodeTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN13Code.h"

@interface BCKEAN13Code () // private

- (NSString *)bitString;

@end


@interface BCKEAN13CodeTest : SenTestCase

@end

@implementation BCKEAN13CodeTest

// tests encoding a basic word
- (void)testEncode
{
	BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"9780596516178"];
	NSString *expected = @"10101110110001001010011101100010010111010111101010100111011001101010000110011010001001001000101";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// text cannot be encoded
- (void)testEncodeInvalidText
{
	BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"foo"];
	STAssertNil(code, @"Should not be able to encode non-digits in EAN13");
}

- (void)testEncodeInvalidNumber
{
	BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"978059651617"];
	STAssertNil(code, @"Should not be able to too few digits in EAN13");
}

@end
