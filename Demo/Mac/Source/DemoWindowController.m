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
    if (self)
	 {
		 _barScale = 1.0;
		 _captionOverlap = 0;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
   
	// Load the array of available BCKCode subclasses
	self.barcodeTypes = [self _allSubclassesForClass:[BCKCode class]];
	
	// Load the sample barcodes from the property list
	NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"SampleBarcodes" ofType:@"plist"];
	_barcodeSamples = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	self.selectedIndex = 0;
	
	// setup defaults
	self.showCaption = [[NSUserDefaults standardUserDefaults] boolForKey:@"BCKDemoShowCaption"];
}

#pragma mark - Utilities

// Returns an array of NSString objects of theClass' subclasses (direct subclasses only)
- (NSArray *)_allSubclassesForClass:(Class)theClass
{
	NSMutableArray *tmpArray = [NSMutableArray array];
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
			
			NSDictionary *codeDict = @{@"Description": [barcodeClass barcodeDescription],
												@"Standard": [barcodeClass barcodeStandard],
												@"ClassName": NSStringFromClass(barcodeClass),
												@"Class": barcodeClass};
			[tmpArray addObject:codeDict];
		}
	}
	
	free(classes);
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"Description" ascending:YES];
	return [tmpArray sortedArrayUsingDescriptors:@[sort]];
}

- (void)_updateSampleContent
{
	NSDictionary *selectedDict = _barcodeTypes[_selectedIndex];
	NSString *className = selectedDict[@"ClassName"];
	NSString *sampleContent = _barcodeSamples[className];
	
	if (!sampleContent)
	{
		sampleContent = _barcodeSamples[@"default"];
	}
	
	if ([sampleContent length])
	{
		self.contentText = sampleContent;
	}
}

- (void)_updateWithOptions
{
	NSDictionary *selectedDict = _barcodeTypes[_selectedIndex];
	Class class = selectedDict[@"Class"];

	// Initialise barcode contents using the text in the textfield
	NSError *error;
	_barcodeObject = [[class alloc] initWithContent:_contentText error:&error];

	
	// Draw the barcode. If the barcode doesn't support the content clear the image and show the error message, disable all controls except the text field
	if (_barcodeObject)
	{
		self.canFillQuietZones = [_barcodeObject allowsFillingOfEmptyQuietZones];
		self.canShowCaption = [_barcodeObject respondsToSelector:@selector(captionTextForZone:withRenderOptions:)];
		self.canShowDebug = _canShowCaption;
		self.canOverlapCaption = [_barcodeObject markerBarsCanOverlapBottomCaption];
		self.canShowCheckDigits = [_barcodeObject showCheckDigitsInCaption];
		self.errorMessage = nil;
	}
	else
	{
		self.canFillQuietZones = NO;
		self.canShowCaption = NO;
		self.canOverlapCaption = NO;
		self.canShowCheckDigits = NO;
		self.canShowDebug = NO;

		self.barcodeImage = nil;
		self.errorMessage = [NSString stringWithFormat:@"Encoding error: %@\n\nPlease try a different contents.", [error localizedDescription]];
	}
}

#pragma mark - Data Binding

- (NSString *)barcodeStandard
{
	NSDictionary *selectedDict = _barcodeTypes[_selectedIndex];
	return selectedDict[@"Standard"];
}

+ (NSSet *)keyPathsForValuesAffectingBarcodeStandard
{
	return [NSSet setWithObject:@"selectedIndex"];
}

+ (NSSet *)keyPathsForValuesAffectingBarcodeObject
{
	return [NSSet setWithObject:@"selectedIndex"];
}

+ (NSSet *)keyPathsForValuesAffectingFillQuietZones
{
	return [NSSet setWithObject:@"canFillQuietZones"];
}

+ (NSSet *)keyPathsForValuesAffectingShowCheckDigits
{
	return [NSSet setWithObject:@"canShowCheckDigits"];
}

+ (NSSet *)keyPathsForValuesAffectingBarcodeImage
{
	return [NSSet setWithArray:@[@"barScale", @"selectedIndex", @"showDebug", @"contentText", @"fillQuietZones", @"showCheckDigits", @"showCaption", @"captionOverlap"]];
}

+ (NSSet *)keyPathsForValuesAffectingShowCaption
{
	return [NSSet setWithObject:@"canShowCaption"];
}

+ (NSSet *)keyPathsForValuesAffectingShowDebug
{
	return [NSSet setWithObject:@"canShowDebug"];
}

#pragma mark - Properties

- (NSImage *)barcodeImage
{
	if (!_barcodeObject)
	{
		return nil;
	}
	
	// round bar scale to half points
	CGFloat barScale = roundf(_barScale);
	
	NSDictionary *options = @{BCKCodeDrawingBarScaleOption: @(barScale),
									  BCKCodeDrawingFillEmptyQuietZonesOption: @(_fillQuietZones),
									  BCKCodeDrawingDebugOption: @(_showDebug),
									  BCKCodeDrawingPrintCaptionOption: @(_showCaption),
									  BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption: @(_captionOverlap),
									  BCKCodeDrawingShowCheckDigitsOption: @(_showCheckDigits),
									  BCKCodeDrawingBackgroundColorOption: [NSColor whiteColor]};

	return [NSImage imageWithBarCode:_barcodeObject options:options];
}



- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
	[self willChangeValueForKey:@"selectedIndex"];
	
	_selectedIndex = selectedIndex;
	
	[self didChangeValueForKey:@"selectedIndex"];
	
	[self _updateSampleContent];
	
	[self _updateWithOptions];
}

- (void)setContentText:(NSString *)contentText
{
	[self willChangeValueForKey:@"contentText"];
	
	_contentText = contentText;
	
	[self didChangeValueForKey:@"contentText"];
	
	[self _updateWithOptions];
}

- (void)setBarScale:(CGFloat)barScale
{
	[self willChangeValueForKey:@"barScale"];
	
	_barScale = barScale;
	
	[self didChangeValueForKey:@"barScale"];
	
	[self _updateWithOptions];
}

- (BOOL)showDebug
{
	if (_canShowDebug)
	{
		return _showDebug;
	}
	
	return NO;
}

- (BOOL)showCaption
{
	if (_canShowCaption)
	{
		return _showCaption;
	}
	
	return NO;
}



- (BOOL)showCheckDigits
{
	if (_canShowCheckDigits)
	{
		return _showCheckDigits;
	}
	
	return NO;
}



- (BOOL)fillQuietZones
{
	if (_canFillQuietZones)
	{
		return _fillQuietZones;
	}
	
	return NO;
}


@synthesize barcodeTypes = _barcodeTypes;
@synthesize barcodeArrayController = _barcodeArrayController;

@end
