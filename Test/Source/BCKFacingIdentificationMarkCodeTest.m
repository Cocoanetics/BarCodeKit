//
//  BCKFacingIdentificationMarkCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 24/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKFacingIdentificationMarkCode.h"

@interface BCKFacingIdentificationMarkCode () // private

- (NSString *)bitString;

@end

@interface BCKFacingIdentificationMarkCodeTest : SenTestCase

@end

@implementation BCKFacingIdentificationMarkCodeTest

- (void)testEncodeValid
{
    NSError *error = nil;
    BCKFacingIdentificationMarkCode *code = [[BCKFacingIdentificationMarkCode alloc] initWithFIMType:BCKFIMTypeE error:&error];
    
    NSString *expected = @"100010000000100010";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a barcode incorrect");
}

- (void)testEncodeValidAlternative
{
    NSError *error = nil;
    BCKFacingIdentificationMarkCode *code = [[BCKFacingIdentificationMarkCode alloc] initWithContent:@"e" error:&error];
    
    NSString *expected = @"100010000000100010";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a barcode incorrect");
}

- (void)testEncodeInvalidAlternative
{
    NSError *error = nil;
    BCKFacingIdentificationMarkCode *code = [[BCKFacingIdentificationMarkCode alloc] initWithContent:@"f" error:&error];
    
	NSString *actual = [code bitString];
	
	STAssertNil(actual, @"Barcode should be nil");
	STAssertNotNil(error, @"Error object should not be nil");
}


@end
