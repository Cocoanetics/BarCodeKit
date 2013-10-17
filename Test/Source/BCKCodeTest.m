//
//  BCKCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"
#import "BCKBarString.h"
#import "BCKMutableBarString.h"

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

@end
