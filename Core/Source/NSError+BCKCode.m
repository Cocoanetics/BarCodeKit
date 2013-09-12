//
//  NSError+BCKCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 12/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "NSError+BCKCode.h"

#define BARCODEKIT_ERROR_DOMAIN @"com.cocoanetics.barcodekit"
#define BARCODEKIT_ERROR_CODE 200

@implementation NSError (BCKCode)

+ (NSError *)BCKCodeErrorWithMessage:(NSString *)message
{
    NSError *error = nil;
    
    if(message)
    {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:message forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:BARCODEKIT_ERROR_DOMAIN code:BARCODEKIT_ERROR_CODE userInfo:details];
    }
    
    return error;
}

@end
