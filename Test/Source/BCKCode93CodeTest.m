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

@interface BCKCode93Code () // private

- (NSString *)bitString;

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
    // Put setup code here; it will be run once, before the first test case.
    
    self.code = [[BCKCode93Code alloc] initWithContent:@"TEST93"];
    self.codeFullASCII = [[BCKCode93Code alloc] initWithContent:@"Test93!"];
    self.codeSimple = [[BCKCode93Code alloc] initWithContent:@"T"];
}

- (void)tearDown
{
    self.code = nil;
    self.codeFullASCII = nil;
    
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testStartCodeCharacter
{
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter startStopCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:0];

    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
	
	STAssertTrue(isEqual, @"First character is not a start/stop code character");
}

- (void)testStopCodeCharacter
{
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter startStopCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:([[self.code codeCharacters] count]-2)];
    
    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
	
	STAssertTrue(isEqual, @"Second to last character is not a start/stop code character");
}

- (void)testTerminationBarCodeCharacter
{
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter terminationBarCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] lastObject];

	BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
	
	STAssertTrue(isEqual, @"Last character is not a termination bar code character");
}

-(void)testCharacterByValue
{
    BCKCode93ContentCodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"+"];
    BCKCode93ContentCodeCharacter *actual = [[BCKCode93ContentCodeCharacter alloc] initWithValue:41];
    
    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
    
    STAssertTrue(isEqual, @"Initialising a content code generator by value is incorrect");
}

- (void)testFirstModulo47CheckCodeCharacter
{
    BCKCode93CodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"+"];
    BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:([[self.code codeCharacters] count]-4)];
    
    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
    
    STAssertTrue(isEqual, @"First modulo 47 check code character is incorrect");
}

- (void)testSecondModulo47CheckCodeCharacter
{
    BCKCode93CodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"6"];
    BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:([[self.code codeCharacters] count]-3)];
    
    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
    
    STAssertTrue(isEqual, @"Second modulo 47 check code character is incorrect");
}

// tests encoding a simple word
- (void)testEncodingSimple
{
	NSString *expected = @"1010111101101001101101001101011011101010111101";
	NSString *actual = [self.codeSimple bitString];
	BOOL isEqual = [expected isEqualToString:actual];
    
	STAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

// tests encoding a regular (without full ASCII characters) barcode
- (void)testEncoding
{
	NSString *expected = @"1010111101101001101100100101101011001101001101000010101010000101011101101001000101010111101";
	NSString *actual = [self.code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a barcode incorrect");
}

-(void)testEncodeMultiCharacterCode
{
    BCKCode93ContentCodeCharacter *invalidCode = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"AA"];
    
    STAssertNil(invalidCode, @"Code character initialisation with a multi character string should not be possible");
}

// tests encoding a barcode containing full ASCII characters
- (void)testEncodingFullASCII
{
	NSString *expected = @"1010111101101001101001100101100100101001100101101011001001100101101001101000010101010000101110101101101010001100100101001010001010111101";
	NSString *actual = [self.codeFullASCII bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a full ASCII incorrect");
}

// tests encoding a barcode containing full ASCII characters \ and "
- (void)testEncodingFullASCIIWithSlashesAndQuotes
{
    BCKCode93Code *fullASCIICode = [[BCKCode93Code alloc] initWithContent:@":\";<\\>"];     // content=:";<\>
	NSString *expected = @"1010111101110101101001110101110101101101001001110110101100010101110110101011010001110110101010110001110110101011000101001110101101001101010111101";
	NSString *actual = [fullASCIICode bitString];
	BOOL isEqual = [expected isEqualToString:actual];
    
	STAssertTrue(isEqual, @"Result from encoding a full ASCII with slashes and quotes is incorrect");
}

// tests encoding a barcode containing control characters STX and ENQ
- (void)testEncodingControlCharacters
{
    BCKCode93Code *fullASCIICode = [[BCKCode93Code alloc] initWithContent:@"␂␅"];     // content=␂␅
	NSString *expected = @"1010111101001001101101001001001001101100100101010001101011010001010111101";
	NSString *actual = [fullASCIICode bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
    NSLog(@"expected:%@", expected);
    NSLog(@"  actual:%@", actual);
    
	STAssertTrue(isEqual, @"Result from encoding a full ASCII with slashes and quotes is incorrect");
}

@end
