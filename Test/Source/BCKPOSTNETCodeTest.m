//
//  BCKPOSTNETCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 15/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPOSTNETCode.h"

@interface BCKPOSTNETCode () // private

- (NSString *)bitString;

@end

@interface BCKPOSTNETCodeTest : SenTestCase

@end

@implementation BCKPOSTNETCodeTest

- (void)testEncodingInvalid
{
    NSError *error = nil;
    
    BCKPOSTNETCode *code = [[BCKPOSTNETCode alloc] initWithContent:@"12345a" error:&error];
	STAssertNil(code, @"Should not be able to encode alphanumeric characters in POSTNET");
    STAssertNotNil(error, @"Error object should not be nil");
}

- (void)testEncodeValid
{
    NSError *error = nil;
    BCKPOSTNETCode *code;
    NSString *expected;
    NSString *actual;
    BOOL isEqual;
    
    code = [[BCKPOSTNETCode alloc] initWithContent:@"555551237" error:&error];
	expected = @"10,010,010,0,010,010,0,010,010,0,010,010,0,010,010,0,0,0,01010,0,010,010,0,01010,010,0,0,010,0,010,0101";
	actual = [code bitString];
    isEqual = [expected isEqualToString:actual];
	STAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

- (void)testValidFormats
{
    // TO-DO: to be added
    STAssertFalse(NO, @"add type check for the four barcode formats - A-code, B-code, C-code, DPBC-code");
}


@end
