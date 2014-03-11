//
//  BCKBarString.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 16/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 Supported bar types represented by their ASCII values. Note: The characters used for the internal representation are an implementation detail subject to change. Always use values from this enumeration in your code.
 */
typedef NS_ENUM(char, BCKBarType)
{
	/**
	 Bottom Half
	 */
    BCKBarTypeBottomHalf = ',',
    
	/**
	 A space
	 */
    BCKBarTypeSpace = '0',
	
	/**
	 Full bar
	 */
    BCKBarTypeFull = '1',
    
	/**
	 Top Two Thirds
	 */
    BCKBarTypeTopTwoThirds = '<',
    
    /**
	 Centre One Third
	 */
    BCKBarTypeCentreOneThird = '=',
    
	/**
	 Bottom Two Thirds
	 */
    BCKBarTypeBottomTwoThirds = '>',
    
	/**
	 Top Half
	 */
    BCKBarTypeTopHalf = '`'
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
 Creates an empty Bar String.
 */
+ (instancetype)string;

/**
 Creates a Bar String with a single bar.
 @param bar The BCKBarType to initialize the Bar String with.
 */
+ (instancetype)stringWithBar:(BCKBarType)bar;

/**
 @name Getting Information about Bar Strings
 */

/**
 Returns the number of bars in the Bar String.
 @returns the length of the receiver.
 */
- (NSUInteger)length;

/**
 Enumerate all bars in the Bar String.
 @param block The block to execute for each bar.
 */
- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType bar, NSUInteger idx, BOOL *stop))block;

/**
 Determines whether the last bar is of a particular bar type.
 @param bar The BCKBarType to look for.
 @returns `YES` if the receiver ends with this bar type.
 */
- (BOOL)endsWithBar:(BCKBarType)bar;

/**
 Determines whether the first bar is of a particular bar type
 @param bar The BCKBarType to look for.
 @returns `YES` if the receiver begins with this bar type.
 */
- (BOOL)beginsWithBar:(BCKBarType)bar;

/**
 Determines the bar at a given index.
 @param index The index.
 @returns The BCKBarType for the bar at the index.
 */
- (BCKBarType)barAtIndex:(NSUInteger)index;

/**
 Compares two Bar Strings.
 @param otherString The other Bar String to compare with.
 @returns `YES` if the Bar Strings are of equal value.
 */
- (BOOL)isEqualToString:(BCKBarString *)otherString;

@end
