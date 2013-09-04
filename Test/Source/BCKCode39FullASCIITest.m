//
//  BCKCode39FullASCIITest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 03/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BCKCode39FullASCII.h"
#import "BCKCode39FullASCIIModulo43.h"

@interface BCKCode39FullASCII () // private

- (NSString *)bitString;

@end

@interface BCKCode39FullASCIITest : SenTestCase

@end

@implementation BCKCode39FullASCIITest

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

// tests encoding a basic word
- (void)testEncode
{
	BCKCode39FullASCII *code = [[BCKCode39FullASCII alloc] initWithContent:@"OLIVER"];
	NSString *expected = @"1001011011010110101101001010110101001101011010011010100110101011011010110010101101010110010100101101101";
	NSString *actual = [code bitString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// tests encoding a barcode containing full ASCII characters
- (void)testEncodeFullASCII
{
    BCKCode39FullASCII *codeFullASCII = [[BCKCode39FullASCII alloc] initWithContent:@"a"];
	NSString *expected = @"100101101101010010100100101101010010110100101101101";
	NSString *actual = [codeFullASCII bitString];
	BOOL isEqual = [expected isEqualToString:actual];
   
	STAssertTrue(isEqual, @"Result from encoding a full ASCII incorrect");
}

// tests encoding a barcode containing full ASCII characters with the Modulo-43 check character
- (void)testEncodeFullASCIIWithModulo43
{
    BCKCode39FullASCIIModulo43 *codeFullASCIIModulo43 = [[BCKCode39FullASCIIModulo43 alloc] initWithContent:@"a"];
	NSString *expected = @"1001011011010100101001001011010100101101101001011010100101101101";
	NSString *actual = [codeFullASCIIModulo43 bitString];
	BOOL isEqual = [expected isEqualToString:actual];

	STAssertTrue(isEqual, @"Result from encoding a full ASCII with Module-43 check character incorrect");
}

@end
