//
//  BCKISMNCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BCKISMNCode.h"

@interface BCKISMNCode () // private

- (BCKBarString *)barString;
- (NSString *)titleText;

@end

@interface BCKISMNCodeTest : SenTestCase

@end

@implementation BCKISMNCodeTest

- (void)testEncodeValid
{
    BCKISMNCode *code;
    NSError *error;
    
    code = [[BCKISMNCode alloc] initWithPublisherID:@"2600" andItemID:@"0043" andCheckDigit:@"8" error:&error];
    STAssertNotNil(code, @"Should be able to encode ISMN code with check digit");
    STAssertEqualObjects(code.titleText, @"ISMN 979-0-2600-0043-8", @"ISMN code with check digit incorrect title text");
    STAssertEqualObjects(code.content, @"9790260000438", @"ISMN code with check digit encoded incorrectly");
    STAssertNil(error, @"NSError should be nil");

    code = [[BCKISMNCode alloc] initWithContent:@"979-0-060-11561-5" error:&error];
    STAssertNotNil(code, @"Should be able to encode ISMN code with check digit");
    STAssertEqualObjects(code.titleText, @"ISMN 979-0-060-11561-5", @"ISMN code with check digit incorrect title text");
    STAssertEqualObjects(code.content, @"9790060115615", @"ISMN code with check digit encoded incorrectly");
    STAssertNil(error, @"NSError should be nil");

    code = [[BCKISMNCode alloc] initWithContent:@"979-0-901679-17-7" error:&error];
    STAssertNotNil(code, @"Should be able to encode ISMN code with check digit");
    STAssertEqualObjects(code.titleText, @"ISMN 979-0-901679-17-7", @"ISMN code with check digit incorrect title text");
    STAssertEqualObjects(code.content, @"9790901679177", @"ISMN code with check digit encoded incorrectly");
    STAssertNil(error, @"NSError should be nil");
}

- (void)testEncodeInvalid
{
    BCKISMNCode *code;
    NSError *error;

    code = [[BCKISMNCode alloc] initWithPublisherID:@"123" andItemID:@"12345" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: publisherID not in acceptable range");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"12345678" andItemID:@"12" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: publisherID too long");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"12" andItemID:@"12" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: publisherID too short");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"125678" andItemID:@"1" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: itemID too short");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"1123" andItemID:@"1234567" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: itemID too long");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"1123" andItemID:@"12345" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: itemID + publisherID must be 8 digits long");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"1123" andItemID:@"12345" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: itemID + publisherID must not be more than 8 digits");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"1123" andItemID:@"123" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: itemID + publisherID must not be less than 8 digits");

    error = nil;
    code = [[BCKISMNCode alloc] initWithPublisherID:@"112" andItemID:@"1234" andCheckDigit:@"8" error:&error];
    STAssertNil(code, @"Should not be able to encode ISMN string: itemID + publisherID must not be less than 8 digits");
}

- (void)testEncodeUsingInvalidString
{
    BCKISMNCode *code;
    NSError *error;
    
    code = [[BCKISMNCode alloc] initWithContent:@"979-0-12-123234-7" error:&error];
    STAssertNil(code, @"Should not be able to encode insufficient number of publisher ID digits in ISMN string");

    code = [[BCKISMNCode alloc] initWithContent:@"979-0-12345321-1-7" error:&error];
    STAssertNil(code, @"Should not be able to encode too many publisher ID digits in ISMN string");

    code = [[BCKISMNCode alloc] initWithContent:@"879-0-901679-17-7" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid prefix in ISMN string");
}

@end
