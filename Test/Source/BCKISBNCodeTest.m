//
//  BCKISBNCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 28/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BCKISBNCode.h"

@interface BCKISBNCode () // private

- (BCKBarString *)barString;
- (NSString *)titleText;

@end

@interface BCKISBNCodeTest : SenTestCase

@end

@implementation BCKISBNCodeTest

// Test initialising an ISBN code by passing ISBN elements with and without a check digit
- (void)testEncodeValid
{
    BCKISBNCode *code;
    NSError *error;

    // ISBN13 with check digit
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"3" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"0" error:&error];
    STAssertNotNil(code, @"Should be able to encode ISBN13 code with check digit");
    STAssertEqualObjects(code.titleText, @"ISBN 978-3-16-148410-0", @"ISBN13 code with check digit incorrect title text");
    STAssertEqualObjects(code.content, @"9783161484100", @"ISBN13 code with check digit encoded incorrectly");
    STAssertNil(error, @"NSError should be nil");

    // ISBN13 without check digit
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"3" andRegistrant:@"16" andPublication:@"148410" error:&error];
    STAssertNotNil(code, @"Should be able to encode ISBN13 code without check digit");
    STAssertEqualObjects(code.titleText, @"ISBN 978-3-16-148410-0", @"ISBN13 code without check digit incorrect title text");
    STAssertEqualObjects(code.content, @"9783161484100", @"ISBN13 code without check digit encoded incorrectly");
    STAssertNil(error, @"NSError should be nil");

    // ISBN10 with check digit
    code = [[BCKISBNCode alloc] initWithPrefix:nil andRegistrationGroup:@"3" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNotNil(code, @"Should be able to encode ISBN10 code with check digit");
    STAssertEqualObjects(code.titleText, @"ISBN 3-16-148410-X", @"ISBN10 code with check digit incorrect title text");
    STAssertEqualObjects(code.content, @"9783161484100", @"ISBN10 code with check digit encoded incorrectly");
    STAssertNil(error, @"NSError should be nil");
    
    // ISBN10 without check digit
    code = [[BCKISBNCode alloc] initWithPrefix:nil andRegistrationGroup:@"3" andRegistrant:@"16" andPublication:@"148410" error:&error];
    STAssertNotNil(code, @"Should be able to encode ISBN10 code without check digit");
    STAssertEqualObjects(code.titleText, @"ISBN 3-16-148410-X", @"ISBN10 code without check digit incorrect title text");
    STAssertEqualObjects(code.content, @"9783161484100", @"ISBN10 code without check digit encoded incorrectly");
    STAssertNil(error, @"NSError should be nil");
}

// Test ISBN check digit calculation
- (void)testISBNCheckDigits
{
    BCKISBNCode *code;
    NSError *error;

    // ISBN13 with check digit
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"3" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"0" error:&error];
    STAssertEqualObjects(code.content, @"9783161484100", @"ISBN13 with check digit should generate correct check digit");

    // ISBN13 without check digit
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"3" andRegistrant:@"16" andPublication:@"148410" error:&error];
    STAssertEqualObjects(code.content, @"9783161484100", @"ISBN13 without check digit should generate correct check digit");

    // ISBN10 with check digit
    code = [[BCKISBNCode alloc] initWithPrefix:nil andRegistrationGroup:@"0" andRegistrant:@"306" andPublication:@"40615" andCheckDigit:@"2" error:&error];
    STAssertEqualObjects(code.content, @"9780306406157", @"ISBN10 with check digit should generate correct check digit");

    // ISBN10 without check digit
    code = [[BCKISBNCode alloc] initWithPrefix:nil andRegistrationGroup:@"0" andRegistrant:@"306" andPublication:@"40615" error:&error];
    STAssertEqualObjects(code.content, @"9780306406157", @"ISBN10 without check digit should generate correct check digit");
}

