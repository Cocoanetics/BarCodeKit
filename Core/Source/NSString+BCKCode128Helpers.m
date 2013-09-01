//
//  NSString+BCKCode128Helpers.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/1/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "NSString+BCKCode128Helpers.h"

@implementation NSString (BCKCode128Helpers)

- (BOOL)containsOnlyNumbers
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] length] == 0;
}


@end
