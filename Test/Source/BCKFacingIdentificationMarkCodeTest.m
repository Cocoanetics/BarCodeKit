//
//  BCKFacingIdentificationMarkCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 24/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import XCTest;

#import <BarCodeKit/BCKFacingIdentificationMarkCode.h>
#import <BarCodeKit/BCKFacingIdentificationMarkCodeCharacter.h>

@interface BCKFacingIdentificationMarkCode () // private

- (BCKBarString *)barString;

@end

@interface BCKFacingIdentificationMarkCodeTest : XCTestCase

@end

@implementation BCKFacingIdentificationMarkCodeTest

- (void)testEncodeValid
{
	NSError *error = nil;
	BCKFacingIdentificationMarkCode *code = [[BCKFacingIdentificationMarkCode alloc] initWithFIMType:BCKFIMTypeE error:&error];
	
	BCKBarString *expected = BCKBarStringFromNSString(@"100010000000100010");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	XCTAssertTrue(isEqual, @"Result from encoding a barcode incorrect");
}

- (void)testEncodeValidAlternative
{
	NSError *error = nil;
	BCKFacingIdentificationMarkCode *code = [[BCKFacingIdentificationMarkCode alloc] initWithContent:@"e" error:&error];
	
	BCKBarString *expected = BCKBarStringFromNSString(@"100010000000100010");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	XCTAssertTrue(isEqual, @"Result from encoding a barcode incorrect");
}

- (void)testEncodeInvalidAlternative
{
	NSError *error = nil;
	BCKFacingIdentificationMarkCode *code = [[BCKFacingIdentificationMarkCode alloc] initWithContent:@"f" error:&error];
	
	BCKBarString *actual = [code barString];
	
	XCTAssertNil(actual, @"Barcode should be nil");
	XCTAssertNotNil(error, @"Error object should not be nil");
}


@end
