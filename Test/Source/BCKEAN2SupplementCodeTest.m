//
//  BCKEAN2CodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@import XCTest;

#import "BCKEAN2SupplementCode.h"
#import "BCKGTINSupplementCodeCharacter.h"

@interface BCKEAN2SupplementCode () // private

- (BCKBarString *)barString;

@end

@interface BCKEAN2SupplementCodeTest : XCTestCase

@end

@implementation BCKEAN2SupplementCodeTest

- (void)testEncodeValid
{
	NSError *error = nil;
	BCKEAN2SupplementCode *code = [[BCKEAN2SupplementCode alloc] initWithContent:@"53" error:&error];
	BCKBarString *actual = [code barString];
	BCKBarString *expected = BCKBarStringFromNSString(@"010110110001010100001");
	
	BOOL isEqual = [expected isEqualToString:actual];
	XCTAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
	
	error = nil;
	code = [[BCKEAN2SupplementCode alloc] initWithContent:@"03" error:&error];
	actual = [code barString];
	expected = BCKBarStringFromNSString(@"010110100111010100001");
	
	isEqual = [expected isEqualToString:actual];
	XCTAssertTrue(isEqual, @"Result from encoding simple barcode is incorrect");
}

- (void)testEncodeInvalid
{
	NSError *error = nil;
	BCKEAN2SupplementCode *code = [[BCKEAN2SupplementCode alloc] initWithContent:@"100" error:&error];
	XCTAssertNil(code, @"Should not be able to encode invalid content");
	XCTAssertNotNil(error, @"Error object should not be nil");
	
	error = nil;
	code = [[BCKEAN2SupplementCode alloc] initWithContent:@"-1" error:&error];
	XCTAssertNil(code, @"Should not be able to encode invalid content");
	XCTAssertNotNil(error, @"Error object should not be nil");
	
	error = nil;
	code = [[BCKEAN2SupplementCode alloc] initWithContent:@"A" error:&error];
	XCTAssertNil(code, @"Should not be able to encode invalid content");
	XCTAssertNotNil(error, @"Error object should not be nil");
	
	error = nil;
	code = [[BCKEAN2SupplementCode alloc] initWithContent:@"(7" error:&error];
	XCTAssertNil(code, @"Should not be able to encode invalid content");
	XCTAssertNotNil(error, @"Error object should not be nil");
}

@end
