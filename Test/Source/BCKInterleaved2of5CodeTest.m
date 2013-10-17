//
//  BCKInterleaved2of5CodeTest.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//


#import "BCKInterleaved2of5Code.h"
#import "BCKInterleaved2of5CodeCharacter.h"

@interface BCKInterleaved2of5Code () // private

- (BCKBarString *)barString;

@end


@interface BCKCode2of5CodeTest : SenTestCase

@end

@implementation BCKCode2of5CodeTest

// tests encoding a basic barcode
- (void)testEncode
{
	NSError *error;
	BCKInterleaved2of5Code *code = [[BCKInterleaved2of5Code alloc] initWithContent:@"1234567890" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

	BCKBarString *expected = BCKBarStringFromNSString(@"101011010010101100110110100101001101001100101010010101100110101101001100101101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// Odd length should not be possible initially (in theory we could 0 prefix to make even length
// but not implemented yet)
- (void)testEncodeOddLength
{
	NSError *error;
	BCKInterleaved2of5Code *code = [[BCKInterleaved2of5Code alloc] initWithContent:@"123456789" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
}

// Alpha characters are not supported in this format
- (void)testEncodeInvalidCharacters
{
	NSError *error;
	BCKInterleaved2of5Code *code = [[BCKInterleaved2of5Code alloc] initWithContent:@"123abc" error:&error];
	STAssertNil(code, @"2 Of 5 Codes must be numeric only");
	STAssertNotNil(error, @"No error message returned");
}

@end