// Test initialising an ISBN code by passing the ISBN string
- (void)testEncodeUsingValidString
{
    BCKISBNCode *code;
    NSError *error;

    // ISBN13 check digit = EAN check digit
    code = [[BCKISBNCode alloc] initWithContent:@"978-3-16-148410-0" error:&error];
    STAssertEqualObjects(code.content, @"9783161484100", @"Should be able to initialise ISBN13 with string");
    STAssertEqualObjects(code.titleText, @"ISBN 978-3-16-148410-0", @"Should be able to initialise title text for ISBN13 with string");

    // ISBN10 check digit = EAN check digit
    code = [[BCKISBNCode alloc] initWithContent:@"3-16-148410-X" error:&error];
    STAssertEqualObjects(code.content, @"9783161484100", @"Should be able to initialise ISBN10 with string");
    STAssertEqualObjects(code.titleText, @"ISBN 3-16-148410-X", @"Should be able to initialise title text for ISBN10 with string");

    // ISBN10 check digit != EAN check digit
    code = [[BCKISBNCode alloc] initWithContent:@"81-7525-766-0" error:&error];
    STAssertEqualObjects(code.content, @"9788175257665", @"Should be able to initialise ISBN10 with string");
    STAssertEqualObjects(code.titleText, @"ISBN 81-7525-766-0", @"Should be able to initialise title text for ISBN10 with string");

    // ISBN10 check digit = "X"
    code = [[BCKISBNCode alloc] initWithContent:@"3-16-148410-X" error:&error];
    STAssertEqualObjects(code.content, @"9783161484100", @"Should be able to initialise ISBN10 with string");
    STAssertEqualObjects(code.titleText, @"ISBN 3-16-148410-X", @"Should be able to initialise title text for ISBN10 with string");

    // ISBN10 check digit = "x"
    code = [[BCKISBNCode alloc] initWithContent:@"3-16-148410-x" error:&error];
    STAssertEqualObjects(code.content, @"9783161484100", @"Should be able to initialise ISBN10 with string");
    STAssertEqualObjects(code.titleText, @"ISBN 3-16-148410-x", @"Should be able to initialise title text for ISBN10 with string");
}

// Test initialising an ISBN code by passing an invalid ISBN string
- (void)testEncodeUsingInvalidString
{
    BCKISBNCode *code;
    NSError *error;
    
    code = [[BCKISBNCode alloc] initWithContent:@"978-3-16-148410-X" error:&error];
    STAssertNil(code, @"Should not be able to include 'X' in ISBN13 string");

    code = [[BCKISBNCode alloc] initWithContent:@"978--316-148410-0" error:&error];
    STAssertNil(code, @"Should not be able to include 'empty' elements in ISBN13 string");

    code = [[BCKISBNCode alloc] initWithContent:@"316--148410-X" error:&error];
    STAssertNil(code, @"Should not be able to include 'empty' elements in ISBN10 string");

    code = [[BCKISBNCode alloc] initWithContent:@"316-148410--X" error:&error];
    STAssertNil(code, @"Should not be able to include 'empty' elements in ISBN10 string");

    code = [[BCKISBNCode alloc] initWithContent:@"3-16-48410-X" error:&error];
    STAssertNil(code, @"Should not be able to encode ISBN10 strings with less than 10 characters");

    code = [[BCKISBNCode alloc] initWithContent:@"978-3-16-48410-0" error:&error];
    STAssertNil(code, @"Should not be able to encode ISBN13 strings with less than 13 characters");

    code = [[BCKISBNCode alloc] initWithContent:@"978-3-16-148410-x" error:&error];
    STAssertNil(code, @"Should not be able to include 'x' in ISBN13 string");
}

- (void)testEncodeUsingInvalidRegistrant
{
    BCKISBNCode *code;
    NSError *error;
    
    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"951" andRegistrant:@"" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: too short");
    
    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"951" andRegistrant:@"12345678" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: too long");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"951" andRegistrant:@"2" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 2");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"951" andRegistrant:@"55" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 55");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"951" andRegistrant:@"890" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 890");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"951" andRegistrant:@"9500" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 9500");

}

- (void)testEncodeUsingInvalidRegistrationGroup
{
    BCKISBNCode *code;
    NSError *error;

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: too short");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"123456" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: too long");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"6" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 6");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"95" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 95");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"990" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 990");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"978" andRegistrationGroup:@"9999" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 9999");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"979" andRegistrationGroup:@"9" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 9");

    error = nil;
    code = [[BCKISBNCode alloc] initWithPrefix:@"979" andRegistrationGroup:@"12" andRegistrant:@"16" andPublication:@"148410" andCheckDigit:@"X" error:&error];
    STAssertNil(code, @"Should not be able to encode invalid Registation Group: 12");
}

@end
