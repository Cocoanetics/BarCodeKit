//
//  BCKBarcodeViewController.m
//  BarCodeKitDemo
//
//  Created by Geoff Breemer on 31/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarcodeViewController.h"
#import "UIImage+BarCodeKit.h"
#import <objc/runtime.h>

@interface BCKBarcodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end

@implementation BCKBarcodeViewController
{
	Class _barcodeClass;
	NSString *_sampleContent;
	
    BCKCode *_barcodeObject;
    NSArray *_barcodeOptions;
    
	// Options controls
	UISwitch *_captionSwitch;
	UISwitch *_debugSwitch;
	UISwitch *_fillQuietZonesSwitch;
	UISlider *_barScaleSlider;
	UISlider *_captionOverlapSlider;
	UITextField *_contentsTextField;
	UISwitch *_checkDigitsInCaptionSwitch;
	
	// Options variables
	BOOL _captionOption;
	BOOL _debugOption;
	BOOL _fillOption;
    BOOL _checkDigitsInCaptionOption;
	CGFloat _barScale;
	CGFloat _captionOverlap;
}

#pragma mark - Initialisation

// Use this method to pass all model information (the name of the BCKCode subclass and the sample barcode) to the viewcontroller
- (void)setBarcodeClass:(Class)barcodeClass andSampleContent:(NSString *)sampleContent;
{
	_barcodeClass = barcodeClass;
	_sampleContent = [sampleContent copy];
	
	// Update the view.
	[self _configureView];
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[_contentsTextField resignFirstResponder];
	[self _updateWithOptions];
	
	return NO;
}

#pragma mark - Options methods

- (void)enableAllControls:(BOOL)enabled
{
    _captionSwitch.enabled = enabled;
	_debugSwitch.enabled = enabled;
	_fillQuietZonesSwitch.enabled = enabled;
	_barScaleSlider.enabled = enabled;
	_captionOverlapSlider.enabled = enabled;
    _checkDigitsInCaptionSwitch.enabled = enabled;
}

// Create a new barcode when the options or the contents change
- (void)_updateWithOptions
{
	NSDictionary *options = @{BCKCodeDrawingBarScaleOption: @(_barScale),
									  BCKCodeDrawingFillEmptyQuietZonesOption: @(_fillOption),
									  BCKCodeDrawingDebugOption: @(_debugOption),
									  BCKCodeDrawingPrintCaptionOption: @(_captionOption),
									  BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption: @(_captionOverlap),
									  BCKCodeDrawingShowCheckDigitsOption: @(_checkDigitsInCaptionOption),
									  BCKCodeDrawingBackgroundColorOption: [UIColor whiteColor]};
	
	// Initialise barcode contents using the text in the textfield
	NSError *error;
	_barcodeObject = [[_barcodeClass alloc] initWithContent:_contentsTextField.text error:&error];
	
	// Draw the barcode. If the barcode doesn't support the content clear the image and show the error message, disable all controls except the text field
	if (_barcodeObject)
	{
        [self enableAllControls:YES];
        self.errorMessage.hidden = YES;
		self.barcodeImageView.image = [UIImage imageWithBarCode:_barcodeObject options:options];
        self.errorMessage.text = @"";
	}
	else
	{
        [self enableAllControls:NO];
        self.errorMessage.hidden = NO;
		self.barcodeImageView.image = nil;
        self.errorMessage.text = [NSString stringWithFormat:@"Encoding error: %@\n\nPlease try a different contents.", [error localizedDescription]];
	}
}

- (void)_debugOptionChange:(UISwitch *)sender
{
	_debugOption = sender.isOn;
	[self _updateWithOptions];
}

- (void)_fillOptionChange:(UISwitch *)sender
{
	_fillOption = sender.isOn;
	[self _updateWithOptions];
}

- (void)_captionOptionChange:(UISwitch *)sender
{
	_captionOption = sender.isOn;
	[self _updateWithOptions];
}

- (void)_barScaleChange:(UISlider *)sender
{
	CGFloat previousScale = _barScale;
	CGFloat newScale = roundf(sender.value*2.0f) / 2.0f;
	
	if (newScale != previousScale)
	{
		_barScale = newScale;
		[self _updateWithOptions];
	}
}

- (void)_overlapChange:(UISlider *)sender
{
	_captionOverlap = sender.value;
	[self _updateWithOptions];
}

- (void)_checkDigitsInCaptionChange:(UISwitch *)sender
{
	_checkDigitsInCaptionOption = sender.isOn;
	[self _updateWithOptions];
}

#pragma mark - UI methods

