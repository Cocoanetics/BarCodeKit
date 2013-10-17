//
//  BCKCode93CodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93Code.h"
#import "BCKCode93CodeCharacter.h"
#import "BCKCode93ContentCodeCharacter.h"
#import "BCKBarStringFunctions.h"

@interface BCKCode93Code () // private

- (BCKBarString *)barString;

@end


@interface BCKCode93CodeTest : SenTestCase

@property BCKCode93Code *code;
@property BCKCode93Code *codeFullASCII;
@property BCKCode93Code *codeSimple;

@end

@implementation BCKCode93CodeTest

- (void)setUp
{
	[super setUp];
	
	self.code = [[BCKCode93Code alloc] initWithContent:@"TEST93" error:NULL];
	self.codeFullASCII = [[BCKCode93Code alloc] initWithContent:@"Test93!" error:NULL];
	self.codeSimple = [[BCKCode93Code alloc] initWithContent:@"T" error:NULL];
}

- (void)tearDown
{
	self.code = nil;
	self.codeFullASCII = nil;
	
	[super tearDown];
}

- (void)testStartCodeCharacter
{
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter startStopCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:0];
	
	BOOL isEqual = [expected.barString isEqual:actual.barString];
	
	STAssertTrue(isEqual, @"First character is not a start/stop code character");
}

- (void)testStopCodeCharacter
{
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter startStopCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:([[self.code codeCharacters] count]-2)];
	
	BOOL isEqual = [expected.barString isEqual:actual.barString];
	
	STAssertTrue(isEqual, @"Second to last character is not a start/stop code character");
}

- (void)testTerminationBarCodeCharacter
{
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter terminationBarCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] lastObject];
	
	BOOL isEqual = [expected.barString isEqual:actual.barString];
	
	STAssertTrue(isEqual, @"Last character is not a termination bar code character");
}

- (void)testCharacterByValue
{
	BCKCode93ContentCodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"+"];
	BCKCode93ContentCodeCharacter *actual = [[BCKCode93ContentCodeCharacter alloc] initWithValue:41];
	
	BOOL isEqual = [expected.barString isEqual:actual.barString];
	
	STAssertTrue(isEqual, @"Initialising a content code generator by value is incorrect");
}

- (void)testFirstModulo47CheckCodeCharacter
{
	BCKCode93CodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"+"];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:([[self.code codeCharacters] count]-4)];
	
	BOOL isEqual = [expected.barString isEqual:actual.barString];
	
	STAssertTrue(isEqual, @"First modulo 47 check code character is incorrect");
}

- (void)testSecondModulo47CheckCodeCharacter
{
	BCKCode93CodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"6"];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:([[self.code codeCharacters] count]-3)];
	
	BOOL isEqual = [expected.barString isEqual:actual.barString];
	
	STAssertTrue(isEqual, @"Second modulo 47 check code character is incorrect");
}

// tests encoding a simple word
- (void)testEncodeSimple
{
	BCKBarString *expected = BCKBarStringFromNSString(@"1010111101101001101101001101011011101010111101");
	BCKBarString *actual = [self.codeSimple barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

// tests encoding a regular (without full ASCII characters) barcode
- (void)testEncodeRegular
{
	BCKBarString *expected = BCKBarStringFromNSString(@"1010111101101001101100100101101011001101001101000010101010000101011101101001000101010111101");
	BCKBarString *actual = [self.code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a barcode incorrect");
}

- (void)testEncodeMultiCharacterCode
{
	BCKCode93ContentCodeCharacter *invalidCode = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"AA"];
	
	STAssertNil(invalidCode, @"Code character initialisation with a multi character string should not be possible");
}

// tests encoding a barcode containing full ASCII characters
- (void)testEncodeFullASCII
{
	BCKBarString *expected = BCKBarStringFromNSString(@"1010111101101001101001100101100100101001100101101011001001100101101001101000010101010000101110101101101010001100100101001010001010111101");
	BCKBarString *actual = [self.codeFullASCII barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a full ASCII incorrect");
}

// tests encoding a barcode containing full ASCII characters \ and "
- (void)testEncodeFullASCIIWithSlashesAndQuotes
{
	NSError *error;
	BCKCode93Code *fullASCIICode = [[BCKCode93Code alloc] initWithContent:@":\";<\\>" error:&error];     // content=:";<\>
	STAssertNotNil(fullASCIICode, [error localizedDescription]);

	BCKBarString *expected = BCKBarStringFromNSString(@"1010111101110101101001110101110101101101001001110110101100010101110110101011010001110110101010110001110110101011000101001110101101001101010111101");
	BCKBarString *actual = [fullASCIICode barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a full ASCII with slashes and quotes is incorrect");
}

// tests encoding a barcode containing control characters STX and ENQ
- (void)testEncodeControlCharacters
{
	NSError *error;
	BCKCode93Code *fullASCIICode = [[BCKCode93Code alloc] initWithContent:@"␂␅" error:&error];     // content=␂␅
	STAssertNotNil(fullASCIICode, [error localizedDescription]);

	BCKBarString *expected = BCKBarStringFromNSString(@"1010111101001001101101001001001001101100100101010001101011010001010111101");
	BCKBarString *actual = [fullASCIICode barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a full ASCII with slashes and quotes is incorrect");
}

// tests encoding of long barcodes, particularly the modulo-47 checks
- (void)testEncodeLongBarcodes
{
	__block BCKCode93Code *longBarcode;
	__block BOOL isEqual;
	
	NSDictionary *testBarcodes = @{@"ABCDEFGHIJKLMNO": BCKBarStringFromNSString(@"1010111101101010001101001001101000101100101001100100101100010101011010001011001001011000101001101001000110101010110001010011001010001101001011001010110001001000101010111101"),
											 @"ABCDEFGHIJKLMNOPQRSTU" : BCKBarStringFromNSString(@"1010111101101010001101001001101000101100101001100100101100010101011010001011001001011000101001101001000110101010110001010011001010001101001011001000101101101101001101100101101011001101001101100101101100110101010011001010111101")};
	
	[testBarcodes enumerateKeysAndObjectsUsingBlock:^(NSString *key, BCKBarString *obj, BOOL *stop) {
		BCKBarString *expected = obj;
		NSError *error;
		longBarcode = [[BCKCode93Code alloc] initWithContent:key error:&error];
		STAssertNotNil(longBarcode, [error localizedDescription]);

		BCKBarString *actual = [longBarcode barString];
		isEqual = [expected isEqualToString:actual];
		
		STAssertTrue(isEqual, @"Result from encoding a long barcode is incorrect");
	}];
}

// tests encoding a barcode containing characters not included in full ASCII
- (void)testEncodeNonFullASCII
{
    NSError *error = nil;
    BOOL isEqual;
    
	BCKCode93Code *codeFullASCII = [[BCKCode93Code alloc] initWithContent:@"abcdö123" error:&error];
	STAssertNil(codeFullASCII, @"Should not be able to encode non full ASCII characters in BCKCode93Code");
    
    isEqual = [[error localizedDescription] isEqualToString:@"Character at index 4 'ö' cannot be encoded in BCKCode93Code"];
    
    STAssertNotNil(error, @"Error object should not be nil");
    STAssertTrue(isEqual, @"Error message should indicate invalid content");
}

@end
