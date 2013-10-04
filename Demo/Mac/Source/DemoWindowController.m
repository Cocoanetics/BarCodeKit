//
//  DemoWindowController.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 10/3/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "DemoWindowController.h"
#import <objc/runtime.h>

#import "BarCodeKit.h"

@interface DemoWindowController ()

@end

@implementation DemoWindowController
{
	NSArray *_barcodeTypes;
	NSDictionary *_barcodeSamples;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
	// Load the array of available BCKCode subclasses
	_barcodeTypes = [self _allSubclassesForClass:[BCKCode class]];
	
	// Load the sample barcodes from the property list
	NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"SampleBarcodes" ofType:@"plist"];
	_barcodeSamples = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	self.barcodeArrayController.content = _barcodeTypes;
}




#pragma mark - Utilities

// Returns an array of NSString objects of theClass' subclasses (direct subclasses only)
- (NSArray *)_allSubclassesForClass:(Class)theClass
{
	NSMutableArray *mySubclasses = [NSMutableArray array];
	unsigned int numOfClasses;
	
	Class *classes = objc_copyClassList(&numOfClasses);
	
	for (unsigned int ci = 0; ci < numOfClasses; ci++)
	{
		Class superClass = classes[ci];
		
		do
		{
			superClass = class_getSuperclass(superClass);
		}
		while (superClass && superClass != theClass);
		
		if (superClass == theClass)
		{
			Class barcodeClass = classes[ci];
			
			if (![barcodeClass barcodeDescription])
			{
				// skip abstract class
				continue;
			}
			
			// change to (superClass) to find all descendants, not just the direct ones
			[mySubclasses addObject: NSStringFromClass(barcodeClass)];
		}
	}
	
	free(classes);
	
	// Sort alphabetically and return the array
	return [mySubclasses sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

@synthesize barcodeTypes = _barcodeTypes;
@synthesize barcodeArrayController = _barcodeArrayController;

@end
