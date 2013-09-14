//
//  BCKCodabarCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BCKCodabarCode.h"

@interface BCKCodabarCode () // private

- (NSString *)bitString;

@end

@interface BCKCodabarCodeTest : SenTestCase

@end

@implementation BCKCodabarCodeTest

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

- (void)testEncodeValid
{
	NSError *error;
	BCKCodabarCode *code = [[BCKCodabarCode alloc] initWithContent:@"A40156B" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	NSString *expected = @"10110010010101101001010101001101010110010110101001010010101101001001011";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testEncodeValidAlphaNumeric
{
	NSError *error;
	BCKCodabarCode *code = [[BCKCodabarCode alloc] initWithContent:@"A4-0$1:5/6.7+B" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	NSString *expected = @"1011001001010110100101010011010101010011010110010101010110010110101101101101010010110110101101001010110110110110101001011010101101101101001001011";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding alpha numeric characters is incorrect");
}

- (void)testEncodeInvalid
{
    NSError *error = nil;
    BCKCodabarCode *code = nil;

    code = [[BCKCodabarCode alloc] initWithContent:@"AA" error:&error];
	STAssertNil(code, @"Should have at least one character in addition to one start and one stop character in Codabar");
    STAssertNotNil(error, @"Error object should not be nil");
    error = nil;
    code = nil;

    code = [[BCKCodabarCode alloc] initWithContent:@"1234A" error:&error];
	STAssertNil(code, @"Should have valid start character in Codabar");
    STAssertNotNil(error, @"Error object should not be nil");
    error = nil;
    code = nil;

    code = [[BCKCodabarCode alloc] initWithContent:@"A2343" error:&error];
	STAssertNil(code, @"Should have valid stop character in Codabar");
    STAssertNotNil(error, @"Error object should not be nil");
    error = nil;
    code = nil;

    code = [[BCKCodabarCode alloc] initWithContent:@"A23a43B" error:&error];
	STAssertNil(code, @"Should have valid characters in Codabar");
    STAssertNotNil(error, @"Error object should not be nil");
    error = nil;
    code = nil;
}


@end
