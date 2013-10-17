//
//  BCKEAN5SupplementCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN5SupplementCode.h"
#import "BCKGTINSupplementCodeCharacter.h"

@interface BCKEAN5SupplementCode () // private

- (BCKBarString *)barString;

@end

@interface BCKEAN5SupplementCodeTest : SenTestCase

@end

@implementation BCKEAN5SupplementCodeTest

- (void)testEncodeValid
{
    NSError *error = nil;
    BCKEAN5SupplementCode *code = [[BCKEAN5SupplementCode alloc] initWithContent:@"52495" error:&error];
    BCKBarString *actual = [code barString];
    BCKBarString *expected = BCKBarStringFromNSString(@"010110111001010010011010011101010001011010110001");
    
    BOOL isEqual = [expected isEqualToString:actual];
    STAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

- (void)testEncodeInvalid
{
    NSError *error = nil;
    BCKEAN5SupplementCode *code = [[BCKEAN5SupplementCode alloc] initWithContent:@"" error:&error];
	STAssertNil(code, @"Should not be able to encode an empty string");
    STAssertNotNil(error, @"Error object should not be nil");
    
    error = nil;
    code = [[BCKEAN5SupplementCode alloc] initWithContent:@"92495" error:&error];
	STAssertNil(code, @"Should not be able to encode content with an invalid first digit");
    STAssertNotNil(error, @"Error object should not be nil");
    
    error = nil;
    code = [[BCKEAN5SupplementCode alloc] initWithContent:@"1" error:&error];
	STAssertNil(code, @"Should not be able to encode 1 character content");
    STAssertNotNil(error, @"Error object should not be nil");

    error = nil;
    code = [[BCKEAN5SupplementCode alloc] initWithContent:@"11" error:&error];
	STAssertNil(code, @"Should not be able to encode 2 character content");
    STAssertNotNil(error, @"Error object should not be nil");
    
    error = nil;
    code = [[BCKEAN5SupplementCode alloc] initWithContent:@"111" error:&error];
	STAssertNil(code, @"Should not be able to encode 3 character content");
    STAssertNotNil(error, @"Error object should not be nil");

    error = nil;
    code = [[BCKEAN5SupplementCode alloc] initWithContent:@"1111" error:&error];
	STAssertNil(code, @"Should not be able to encode 4 character content");
    STAssertNotNil(error, @"Error object should not be nil");
}

@end
