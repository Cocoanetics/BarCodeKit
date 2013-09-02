//
//  BCKBarcodeViewController.m
//  BarCodeKitDemo
//
//  Created by Geoff Breemer on 31/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarcodeViewController.h"
#import "UIImage+BarCodeKit.h"

#define SAMPLE_CONTENTS @"12345670"                // Sample barcode that works for most, but not all barcode types
#define SAMPLE_CONTENTS_ALT @"9780596516178"       // Alternative sample barcode

@interface BCKBarcodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (nonatomic, strong) BCKCode *barcodeObject;

- (void)configureView;

@end

@implementation BCKBarcodeViewController
{
    // Options controls
    UISwitch *_captionSwitch;
    UISwitch *_debugSwitch;
    UISwitch *_fillQuietZonesSwitch;
    UISlider *_barScaleSlider;
    UISlider *_captionOverlapSlider;
    UITextField *_contentTextField;
 
    // Options variables
	BOOL _captionOption;
	BOOL _debugOption;
	BOOL _fillOption;
    CGFloat _barScale;
	CGFloat _captionOverlap;
}

#pragma mark - Other

- (void)setBarcodeClass:(Class)newBarcodeClass
{
    if (_barcodeClass != newBarcodeClass) {
        _barcodeClass = newBarcodeClass;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_contentTextField resignFirstResponder];
    [self _updateWithOptions];
    
    return NO;
}

#pragma mark - Options methods

// Create a new barcode when the options or the contents change
- (void)_updateWithOptions
{
    NSDictionary *options = @{BCKCodeDrawingBarScaleOption: @(_barScale),
                              BCKCodeDrawingFillEmptyQuietZonesOption: @(_fillOption),
                              BCKCodeDrawingDebugOption: @(_debugOption),
                              BCKCodeDrawingPrintCaptionOption: @(_captionOption),
                              BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption: @(_captionOverlap)};

    // Initialise barcode contents using the sample barcode
    self.barcodeObject = [[self.barcodeClass alloc] initWithContent:_contentTextField.text];

    // Draw the barcode. If the sample didn't work, try the alternative one. If that doesn't work show a placeholder image.
    if(self.barcodeObject)
        self.barcodeImage.image = [UIImage imageWithBarCode:self.barcodeObject options:options];
    else {
        // Try the alternative sample first
        self.barcodeObject = [[self.barcodeClass alloc] initWithContent:SAMPLE_CONTENTS_ALT];

        if(self.barcodeObject)
        {
            _contentTextField.text = SAMPLE_CONTENTS_ALT;
            self.barcodeImage.image = [UIImage imageWithBarCode:self.barcodeObject options:options];
        }
        else{
            _contentTextField.text = @"";
            self.barcodeImage.image = [UIImage imageNamed:@"enter_barcode"];
        }
    }
}

- (void)debugOptionChange:(UISwitch *)sender
{
	_debugOption = sender.isOn;
	[self _updateWithOptions];
}

- (void)fillOptionChange:(UISwitch *)sender
{
	_fillOption = sender.isOn;
	[self _updateWithOptions];
}

- (void)captionOptionChange:(UISwitch *)sender
{
	_captionOption = sender.isOn;
	[self _updateWithOptions];
}

- (void)barScaleChange:(UISlider *)sender
{
	CGFloat previousScale = _barScale;
	CGFloat newScale = roundf(sender.value*2.0f) / 2.0f;
	
	if (newScale != previousScale)
	{
		_barScale = newScale;
		[self _updateWithOptions];
	}
}

- (void)overlapChange:(UISlider *)sender
{
	_captionOverlap = sender.value;
    [self _updateWithOptions];
}

#pragma mark - UI methods

- (void)configureView
{
    self.title = NSStringFromClass([self.barcodeClass class]);
    
    // Set default options
    _captionOption = YES;
    _debugOption = NO;
    _fillOption = YES;
    _barScale = 1.0;
    _captionOverlap = 1.0;
    
    // Setup the various controls
    _captionSwitch = [[UISwitch alloc] init];
    [_captionSwitch addTarget:self action:@selector(captionOptionChange:) forControlEvents:UIControlEventValueChanged];
    _captionSwitch.on = _captionOption;
    
    _debugSwitch = [[UISwitch alloc] init];
    [_debugSwitch addTarget:self action:@selector(debugOptionChange:) forControlEvents:UIControlEventValueChanged];
    _debugSwitch.on = _debugOption;
    
    _fillQuietZonesSwitch = [[UISwitch alloc] init];
    [_fillQuietZonesSwitch addTarget:self action:@selector(fillOptionChange:) forControlEvents:UIControlEventValueChanged];
    _fillQuietZonesSwitch.on = _fillOption;
    
    _barScaleSlider = [[UISlider alloc] init];
    _barScaleSlider.minimumValue = 1;
    _barScaleSlider.maximumValue = 2;
    _barScaleSlider.continuous = YES;
    [_barScaleSlider addTarget:self action:@selector(barScaleChange:) forControlEvents:UIControlEventValueChanged];
    _barScaleSlider.value = _barScale;
    
    _captionOverlapSlider = [[UISlider alloc] init];
    _captionOverlapSlider.minimumValue = 0.0;
    _captionOverlapSlider.maximumValue = 1.0;
    _captionOverlapSlider.continuous = YES;
    [_captionOverlapSlider addTarget:self action:@selector(overlapChange:) forControlEvents:UIControlEventValueChanged];
    _captionOverlapSlider.value = _captionOverlap;
    
    _contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 10.0f, 205.0f, 30.0f)];
    _contentTextField.clearsOnBeginEditing = NO;
    _contentTextField.textAlignment = NSTextAlignmentRight;
    _contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _contentTextField.returnKeyType = UIReturnKeyDone;
    _contentTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _contentTextField.delegate = self;
    _contentTextField.text = SAMPLE_CONTENTS;
    
    // Draw the barcode using the current options
    [self _updateWithOptions];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
    
    switch(indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"Content";
            [cell.contentView addSubview:_contentTextField];
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Caption";
            cell.accessoryView = _captionSwitch;
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"Debug";
            cell.accessoryView = _debugSwitch;
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"Fill Quiet Zones";
            cell.accessoryView = _fillQuietZonesSwitch;
            break;
        }
        case 4:
        {
            cell.textLabel.text = @"Bar scale";
            cell.accessoryView = _barScaleSlider;
            break;
        }
        case 5:
        {
            cell.textLabel.text = @"Caption overlap";
            cell.accessoryView = _captionOverlapSlider;
            break;
        }
        default:
        {
            break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Barcode Options";
}

@end
