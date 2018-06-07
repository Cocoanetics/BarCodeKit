//
//  BCKCode39CodeClassClusterTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 17/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCKCode39Code.h"
#import "BCKCode39FullASCII.h"
#import "BCKCode39CodeModulo43.h"
#import "BCKCode39FullASCIIModulo43.h"

@interface BCKCode39CodeClassClusterTest : XCTestCase

@end

@implementation BCKCode39CodeClassClusterTest

- (void)testInvalidContents
{
	NSError *error = nil;
	BCKCode39Code *code = nil;
	
	code = [BCKCode39Code code39WithContent:@"abcdö123" withModulo43:NO error:&error];
	XCTAssertNil(code, @"Should not be able to encode non full ASCII characters with any BCKCode39Code (sub)class");
	XCTAssertNotNil(error, @"Error object should not be nil");
	
	error = nil;
	code = nil;
	code = [BCKCode39Code code39WithContent:@"abcdö123" error:&error];
	XCTAssertNil(code, @"Should not be able to encode non full ASCII characters with any BCKCode39Code (sub)class");
	XCTAssertNotNil(error, @"Error object should not be nil");}

- (void)testFullASCII
{
	NSError *error = nil;
	BCKCode39Code *code = nil;
	
	// Full ASCII without Modulo 43
	code = [BCKCode39Code code39WithContent:@"BaRcOdEkIt" withModulo43:NO error:&error];
	XCTAssertTrue([code isMemberOfClass:[BCKCode39FullASCII class]], @"Instantiated subclass should be BCKCode39FullASCII");
	XCTAssertNotNil(code, @"Should be able to encode full ASCII characters in BCKCode39CodeFullASCII");
	XCTAssertNil(error, @"Error object should be nil");
	
	// Full ASCII with Modulo 43
	error = nil;
	code = nil;
	code = [BCKCode39Code code39WithContent:@"BaRcOdEkIt" withModulo43:YES error:&error];
	XCTAssertTrue([code isMemberOfClass:[BCKCode39FullASCIIModulo43 class]], @"Instantiated subclass should be BCKCode39FullASCIIModule43");
	XCTAssertNotNil(code, @"Should be able to encode full ASCII characters in BCKCode39FullASCIIModule43");
	XCTAssertNil(error, @"Error object should be nil");
	
	// Full ASCII without Modulo 43 using alternative initialiser
	error = nil;
	code = nil;
	code = [BCKCode39Code code39WithContent:@"BaRcOdEkIt" error:&error];
	XCTAssertTrue([code isMemberOfClass:[BCKCode39FullASCII class]], @"Instantiated subclass should be BCKCode39FullASCII");
	XCTAssertNotNil(code, @"Should be able to encode full ASCII characters in BCKCode39FullASCII");
	XCTAssertNil(error, @"Error object should be nil");
}

- (void)testRegularASCII
{
	NSError *error = nil;
	BCKCode39Code *code = nil;
	
	// Regular ASCII without Modulo 43
	code = [BCKCode39Code code39WithContent:@"BARCODEKIT" withModulo43:NO error:&error];
	XCTAssertTrue([code isMemberOfClass:[BCKCode39Code class]], @"Instantiated subclass should be BCKCode39Code");
	XCTAssertNotNil(code, @"Should be able to encode regular ASCII characters in BCKCode39Code");
	XCTAssertNil(error, @"Error object should be nil");
	
	// Regular ASCII with Modulo 43
	error = nil;
	code = nil;
	code = [BCKCode39Code code39WithContent:@"BARCODEKIT" withModulo43:YES error:&error];
	XCTAssertTrue([code isMemberOfClass:[BCKCode39CodeModulo43 class]], @"Instantiated subclass should be BCKCode39CodeModulo43");
	XCTAssertNotNil(code, @"Should be able to encode regular ASCII characters in BCKCode39CodeModulo43");
	XCTAssertNil(error, @"Error object should be nil");
	
	// Regular ASCII without Modulo 43 using alternative initialiser
	error = nil;
	code = nil;
	code = [BCKCode39Code code39WithContent:@"BARCODEKIT" error:&error];
	XCTAssertTrue([code isMemberOfClass:[BCKCode39Code class]], @"Instantiated subclass should be BCKCode39CodeModulo43");
	XCTAssertNotNil(code, @"Should be able to encode regular ASCII characters in BCKCode39Code");
	XCTAssertNil(error, @"Error object should be nil");
}

@end
