//
//  BCKCode2of9CodeTest.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//


#import "BCKCode2of5Code.h"

@interface BCKCode2of5Code () // private

- (NSString *)bitString;

@end


@interface BCKCode2of5CodeTest : SenTestCase

@end

@implementation BCKCode2of5CodeTest

// tests encoding a basic barcode
- (void)testEncode
{
	BCKCode2of5Code *code = [[BCKCode2of5Code alloc] initWithContent:@"1234567890"];
	NSString *expected = @"101011010010101100110110100101001101001100101010010101100110101101001100101101";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// Odd length should not be possible initially (in theory we could 0 prefix to make even length
// but not implemented yet)
- (void)testEncodeOddLength
{
	BCKCode2of5Code *code = [[BCKCode2of5Code alloc] initWithContent:@"123456789"];
	STAssertNotNil(code, @"2 Of 5 Codes must have even size (divisible by 2)");
}

// Alpha characters are not supported in this format
- (void)testEncodeInvalidCharacters
{
	BCKCode2of5Code *code = [[BCKCode2of5Code alloc] initWithContent:@"123abc"];
	STAssertNil(code, @"2 Of 5 Codes must be numeric only");
}


@end
