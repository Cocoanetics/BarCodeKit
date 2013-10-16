//
//  BCKBarString.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 16/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 The seven supported bar types represented by their ASCII values
 */
typedef NS_ENUM(NSUInteger, BCKBarType) {
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
 Class representing a string of bars
 */
@interface BCKBarString : NSObject <NSCopying>

/**
 Append a bar to the end of the existing bar string.
 @param barType The type of the bar to be appended.
 @return A boolean indicating whether the method completed successfully. Returns `NO` if the barType could not be appended, the error object will then contain error details.
*/
- (BOOL)appendBar:(BCKBarType)barType error:(NSError **)error;

/**
 Returns the number of bars in the bar string
 */
- (NSUInteger)count;

/**
 Enumerate all bars in the bar string
 */
- (void)enumerateObjectsUsingBlock:(void (^)(BCKBarType bar, NSUInteger idx, BOOL *stop))block;

/**
 The array holding the bars that the bar string comprises
 */
@property (nonatomic, readonly) NSMutableArray *barArray;

@end
