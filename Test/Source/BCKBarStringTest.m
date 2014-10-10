//
//  BCKBarStringTest.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 17.10.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarString.h"
#import "BCKMutableBarString.h"
#import "BCKBarStringFunctions.h"

@interface BCKBarString ()

- (NSArray *)bars;

@end


@interface BCKBarStringTest : XCTestCase

@end

@implementation BCKBarStringTest

- (void)testEmpty
{
	BCKBarString *string = [BCKBarString string];
	
	XCTAssertNotNil(string, @"Should be able to create empty string");
	XCTAssertTrue([string class] == [BCKBarString class], @"Class should be BCKBarString");
	
	NSUInteger length = [string length];
	XCTAssertEqual(length, (NSUInteger)0, @"Length should be 0");
}

- (void)testMutable
{
	BCKMutableBarString *mutableString = [BCKMutableBarString string];
	
	XCTAssertNotNil(mutableString, @"Should be able to create empty mutable string");
	XCTAssertTrue([mutableString class] == [BCKMutableBarString class], @"Class should be BCKMutableBarString");
	
	NSUInteger length = [mutableString length];
	XCTAssertEqual(length, (NSUInteger)0, @"Length should be 0");
	
	[mutableString appendBar:BCKBarTypeFull];
	length = [mutableString length];
	XCTAssertEqual(length, (NSUInteger)1, @"Length should be 1 after appending");
	
	BCKBarString *immutableString = [mutableString copy];
	XCTAssertNotNil(mutableString, @"Should be able to create immutable copy");
	
	length = [immutableString length];
	XCTAssertEqual(length, (NSUInteger)1, @"Length should be 1 after copying");
	XCTAssertTrue([immutableString class] == [BCKBarString class], @"Class should be BCKBarString");
	
	BCKMutableBarString *againMutableString = [immutableString mutableCopy];
	length = [againMutableString length];
	XCTAssertEqual(length, (NSUInteger)1, @"Length should be 1 after copying");
	XCTAssertTrue([againMutableString class] == [BCKMutableBarString class], @"Class should be BCKMutableBarString");
}

- (void)testEquality
{
	BCKMutableBarString *mutableString1 = [BCKMutableBarString string];
	[mutableString1 appendBar:BCKBarTypeSpace];
	
	BCKMutableBarString *mutableString2 = [BCKMutableBarString string];
	[mutableString2 appendBar:BCKBarTypeFull];
	
	BCKMutableBarString *mutableString3 = [BCKMutableBarString string];
	[mutableString3 appendBar:BCKBarTypeFull];
	
	XCTAssertFalse([mutableString1 isEqual:mutableString2], @"should be not equal");
	XCTAssertTrue([mutableString2 isEqual:mutableString3], @"should be equal");
}

- (void)testStringConversion
{
	BCKBarString *string = BCKBarStringFromNSString(@"1 0");
	NSArray *bars = [string bars];
	
	XCTAssertTrue([bars count], @"There should be 2 bars");
	
	if ([bars count]==2)
	{
		XCTAssertTrue([string barAtIndex:0] == BCKBarTypeFull, @"There should be a full bar at index 0");
		XCTAssertTrue([string barAtIndex:1] == BCKBarTypeSpace, @"There should be a full bar at index 0");
	}
}

@end
