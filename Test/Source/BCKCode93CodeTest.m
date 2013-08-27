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

@end

@implementation BCKCode93CodeTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    self.code = [[BCKCode93Code alloc] initWithContent:@"TEST93"];
}

- (void)tearDown
{
    self.code = nil;
    
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

//- (void)testFirstModulo47CheckCharacter
//{
//    BCKCode93CodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"+"];
//    BCKCode93CodeCharacter *actual = [self.code firstModulo47CheckCharacter];
//    
//    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
//    
//    STAssertTrue(isEqual, @"First modulo 47 check character is incorrect");
//}
//
//- (void)testSecondModulo47CheckCharacter
//{
//    BCKCode93CodeCharacter *expected = [[BCKCode93ContentCodeCharacter alloc] initWithCharacter:@"6"];
//    BCKCode93CodeCharacter *actual = [self.code secondModulo47CheckCharacter];
//
//    BOOL isEqual = [expected.bitString isEqualToString:actual.bitString];
//
//    STAssertTrue(isEqual, @"Second modulo 47 check character is incorrect");
//}

@end
