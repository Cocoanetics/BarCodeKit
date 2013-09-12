//
//  BCKMISCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 10/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKMSICode.h"
#import "BCKMSIContentCodeCharacter.h"

@interface BCKMSICode () // private

- (NSString *)bitString;

@end

@interface BCKMSICodeTest : SenTestCase

@end

@implementation BCKMSICodeTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testEncodeInvalid
{
    NSError *error = nil;
    
    BCKMSICode *code = [[BCKMSICode alloc] initWithContent:@"1234a" error:&error];
	STAssertNil(code, @"Should not be able to encode alphanumeric characters in MSI");

    STAssertNotNil(error, @"Error object should not be nil");
    STAssertEquals([error localizedDescription], @"Content can not be encoded by BCKMSICode, alpha-numeric characters detected", @"Error message should indicate invalid content");
}

- (void)testDefaultCheckDigitScheme
{
    NSError *error = nil;
    
    BCKMSICode *code = [[BCKMSICode alloc] initWithContent:@"1234567" error:&error];
	NSString *expected = @"1101001001001101001001101001001001101101001101001001001101001101001101101001001101101101001";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding using default check digit scheme is incorrect");
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
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 10 check digit scheme is incorrect");

    error = nil;
    code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod11CheckDigitScheme error:&error];
	expected = 4;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 11 check digit scheme is incorrect");

    error = nil;
    code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod1010CheckDigitScheme error:&error];
	expected = 2;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 1010 check digit scheme is incorrect");

    error = nil;
    code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod1110CheckDigitScheme error:&error];
	expected = 6;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 1110 check digit scheme is incorrect");
}

@end
