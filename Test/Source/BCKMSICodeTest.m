//
//  BCKMISCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 10/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import XCTest;

#import <BarCodeKit/BCKMSICode.h>
#import <BarCodeKit/BCKMSIContentCodeCharacter.h>

@interface BCKMSICode () // private

- (BCKBarString *)barString;

@end

@interface BCKMSICodeTest : XCTestCase

@end

@implementation BCKMSICodeTest

- (void)testEncodeInvalid
{
	NSError *error = nil;
	BOOL isEqual;
	
	BCKMSICode *code = [[BCKMSICode alloc] initWithContent:@"1234a" error:&error];
	XCTAssertNil(code, @"Should not be able to encode alphanumeric characters in MSI");
	
	NSString *name = [BCKMSICode barcodeDescription];
	isEqual = [[error localizedDescription] isEqualToString:[NSString stringWithFormat:@"Character at index 4 'a' cannot be encoded in %@", name]];
	
	XCTAssertNotNil(error, @"Error object should not be nil");
	XCTAssertTrue(isEqual, @"Error message should indicate invalid content");
}

- (void)testDefaultCheckDigitScheme
{
	NSError *error = nil;
	
	BCKMSICode *code = [[BCKMSICode alloc] initWithContent:@"1234567" error:&error];
	BCKBarString *expected = BCKBarStringFromNSString(@"1101001001001101001001101001001001101101001101001001001101001101001101101001001101101101001101001001001");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	XCTAssertTrue(isEqual, @"Result from encoding using default check digit scheme is incorrect");
}

- (void)testCheckDigits
{
	NSError *error = nil;
	BCKMSICode *code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod1010CheckDigitScheme error:&error];
	
	// Check that the last two code characters are marked as check digits
	BCKMSIContentCodeCharacter *tmpCharacter = nil;
	NSUInteger characterCount;
	
	characterCount = [code.codeCharacters count];
	
	tmpCharacter = code.codeCharacters[characterCount - 3];
	XCTAssertTrue(tmpCharacter.isCheckDigit, @"First check digit character must have isCheckDigit equal to YES");
	
	tmpCharacter = code.codeCharacters[characterCount - 2];
	XCTAssertTrue(tmpCharacter.isCheckDigit, @"Second check digit character must have isCheckDigit equal to YES");
}

- (void)testCheckDigitSchemes
{
	BCKMSICode *code;
	NSUInteger expected;
	BCKMSIContentCodeCharacter *actual;
	NSError *error = nil;
 
	code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod10CheckDigitScheme error:&error];
	expected = 1;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	XCTAssertTrue((expected == [actual characterValue]), @"Result from Mod 10 check digit scheme is incorrect");
	
	error = nil;
	code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod11CheckDigitScheme error:&error];
	expected = 4;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	XCTAssertTrue((expected == [actual characterValue]), @"Result from Mod 11 check digit scheme is incorrect");
	
	error = nil;
	code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod1010CheckDigitScheme error:&error];
	expected = 2;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	XCTAssertTrue((expected == [actual characterValue]), @"Result from Mod 1010 check digit scheme is incorrect");
	
	error = nil;
	code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod1110CheckDigitScheme error:&error];
	expected = 6;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	XCTAssertTrue((expected == [actual characterValue]), @"Result from Mod 1110 check digit scheme is incorrect");
}

@end
