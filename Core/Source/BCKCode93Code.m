//
//  BCKCode93Code.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93Code.h"
#import "BCKCode93CodeCharacter.h"
#import "BCKCode93ContentCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKCode93Code

#define FIRSTMODULO47MAXWEIGHT 20       // the weight ranges from 1 to 20 for the first modulo-47 check
#define SECONDMODULO47MAXWEIGHT 15      // the weight ranges from 1 to 15 for the second modulo-47 check

// Pass the appropriate option to generate the first or second modulo-47 check character
NSString * const BCKCode93Modulo47CheckCharacterFirstOption = @"BCKCode93Modulo47CheckCharacterFirst";
NSString * const BCKCode93Modulo47CheckCharacterSecondOption = @"BCKCode93Modulo47CheckCharacterSecond";

#pragma mark Helper Methods

// source: http://en.wikipedia.org/wiki/Code_93#Full_ASCII_Code_93

// Returns the Code93 representation of all supported ASCII characters, including Full ASCII
+ (NSString *)_fullASCIIEncoding:(NSString *)character
{
	NSDictionary *encodingDictionary = @{
													 @"␀": @"(%)U",
													 @"␁": @"($)A",
													 @"␂": @"($)B",
													 @"␃": @"($)C",
													 @"␄": @"($)D",
													 @"␅": @"($)E",
													 @"␆": @"($)F",
													 @"␇": @"($)G",
													 @"␈": @"($)H",
													 @"␉": @"($)I",
													 @"␊": @"($)J",
													 @"␋": @"($)K",
													 @"␌": @"($)L",
													 @"␍": @"($)M",
													 @"␎": @"($)N",
													 @"␏": @"($)O",
													 @"␐": @"($)P",
													 @"␑": @"($)Q",
													 @"␒": @"($)R",
													 @"␓": @"($)S",
													 @"␔": @"($)T",
													 @"␕": @"($)U",
													 @"␖": @"($)V",
													 @"␗": @"($)W",
													 @"␘": @"($)X",
													 @"␙": @"($)Y",
													 @"␚": @"($)Z",
													 @"␛": @"(%)A",
													 @"␜": @"(%)B",
													 @"␝": @"(%)C",
													 @"␞": @"(%)D",
													 @"␟": @"(%)E",
													 @" ": @" ",
													 @"!": @"(/)A",
													 @"\"": @"(/)B",
													 @"#": @"(/)C",
													 @"$": @"(/)D",
													 @"%": @"(/)E",
													 @"&": @"(/)F",
													 @"'": @"(/)G",
													 @"(": @"(/)H",
													 @")": @"(/)I",
													 @"*": @"(/)J",
													 @"+": @"(/)K",
													 @",": @"(/)L",
													 @"-": @"-",
													 @".": @".",
													 @"/": @"(/)O",
													 @"0": @"0",
													 @"1": @"1",
													 @"2": @"2",
													 @"3": @"3",
													 @"4": @"4",
													 @"5": @"5",
													 @"6": @"6",
													 @"7": @"7",
													 @"8": @"8",
													 @"9": @"9",
													 @":": @"(/)Z",
													 @";": @"(%)F",
													 @"<": @"(%)G",
													 @"=": @"(%)H",
													 @">": @"(%)I",
													 @"?": @"(%)J",
													 @"@": @"(%)V",
													 @"A": @"A",
													 @"B": @"B",
													 @"C": @"C",
													 @"D": @"D",
													 @"E": @"E",
													 @"F": @"F",
													 @"G": @"G",
													 @"H": @"H",
													 @"I": @"I",
													 @"J": @"J",
													 @"K": @"K",
													 @"L": @"L",
													 @"M": @"M",
													 @"N": @"N",
													 @"O": @"O",
													 @"P": @"P",
													 @"Q": @"Q",
													 @"R": @"R",
													 @"S": @"S",
													 @"T": @"T",
													 @"U": @"U",
													 @"V": @"V",
													 @"W": @"W",
													 @"X": @"X",
													 @"Y": @"Y",
													 @"Z": @"Z",
													 @"[": @"(%)K",
													 @"\\": @"(%)L",
													 @"]": @"(%)M",
													 @"^": @"(%)N",
													 @"_": @"(%)O",
													 @"`": @"(%)W",
													 @"a": @"(+)A",
													 @"b": @"(+)B",
													 @"c": @"(+)C",
													 @"d": @"(+)D",
													 @"e": @"(+)E",
													 @"f": @"(+)F",
													 @"g": @"(+)G",
													 @"h": @"(+)H",
													 @"i": @"(+)I",
													 @"j": @"(+)J",
													 @"k": @"(+)K",
													 @"l": @"(+)L",
													 @"m": @"(+)M",
													 @"n": @"(+)N",
													 @"o": @"(+)O",
													 @"p": @"(+)P",
													 @"q": @"(+)Q",
													 @"r": @"(+)R",
													 @"s": @"(+)S",
													 @"t": @"(+)T",
													 @"u": @"(+)U",
													 @"v": @"(+)V",
													 @"w": @"(+)W",
													 @"x": @"(+)X",
													 @"y": @"(+)Y",
													 @"z": @"(+)Z",
													 @"{": @"(%)P",
													 @"|": @"(%)Q",
													 @"}": @"(%)R",
													 @"~": @"(%)S",
													 @"␡": @"(%)T",
													 @"␡": @"(%)X",
													 @"␡": @"(%)Y",
													 @"␡": @"(%)Z"
													 };
	
	return [encodingDictionary valueForKey:character];
}

