//
//  BCKBarcodeListViewController.m
//  BarCodeKitDemo
//
//  Created by Geoff Breemer on 31/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarcodeListViewController.h"
#import "BCKBarcodeViewController.h"
#import <objc/runtime.h>

@interface BCKBarcodeListViewController ()

@property (nonatomic) NSArray *barcodeTypes;            // Holds an array of NSStrings with the name of all BCKCode subclasses
@property (nonatomic) NSDictionary *barcodeSamples;     // Holds sample barcodes (the value) for each barcode subclass (the key) and a default one if a sample barcode is unavailable for a subclass
@end

@implementation BCKBarcodeListViewController

#define DEFAULT_BARCODE_KEY @"default"

#pragma mark - Other

// Returns an array of NSString objects of theClass' subclasses (direct subclasses only)
- (NSArray *)allSubclassesForClass:(Class)theClass
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

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Load the array of available BCKCode subclasses
	self.barcodeTypes = [self allSubclassesForClass:[BCKCode class]];
	
	// Load the sample barcodes from the property list
	NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"SampleBarcodes" ofType:@"plist"];
	self.barcodeSamples = [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.barcodeTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	Class barcodeClass = NSClassFromString(self.barcodeTypes[indexPath.row]);
	
	// Just display the Class name
	cell.textLabel.text = [barcodeClass barcodeDescription];
	cell.detailTextLabel.text = [barcodeClass barcodeStandard];
	
	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Pass the Class struct of the selected barcode type
	if ([[segue identifier] isEqualToString:@"showBarcode"])
	{
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		
		NSString *barcodeClassString = self.barcodeTypes[indexPath.row];
		Class barcodeClass = NSClassFromString(barcodeClassString);
		
		NSString *barcodeSample = [self.barcodeSamples valueForKey:barcodeClassString];
		
		if (!barcodeSample)
		{
			barcodeSample = [self.barcodeSamples valueForKey:DEFAULT_BARCODE_KEY];
		}
		
		[[segue destinationViewController] setBarcodeClass:barcodeClass andSampleContent:barcodeSample];
	}
}

@end
