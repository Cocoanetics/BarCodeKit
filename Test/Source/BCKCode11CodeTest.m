//
//  BCKCode11CodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode11Code.h"
#import "BCKCode11CodeCharacter.h"

@interface BCKCode11Code () // private

- (BCKBarString *)barString;

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
	NSError *error;
	BCKCode11Code *code = [[BCKCode11Code alloc] initWithContent:@"123-45" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"1011001011010110100101101100101010110101011011011011010110110101011001");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testEncodeLong
{
	NSError *error;
	BCKCode11Code *code = [[BCKCode11Code alloc] initWithContent:@"01234528987" error:NULL];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"101100101010110110101101001011011001010101101101101101010010110110100101101010110100101010011010110110110100101011001");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];

	STAssertTrue(isEqual, @"Result from encoding long contents incorrect");
}

// tests encoding a barcode containing characters not included in full ASCII
- (void)testEncodeInvalid
{
    NSError *error = nil;
    BOOL isEqual;
    
	BCKCode11Code *codeFullASCII = [[BCKCode11Code alloc] initWithContent:@"123ö45" error:&error];
	STAssertNil(codeFullASCII, @"Should not be able to encode invalid characters in BCKCode11Code");
    
    isEqual = [[error localizedDescription] isEqualToString:@"Character at index 3 'ö' cannot be encoded in BCKCode11Code"];
    
    STAssertNotNil(error, @"Error object should not be nil");
    STAssertTrue(isEqual, @"Error message should indicate invalid content");
}

@end
