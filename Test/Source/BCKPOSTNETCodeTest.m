//
//  BCKPOSTNETCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 15/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPOSTNETCode.h"
#import "BCKPOSTNETCodeCharacter.h"

@interface BCKPOSTNETCode () // private

- (BCKBarString *)barString;

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
    BCKBarString *expected;
    BCKBarString *actual;
    BOOL isEqual;
    
    code = [[BCKPOSTNETCode alloc] initWithContent:@"555551237" error:&error];
	expected = BCKBarStringFromNSString(@"10,010,010,0,010,010,0,010,010,0,010,010,0,010,010,0,0,0,01010,0,010,010,0,01010,010,0,0,010,0,010,0101");
	actual = [code barString];
    isEqual = [expected isEqualToString:actual];
	STAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

- (void)testInvalidFormats
{
    NSError *error = nil;
    BCKPOSTNETCode *code;
    
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"555555" error:&error];
    STAssertNotNil(error, @"Error must not be nil");
    STAssertNil(code, @"ZIP code must be 5 digits");
    
    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"55555" andZipPlus4:@"123" error:&error];
    STAssertNotNil(error, @"Error must not be nil");
    STAssertNil(code, @"ZIP+4 code must be 4 digits");
    
    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"55555" andZipPlus4:@"1234" andDeliveryPointCode:@"3" error:&error];
    STAssertNotNil(error, @"Error must not be nil");
    STAssertNil(code, @"Delivery point code must be 2 digits");

    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"" andZipPlus4:@"1234" andDeliveryPointCode:@"33" error:&error];
    STAssertNotNil(error, @"Error must not be nil");
    STAssertNil(code, @"ZIP code is required if ZIP+4 and delivery point are provided");

    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"" andZipPlus4:@"" andDeliveryPointCode:@"33" error:&error];
    STAssertNotNil(error, @"Error must not be nil");
    STAssertNil(code, @"ZIP+4 code is required if delivery point is provided");

    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"5555" andZipPlus4:@"" andDeliveryPointCode:@"33" error:&error];
    STAssertNotNil(error, @"Error must not be nil");
    STAssertNil(code, @"ZIP+4 code is required if delivery point is provided");
}

- (void)testValidFormats
{
    NSError *error = nil;
    BCKPOSTNETCode *code;
    BCKBarString *expected;
    BCKBarString *actual;
    BOOL isEqual;

    code = [[BCKPOSTNETCode alloc] initWithZIP:@"55555" error:&error];
    STAssertNil(error, @"Error must be nil");
    expected = BCKBarStringFromNSString(@"10,010,010,0,010,010,0,010,010,0,010,010,0,010,010,0,010,010,01");
	actual = [code barString];
    isEqual = [expected isEqualToString:actual];
	STAssertTrue(isEqual, @"Result from encoding ZIP is incorrect");
    
    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"55555" andZipPlus4:@"1237" error:&error];
    STAssertNil(error, @"Error must be nil");
    expected = BCKBarStringFromNSString(@"10,010,010,0,010,010,0,010,010,0,010,010,0,010,010,0,0,0,01010,0,010,010,0,01010,010,0,0,010,0,010,0101");
	actual = [code barString];
    isEqual = [expected isEqualToString:actual];
	STAssertTrue(isEqual, @"Result from encoding ZIP and ZIP+4 is incorrect");

    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"80122" andZipPlus4:@"1905" error:&error];
    STAssertNil(error, @"Error must be nil");
    expected = BCKBarStringFromNSString(@"1010,0,010,01010,0,0,0,0,0,01010,0,010,010,0,010,010,0,0,0101010,010,0,01010,0,0,0,010,010,0,0,010,0101");
	actual = [code barString];
    isEqual = [expected isEqualToString:actual];
	STAssertTrue(isEqual, @"Result from encoding ZIP and ZIP+4 is incorrect");
    
    error = nil;
    code = [[BCKPOSTNETCode alloc] initWithZIP:@"80122" andZipPlus4:@"1905" andDeliveryPointCode:@"22" error:&error];
    STAssertNil(error, @"Error must be nil");
    expected = BCKBarStringFromNSString(@"1010,0,010,01010,0,0,0,0,0,01010,0,010,010,0,010,010,0,0,0101010,010,0,01010,0,0,0,010,010,0,0,010,010,0,010,01010,0,010,01");
	actual = [code barString];
    isEqual = [expected isEqualToString:actual];
    STAssertTrue(isEqual, @"Result from encoding ZIP and ZIP+4 and delivery point code is incorrect");
}

@end
