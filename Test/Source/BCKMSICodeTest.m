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

- (void)testCheckDigitSchemes
{
    BCKMSICode *code;
    NSUInteger expected;
    BCKMSIContentCodeCharacter *actual;
 
    code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod10CheckDigitScheme];
	expected = 1;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 10 check digit scheme is incorrect");

    code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod11CheckDigitScheme];
	expected = 4;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 11 check digit scheme is incorrect");

    code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod1010CheckDigitScheme];
	expected = 2;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 1010 check digit scheme is incorrect");
    
    code = [[BCKMSICode alloc] initWithContent:@"532263" andCheckDigitScheme:BCKMSICodeMod1110CheckDigitScheme];
	expected = 6;
	actual = [[code codeCharacters] objectAtIndex:([[code codeCharacters] count]-2)];
	STAssertTrue((expected == [actual characterValue]), @"Result from Mod 1110 check digit scheme is incorrect");
}

@end
