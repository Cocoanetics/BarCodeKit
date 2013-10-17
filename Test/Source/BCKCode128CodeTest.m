//
//  BCKCode128CodeTest.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128Code.h"
#import "BCKCodeCharacter.h"

@interface BCKCode128Code () // private

- (BCKBarString *)barString;

@end

@interface BCKCode128CodeTest : SenTestCase

@end

@implementation BCKCode128CodeTest

- (void)testEncodingOneCharacter
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"J" error:&error];
 	STAssertNotNil(code, [error localizedDescription]);

	BCKBarString *expected = BCKBarStringFromNSString(@"11010000100 10110111000 10110111000 1100011101011");
    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];
    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testEncodingWikipedia
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"Wikipedia" error:&error];
    BCKBarString *expected = BCKBarStringFromNSString(@"11010010000111010001101000011010011000010010100001101001010011110010110010000100001001101000011010010010110000111100100101100011101011");
    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testAppleStoreCodeEncoding
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"CAM395A" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"1101000010010001000110101000110001011101100011001011100111001011001101110010010100011000100001101001100011101011");
    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testSymbolsEncoding
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"'&%$#\"! ~_|}" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"11010010000100110001001001100100010001001100100100011001001001100011001100110110011011001101100110010001011110101001100001010111100010100011110100111101001100011101011");
    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testOnlyNumberPairsCodeWillBeEncodedUsing128C
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"12345678" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"1101001110010110011100100010110001110001011011000010100100011101101100011101011");
    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testEncodingUnevenCountOfNumbersUsing128C
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"123456789" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"11010011100101100111001000101100011100010110110000101001110101111011100101100100111101001100011101011");
    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testLengthOptimizationNumbersAtEnd
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"HI345678" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"11010000100 11000101000 11000100010 10111011110 10001011000 11100010110 11000010100 10000101100 1100011101011");

    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testLengthOptimizationNumbersAtBeginning
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"345678HI" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"1101000010010111011110100010110001110001011011000010100111010111101100010100011000100010110110001101100011101011");

    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testSwitchToCode128DoneWith6NumbersInMiddle
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"TE123456ST" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"11010000100 11011100010 10001101000 10111011110 10110011100 10001011000 11100010110 11101011110 11011101000 11011100010 11110010010 1100011101011");

    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testSwitchToCode128NotDoneWith4NumbersInMiddle
{
	NSError *error;
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"TE1234ST" error:&error];
	STAssertNotNil(code, [error localizedDescription]);

    BCKBarString *expected = BCKBarStringFromNSString(@"11010000100 11011100010 10001101000 10011100110 11001110010 11001011100 11001001110 11011101000 11011100010 11001101100 1100011101011");

    BCKBarString *actual = [code barString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testUnsupportedCharacterGivesMeaningfulError
{
	NSError *error;
	BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"Ö" error:&error];

	STAssertNil(code, @"Should have not created code with unsupported character");
	STAssertNotNil(error, @"Should have assigned error");
}

@end
