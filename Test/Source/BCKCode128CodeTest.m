//
//  BCKCode128CodeTest.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128Code.h"

@interface BCKCode128Code () // private

- (NSString *)bitString;

@end

@interface BCKCode128CodeTest : SenTestCase

@end

@implementation BCKCode128CodeTest

- (void)testEncodingOneCharacter
{
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"J"];
    NSString *expected = @"11010000100 10110111000 10110111000 1100011101011";
    expected = [expected stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *actual = [code bitString];
    BOOL isEqual = [expected isEqualToString:actual];
    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testEncodingWikipedia
{
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"Wikipedia"];
    NSString *expected = @"1001011011010110101101001010110101001101011010011010100110101011011010110010101101010110010100101101101";
    NSString *actual = [code bitString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testAppleStoreCodeEncoding
{
    BCKCode128Code *code = [[BCKCode128Code alloc] initWithContent:@"CAM395A"];
    NSString *expected = @"1001011011010110101101001010110101001101011010011010100110101011011010110010101101010110010100101101101";
    NSString *actual = [code bitString];
    BOOL isEqual = [expected isEqualToString:actual];

    STAssertTrue(isEqual, @"Result from encoding incorrect");
}

@end
