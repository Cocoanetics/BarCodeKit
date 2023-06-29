//
//  BCKBarStringFunctions.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 17.10.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarString.h"

// Method to convert an NSString into a BCKBarString
BCKBarString *BCKBarStringFromNSString(NSString *string);

// Method to convert a BCKBarString to an NSString
NSString *BCKBarStringToNSString(BCKBarString *string);

