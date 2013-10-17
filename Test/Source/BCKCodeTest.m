//
//  BCKCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"
#import "BCKBarString.h"

@interface BCKCodeTest : SenTestCase

@end

@implementation BCKCodeTest

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

- (void)testCanEncodeTestForBCKCode
{
    NSError *error = nil;
    
    STAssertFalse([BCKCode canEncodeContent:@"12345" error:&error], @"BCKCode should always return NO for canEncodeContent:");
}

- (void)testInvalidBarString
{
    NSError *error;
    BCKBarString *barString = [[BCKBarString alloc] init];
    
    [barString appendBar:33 error:&error];
    
    STAssertNotNil(error, @"Error object should not be nil");
    STAssertTrue([barString.barArray count] == 0, @"Bar string should be empty");
    
    barString = [[BCKBarString alloc] initWithString:@"01,`<>=A"];
    STAssertNil(barString, @"Bar string should be nil");
}

- (void)testValidBarString
{
    NSError *error;
    BCKBarString *barString = [[BCKBarString alloc] initWithString:@"01,`<>="];

    STAssertNil(error, @"Error object should be nil");
    STAssertTrue([barString.barArray count] == 7, @"Bar string should contain 7 characters");
}

@end
