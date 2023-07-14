//
//  BCKISSNCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 01/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import XCTest;

#import <BarCodeKit/BCKISSNCode.h>
#import <BarCodeKit/BCKBarString.h>

@interface BCKISSNCode () // private

- (BCKBarString *)barString;
- (NSString *)titleText;

@end

@interface BCKISSNCodeTest : XCTestCase

@end

@implementation BCKISSNCodeTest


- (void)testEncodeValid
{
	BCKISSNCode *code;
	NSError *error;
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"0317847" andISSNCheckDigit:@"1" andVariantOne:@"1" andVariantTwo:@"2" error:&error];
	XCTAssertNil(error, @"Error should be nil");
	XCTAssertNotNil(code, @"Should be able to encode a valid ISSN string");
	XCTAssertEqualObjects(code.titleText, @"ISSN 0317-8471", @"Should generate correct title text");
	XCTAssertEqualObjects(code.content, @"9770317847124", @"Should generate correct title text");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"0317847" andISSNCheckDigit:@"1" andVariantOne:nil andVariantTwo:@"2" error:&error];
	XCTAssertNil(error, @"Error should be nil");
	XCTAssertNotNil(code, @"Should be able to encode a valid ISSN string");
	XCTAssertEqualObjects(code.titleText, @"ISSN 0317-8471", @"Should generate correct title text");
	XCTAssertEqualObjects(code.content, @"9770317847025", @"Should generate correct title text");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"0317847" andISSNCheckDigit:@"1" andVariantOne:@"1" andVariantTwo:nil error:&error];
	XCTAssertNil(error, @"Error should be nil");
	XCTAssertNotNil(code, @"Should be able to encode a valid ISSN string");
	XCTAssertEqualObjects(code.titleText, @"ISSN 0317-8471", @"Should generate correct title text");
	XCTAssertEqualObjects(code.content, @"9770317847100", @"Should generate correct title text");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"0317847" andISSNCheckDigit:@"1" andVariantOne:nil andVariantTwo:nil error:&error];
	XCTAssertNil(error, @"Error should be nil");
	XCTAssertNotNil(code, @"Should be able to encode a valid ISSN string");
	XCTAssertEqualObjects(code.titleText, @"ISSN 0317-8471", @"Should generate correct title text");
	XCTAssertEqualObjects(code.content, @"9770317847001", @"Should generate correct title text");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"2434561" andISSNCheckDigit:@"X" andVariantOne:@"0" andVariantTwo:@"0" error:&error];
	XCTAssertNil(error, @"Error should be nil");
	XCTAssertNotNil(code, @"Should be able to encode a valid ISSN string");
	XCTAssertEqualObjects(code.titleText, @"ISSN 2434-561X", @"Should generate correct title text");
	XCTAssertEqualObjects(code.content, @"9772434561006", @"Should generate correct title text");
	
	code = [[BCKISSNCode alloc] initWithContent:@"2434-561X" error:&error];
	
}

- (void)testEncodeValidString
{
	BCKISSNCode *code;
	NSError *error;
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithContent:@"0317-8471" error:&error];
	XCTAssertNil(error, @"Error should be nil");
	XCTAssertNotNil(code, @"Should be able to encode a valid ISSN string");
	XCTAssertEqualObjects(code.titleText, @"ISSN 0317-8471", @"Should generate correct title text");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithContent:@"2434-561X" error:&error];
	XCTAssertNil(error, @"Error should be nil");
	XCTAssertNotNil(code, @"Should be able to encode a valid ISSN string");
	XCTAssertEqualObjects(code.titleText, @"ISSN 2434-561X", @"Should generate correct title text");
}

- (void)testEncodeInvalid
{
	BCKISSNCode *code;
	NSError *error;
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"0317847" andISSNCheckDigit:@"X" andVariantOne:@"1" andVariantTwo:@"2" error:&error];
	XCTAssertNotNil(error, @"Error should not be nil");
	XCTAssertNil(code, @"Should not be able to encode an invalid ISSN string - invalid check digit");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"0317847" andISSNCheckDigit:@"1" andVariantOne:@"A" andVariantTwo:@"2" error:&error];
	XCTAssertNotNil(error, @"Error should not be nil");
	XCTAssertNil(code, @"Should not be able to encode an invalid ISSN string - invalid variant 1");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithISSNString:@"0317847" andISSNCheckDigit:@"1" andVariantOne:@"0" andVariantTwo:@"A" error:&error];
	XCTAssertNotNil(error, @"Error should not be nil");
	XCTAssertNil(code, @"Should not be able to encode an invalid ISSN string - invalid variant 2");
}

- (void)testEncodeInvalidString
{
	BCKISSNCode *code;
	NSError *error;
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithContent:@"0317-847" error:&error];
	XCTAssertNotNil(error, @"Error should not be nil");
	XCTAssertNil(code, @"Should not be able to encode an invalid ISSN string - no check digit");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithContent:@"243456" error:&error];
	XCTAssertNotNil(error, @"Error should not be nil");
	XCTAssertNil(code, @"Should not be able to encode an invalid ISSN string - no hyphen");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithContent:@"2456" error:&error];
	XCTAssertNotNil(error, @"Error should not be nil");
	XCTAssertNil(code, @"Should not be able to encode an invalid ISSN string - too short");
	
	error = nil;
	code = [[BCKISSNCode alloc] initWithContent:@"24563342" error:&error];
	XCTAssertNotNil(error, @"Error should not be nil");
	XCTAssertNil(code, @"Should not be able to encode an invalid ISSN string - too long");
}

@end
