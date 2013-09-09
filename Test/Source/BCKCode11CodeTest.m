//
//  BCKCode11CodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BCKCode11Code.h"

@interface BCKCode11Code () // private

- (NSString *)bitString;

@end

@interface BCKCode11CodeTest : SenTestCase

@end

@implementation BCKCode11CodeTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
}

- (void)testEncode
{
	BCKCode11Code *code = [[BCKCode11Code alloc] initWithContent:@"123-45"];
	NSString *expected = @"1011001011010110100101101100101010110101011011011011010110110101011001";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testEncodeLong
{
	BCKCode11Code *code = [[BCKCode11Code alloc] initWithContent:@"01234528987"];
	NSString *expected = @"101100101010110110101101001011011001010101101101101101010010110110100101101010110100101010011010110110110100101011001";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];

	STAssertTrue(isEqual, @"Result from encoding long contents incorrect");
}

@end
