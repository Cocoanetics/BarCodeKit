//
//  NSString+BCKCode128Helpers.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/1/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BCKCode128Helpers)

- (BOOL)containsOnlyNumbers;
- (BOOL)firstFourCharactersAreNumbers;
- (BOOL)firstTwoCharactersAreNumbers;

@end
