//
//  BCKCode39CodeTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39Code.h"
#import "BCKCode39CodeModulo43.h"
#import "BCKCode93CodeCharacter.h"

@interface BCKCode39Code () // private

- (BCKBarString *)barString;

@end


@interface BCKCode39CodeTest : SenTestCase

@end


@implementation BCKCode39CodeTest

// tests encoding a basic word
- (void)testEncode
{
	NSError *error;
	BCKCode39Code *code = [[BCKCode39Code alloc] initWithContent:@"OLIVER" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"1001011011010110101101001010110101001101011010011010100110101011011010110010101101010110010100101101101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// lower case should not be possible initially
- (void)testEncodeInvalid
{
	NSError *error;
	BCKCode39Code *code = [[BCKCode39Code alloc] initWithContent:@"oliver" error:&error];
	STAssertNil(code, @"Should not be able to encode lower case text in Code39");
	STAssertNotNil(error, @"No error message returned");
}

// tests encoding a barcode with the Modulo 43 check digit
- (void)testEncodeWithModulo43CheckDigit
{
	NSError *error;
	BCKCode39CodeModulo43 *code =[[BCKCode39CodeModulo43 alloc] initWithContent:@"OLIVER" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"10010110110101101011010010101101010011010110100110101001101010110110101100101011010101100101011001101010100101101101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Mod 43 check digit incorrect");
}

@end
