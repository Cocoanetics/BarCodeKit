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
    
    code = [[BCKISMNCode alloc] initWithPrefix:@"979" andPrefixM:@"0" andPublisherID:@"2600" andItemID:@"0043" andCheckDigit:@"8" error:&error];
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
