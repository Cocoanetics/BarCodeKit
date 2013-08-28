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
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter startCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:0];

    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
	
	STAssertTrue(isEqual, @"First character is not a start code character");
}

- (void)testStopCodeCharacter
{
	BCKCode93CodeCharacter *expected = [BCKCode93CodeCharacter stopCodeCharacter];
	BCKCode93CodeCharacter *actual = [[self.code codeCharacters] objectAtIndex:([[self.code codeCharacters] count]-2)];
    
    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
	
	STAssertTrue(isEqual, @"Second to last character is not a stop code character");
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

// tests encoding a basic word
- (void)testEncodingSimple
{
	NSString *expected = @"1010111101101001101101001101011011101010111101";
	NSString *actual = [self.codeSimple bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

// tests encoding a basic word
- (void)testEncoding
{
	NSString *expected = @"1010111101101001101100100101101011001101001101000010101010000101011101101001000101010111101";
	NSString *actual = [self.code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a barcode incorrect");
}

@end
