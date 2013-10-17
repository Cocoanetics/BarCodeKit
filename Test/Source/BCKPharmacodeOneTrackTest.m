//
//  BCKPharmacodeOneTrackTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPharmacodeOneTrack.h"
#import "BCKCodeCharacter.h"

@interface BCKPharmacodeOneTrack () // private

- (BCKBarString *)barString;

@end

@interface BCKPharmacodeOneTrackTest : SenTestCase

@end

@implementation BCKPharmacodeOneTrackTest

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

- (void)testInvalidContent
{
    NSError *error = nil;
    
    BCKPharmacodeOneTrack *code = [[BCKPharmacodeOneTrack alloc] initWithContent:@"1234a" error:&error];
	STAssertNil(code, @"Should not be able to encode alphanumeric characters in Pharmacode One Track");
    STAssertNotNil(error, @"Error object should not be nil");
    error = nil;
    
    code = [[BCKPharmacodeOneTrack alloc] initWithContent:@"2" error:&error];
	STAssertNil(code, @"Should not be able to encode integers less than 3");
    STAssertNotNil(error, @"Error object should not be nil");
    error = nil;
    
    code = [[BCKPharmacodeOneTrack alloc] initWithContent:@"131071" error:&error];
	STAssertNil(code, @"Should not be able to encode integers greater than 131070");
    STAssertNotNil(error, @"Error object should not be nil");
}

- (void)testEncode
{
    NSError *error = nil;
    
    BCKPharmacodeOneTrack *code = [[BCKPharmacodeOneTrack alloc] initWithContent:@"542" error:&error];
	BCKBarString *expected = BCKBarStringFromNSString(@"11001100110011001111001111001111001111001111");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
    
	STAssertTrue(isEqual, @"Result from encoding should be correct");
}


@end