- (void)_configureView
{
	self.title = NSStringFromClass(_barcodeClass);
	
	// Set default options
	_captionOption = YES;
	_debugOption = NO;
	_fillOption = YES;
    _checkDigitsInCaptionOption = NO;
	_barScale = 1.0;
	_captionOverlap = 1.0;

	// Setup the various controls
	_captionSwitch = [[UISwitch alloc] init];
	[_captionSwitch addTarget:self action:@selector(_captionOptionChange:) forControlEvents:UIControlEventValueChanged];
	_captionSwitch.on = _captionOption;
	
	_debugSwitch = [[UISwitch alloc] init];
	[_debugSwitch addTarget:self action:@selector(_debugOptionChange:) forControlEvents:UIControlEventValueChanged];
	_debugSwitch.on = _debugOption;
	
	_fillQuietZonesSwitch = [[UISwitch alloc] init];
	[_fillQuietZonesSwitch addTarget:self action:@selector(_fillOptionChange:) forControlEvents:UIControlEventValueChanged];
	_fillQuietZonesSwitch.on = _fillOption;
	
	_barScaleSlider = [[UISlider alloc] init];
	_barScaleSlider.minimumValue = 1;
	_barScaleSlider.maximumValue = 2;
	_barScaleSlider.continuous = YES;
	[_barScaleSlider addTarget:self action:@selector(_barScaleChange:) forControlEvents:UIControlEventValueChanged];
	_barScaleSlider.value = _barScale;
	
	_captionOverlapSlider = [[UISlider alloc] init];
	_captionOverlapSlider.minimumValue = 0.0;
	_captionOverlapSlider.maximumValue = 1.0;
	_captionOverlapSlider.continuous = YES;
	[_captionOverlapSlider addTarget:self action:@selector(_overlapChange:) forControlEvents:UIControlEventValueChanged];
	_captionOverlapSlider.value = _captionOverlap;
	
	_contentsTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 10.0f, 205.0f, 30.0f)];
	_contentsTextField.clearsOnBeginEditing = NO;
	_contentsTextField.textAlignment = NSTextAlignmentRight;
	_contentsTextField.keyboardType = UIKeyboardTypeASCIICapable;
	_contentsTextField.returnKeyType = UIReturnKeyDone;
	_contentsTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_contentsTextField.delegate = self;
	_contentsTextField.placeholder = @"Enter barcode";
	
    _checkDigitsInCaptionSwitch = [[UISwitch alloc] init];
	[_checkDigitsInCaptionSwitch addTarget:self action:@selector(_checkDigitsInCaptionChange:) forControlEvents:UIControlEventValueChanged];
	_checkDigitsInCaptionSwitch.on = _checkDigitsInCaptionOption;

	// Initialise the barcode contents with the sample barcode content passed to the view controller
	_contentsTextField.text = _sampleContent;
    
    // Initially hide the error message UILabel
    self.errorMessage.hidden = YES;
	
	// Draw the barcode using the current options
	[self _updateWithOptions];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Configure all controls
	[self _configureView];

	// Determine which options to show by adding options to the array used as the tableview's model
	NSMutableArray *tmpBarcodeOptions = [NSMutableArray arrayWithObjects:@[@"Contents", _contentsTextField],
                                         @[@"Bar scale", _barScaleSlider],
                                         nil];

    if ([_barcodeObject respondsToSelector:@selector(captionTextForZone:withRenderOptions:)])
    {
        [tmpBarcodeOptions addObject:@[@"Debug", _debugSwitch]];
        [tmpBarcodeOptions addObject:@[@"Caption", _captionSwitch]];
    }
    
	if ([_barcodeObject allowsFillingOfEmptyQuietZones])
	{
		[tmpBarcodeOptions addObject:@[@"Fill Quiet Zones", _fillQuietZonesSwitch]];
	}
	
	if ([_barcodeObject markerBarsCanOverlapBottomCaption])
	{
		[tmpBarcodeOptions addObject:@[@"Caption overlap", _captionOverlapSlider]];
	}
	
    if ([_barcodeObject showCheckDigitsInCaption])
	{
		[tmpBarcodeOptions addObject:@[@"Show check digits", _checkDigitsInCaptionSwitch]];
	}
    
	_barcodeOptions = [NSArray arrayWithArray:tmpBarcodeOptions];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_barcodeOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"BarcodeDetailCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	cell.textLabel.text = [_barcodeOptions[indexPath.row] objectAtIndex:0];
    cell.accessoryView = [_barcodeOptions[indexPath.row] objectAtIndex:1];

	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Barcode Options";
}

@end