// Generate the modulo-47 check character "C" (first) or "K" (second)
- (BCKCode93ContentCodeCharacter *)_generateModulo47:(NSString *)checkCharacterOption forContentCodeCharacters:(NSArray *)contentCodeCharacters
{
	__block NSUInteger weightedSum = 0;
	__block NSUInteger weight = 1;
	
	if (![checkCharacterOption isEqualToString:BCKCode93Modulo47CheckCharacterFirstOption] && ![checkCharacterOption isEqualToString:BCKCode93Modulo47CheckCharacterSecondOption])
	{
		return nil;
	}
   
	// Add the product of each content code character's value and their weights to the weighted sum.
	// Weights start at 1 from the rightmost content code character, increasing to a maximum depending on whether the "C" or "K" check is being generated, then starting from 1 again
	[contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKCode93ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
		
		weightedSum+=weight * [obj characterValue];
		weight++;
		
		if ([checkCharacterOption isEqualToString:BCKCode93Modulo47CheckCharacterFirstOption])
		{
			if (weight>FIRSTMODULO47MAXWEIGHT)
			{
				weight = 1;
			}
		}
		else
		{
			if (weight>SECONDMODULO47MAXWEIGHT)
			{
				weight = 1;
			}
		}
	}];
	
	// Return the check character by taking the weighted sum modulo 47
	return [[BCKCode93ContentCodeCharacter alloc] initWithValue:(weightedSum % 47)];
}

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		
        // Check the encoding dictionary to ensure all characters are encodable
		if (![BCKCode93Code _fullASCIIEncoding:character])
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Character at index %d '%@' cannot be encoded in %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
	}
	
	return YES;
}

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"Code 93 Full ASCII";
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
   
	// Array that holds all code characters, including start/stop, termination bar, modulo-7 check characters and any
	// special characters required to represent any full ASCII characters included in the content
	NSMutableArray *finalArray = [NSMutableArray array];
	NSMutableArray *contentCharacterArray = [NSMutableArray array]; // Holds the code characters for just the content
	BCKCode93CodeCharacter *tmpCharacter = nil;
	
	// Add the start code character *
	[finalArray addObject:[BCKCode93CodeCharacter startStopCodeCharacter]];
	
	// Encode the barcode's content and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		NSString *characterEncoding = [BCKCode93Code _fullASCIIEncoding:character];
		
		if ([characterEncoding length]==1)
		{
			tmpCharacter = [BCKCode93CodeCharacter codeCharacterForCharacter:character];
			[contentCharacterArray addObject:tmpCharacter];
		}
		else
		{
			// Create the two ContentCodeCharacters and add to array
			tmpCharacter = [BCKCode93CodeCharacter codeCharacterForCharacter:[characterEncoding substringWithRange:NSMakeRange(0, 3)]];
			[contentCharacterArray addObject:tmpCharacter];
			
			tmpCharacter = [BCKCode93CodeCharacter codeCharacterForCharacter:[characterEncoding substringWithRange:NSMakeRange(3, 1)]];
			[contentCharacterArray addObject:tmpCharacter];
		}
	}
	
	[finalArray addObjectsFromArray:contentCharacterArray];
	
	// Add the first modulo-47 check character "C" to the contentCharacterArray and the finalArray
	tmpCharacter = [self _generateModulo47:BCKCode93Modulo47CheckCharacterFirstOption forContentCodeCharacters:contentCharacterArray];
	[finalArray addObject:tmpCharacter];
	[contentCharacterArray addObject:tmpCharacter];
	
	// Add the second modulo-47 check character "K" (include the first mdulo-47 check character code "C")
	tmpCharacter = [self _generateModulo47:BCKCode93Modulo47CheckCharacterSecondOption forContentCodeCharacters:contentCharacterArray];
	[finalArray addObject:tmpCharacter];
	
	// Add the stop code character *
	[finalArray addObject:[BCKCode93CodeCharacter startStopCodeCharacter]];
	
	// Add the termination bar
	[finalArray addObject:[BCKCode93CodeCharacter terminationBarCodeCharacter]];
	
	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

// The horizontal quiet zone width (starting and trailing) should be at least 6.35mm. With an X-dimension of 0.19mm this equals 34 bars (rounded up)
- (NSUInteger)horizontalQuietZoneWidth
{
	return 17;
}

- (CGFloat)aspectRatio
{
	return 0;
}

// The bar height should be at least 15% of the symbol (barcode) lenght, or 6.35mm (34 bars), whichever is greater. Returning a fixed height of 34 for now.
- (CGFloat)fixedHeight
{
	return 34;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
		return _content;
	}
	
	return nil;
}

@end