//
//  BCKCodabarCodeTest.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BCKCodabarCode.h"
#import "BCKCodabarCodeCharacter.h"

@interface BCKCodabarCode () // private

- (BCKBarString *)barString;

@end

@interface BCKCodabarCodeTest : SenTestCase

@end

@implementation BCKCodabarCodeTest

- (void)testIsStartStop
{
    NSError *error = nil;
	BCKCodabarCode *code = [[BCKCodabarCode alloc] initWithContent:@"A532263B" error:&error];
    
    // Loop through the codecharacters ensuring only the start/stop characters are marked as such
    [[code codeCharacters] enumerateObjectsUsingBlock:^(BCKCodabarCodeCharacter *obj, NSUInteger idx, BOOL *stop)
     {
         if ( (idx != 0) && (idx != ([[code codeCharacters] count] - 1)) )
         {
             STAssertFalse(obj.isStartStop, @"Regular characters should not have isStartStop equal to YES");
         }
         else
         {
             STAssertTrue(obj.isStartStop, @"Start and stop characters must have isStartStop equal to YES");
         }
     }];
}

- (void)testEncodeValid
{
	NSError *error;
	BCKCodabarCode *code = [[BCKCodabarCode alloc] initWithContent:@"A40156B" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"10110010010101101001010101001101010110010110101001010010101101001001011");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding incorrect");
}

- (void)testEncodeValidAlphaNumeric
{
	NSError *error;
	BCKCodabarCode *code = [[BCKCodabarCode alloc] initWithContent:@"A4-0$1:5/6.7+B" error:&error];
	STAssertNotNil(code, [error localizedDescription]);
	
	BCKBarString *expected = BCKBarStringFromNSString(@"1011001001010110100101010011010101010011010110010101010110010110101101101101010010110110101101001010110110110110101001011010101101101101001001011");
	BCKBarString *actual = [code barString];
	BOOL isEqual = [expected isEqualToString:actual];
	
	STAssertTrue(isEqual, @"Result from encoding alpha numeric characters is incorrect");
}

- (void)testEncodeInvalid
{
	NSError *error = nil;
	BCKCodabarCode *code = nil;
	
	code = [[BCKCodabarCode alloc] initWithContent:@"AA" error:&error];
	STAssertNil(code, @"Should have at least one character in addition to one start and one stop character in Codabar");
	STAssertNotNil(error, @"Error object should not be nil");
	error = nil;
	code = nil;
	
	code = [[BCKCodabarCode alloc] initWithContent:@"1234A" error:&error];
	STAssertNil(code, @"Should have valid start character in Codabar");
	STAssertNotNil(error, @"Error object should not be nil");
	error = nil;
	code = nil;
	
	code = [[BCKCodabarCode alloc] initWithContent:@"A2343" error:&error];
	STAssertNil(code, @"Should have valid stop character in Codabar");
	STAssertNotNil(error, @"Error object should not be nil");
	error = nil;
	code = nil;
	
	code = [[BCKCodabarCode alloc] initWithContent:@"A23a43B" error:&error];
	STAssertNil(code, @"Should have valid characters in Codabar");
	STAssertNotNil(error, @"Error object should not be nil");
	error = nil;
	code = nil;
}


@end
