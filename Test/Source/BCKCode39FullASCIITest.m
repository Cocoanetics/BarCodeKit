//
//  BCKCode39FullASCIITest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 03/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39FullASCII.h"
#import "BCKCode39FullASCIIModulo43.h"
#import "BCKCode39CodeCharacter.h"

@interface BCKCode39FullASCII () // private

- (BCKBarString *)barString;

@end


@interface BCKCode39FullASCIITest : SenTestCase

@end

@implementation BCKCode39FullASCIITest

// tests encoding a basic word
- (void)testEncode
{
	NSError *error;
	BCKCode39FullASCII *code = [[BCKCode39FullASCII alloc] initWithContent:@"OLIVER" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"1001011011010110101101001010110101001101011010011010100110101011011010110010101101010110010100101101101");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

// tests encoding a barcode containing full ASCII characters
- (void)testEncodeFullASCII
{
	NSError *error;
	BCKCode39FullASCII *codeFullASCII = [[BCKCode39FullASCII alloc] initWithContent:@"a" error:&error];
	STAssertNotNil(codeFullASCII, [error localizedDescription]);

	BCKBarString *expected = BCKBarStringFromNSString(@"100101101101010010100100101101010010110100101101101");
	BCKBarString *actual = [codeFullASCII barString];
	BOOL isEqual = [expected isEqualToString:actual];
   
	STAssertTrue(isEqual, @"Result from encoding a full ASCII incorrect");
}

// tests encoding a barcode containing characters not included in full ASCII
- (void)testEncodeNonFullASCII
{
    NSError *error = nil;
    BOOL isEqual;
    
	BCKCode39FullASCII *codeFullASCII = [[BCKCode39FullASCII alloc] initWithContent:@"abcdö123" error:&error];
	STAssertNil(codeFullASCII, @"Should not be able to encode non full ASCII characters in BCKCode39FullASCII");
    
    isEqual = [[error localizedDescription] isEqualToString:@"Character at index 4 'ö' cannot be encoded in BCKCode39FullASCII"];
    
    STAssertNotNil(error, @"Error object should not be nil");
    STAssertTrue(isEqual, @"Error message should indicate invalid content");
}

// tests encoding a barcode containing full ASCII characters with the Modulo-43 check character
- (void)testEncodeFullASCIIWithModulo43
{
	NSError *error;
	BCKCode39FullASCIIModulo43 *codeFullASCIIModulo43 = [[BCKCode39FullASCIIModulo43 alloc] initWithContent:@"a" error:&error];
	STAssertNotNil(codeFullASCIIModulo43, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"1001011011010100101001001011010100101101101001011010100101101101");
	BCKBarString *actual = [codeFullASCIIModulo43 barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding a full ASCII with Module-43 check character incorrect");
}

@end
