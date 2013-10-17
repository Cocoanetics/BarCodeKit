//
//  BCKBarString.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 16/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 Supported bar types represented by their ASCII values.
 */
typedef NS_ENUM(NSUInteger, BCKBarType)
{
	/**
	 Bottom Half
	 */
    BCKBarTypeBottomHalf = 44,
    
	/**
	 A space
	 */
    BCKBarTypeSpace = 48,
	
	/**
	 Full bar
	 */
    BCKBarTypeFull = 49,
    
	/**
	 Top Two Thirds
	 */
    BCKBarTypeTopTwoThirds = 60,
    
    /**
	 Centre One Third
	 */
    BCKBarTypeCentreOneThird = 61,
    
	/**
	 Bottom Two Thirds
	 */
    BCKBarTypeBottomTwoThirds = 62,
    
	/**
	 Top Half
	 */
    BCKBarTypeTopHalf = 96
};

/**
 Class representing a string of bars of type BCKBarType. Receivers of this type are not mutable as opposed to BCKMutableBarString.
 */
@interface BCKBarString : NSObject <NSCopying, NSMutableCopying>
{
	// internal storage
	id _bars;
}

/**
 @name Initializing a Bar String
 */

/**
 Creates an empty bar string
 */
+ (instancetype)string;


/**
 @name Getting Information about Bar Strings
 */

/**
 Returns the number of bars in the bar string.
 @returns the length of the receiver
 */
- (NSUInteger)length;

/**
 Enumerate all bars in the bar string.
 */
- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType bar, NSUInteger idx, BOOL *stop))block;

@end
