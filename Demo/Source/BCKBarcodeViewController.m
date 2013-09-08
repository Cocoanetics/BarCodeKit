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
@property (nonatomic, strong) BCKCode *barcodeObject;
@property (nonatomic, strong) NSString *barcodeSample;
@property (nonatomic, strong) NSString *barcodeClassString;
@property (nonatomic, strong) NSArray *barcodeOptions;

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

#define CONTENT_TEXTFIELD           0
#define DEBUG_SWITCH                1
#define BAR_SCALE_SLIDER            2
#define CAPTION_SWITCH              3
#define FILL_QUIET_ZONES_SWITCH     4
#define CAPTION_OVERLAP_SLIDER      5

#pragma mark - Initialisation

// Use this method to pass all model information (the name of the BCKCode subclass and the sample barcode) to the viewcontroller
-(void)initWithBarcodeClassString:(NSString *)barcodeClassString andBarcodeSample:(NSString *)barcodeSample
{
    if (_barcodeClassString != barcodeClassString) {
        _barcodeClassString = barcodeClassString;
        
        _barcodeSample = barcodeSample;
        
        // Update the view.
        [self _configureView];
    }
}

// Returns YES if className implements methodName, this is used to check whether one of BCKCode's subclasses implements property getters 
-(BOOL)_implementsMethod:(NSString *)className forMethod:(SEL)methodName
{
    int unsigned numMethods;
    Method *methods = class_copyMethodList(NSClassFromString(className), &numMethods);

    for (int i = 0; i < numMethods; i++) {
        if (methodName == method_getName(methods[i]))
            return YES;
    }
    
    return NO;
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

    // Initialise barcode contents using the text in the textfield
    self.barcodeObject = [[NSClassFromString(self.barcodeClassString) alloc] initWithContent:_contentTextField.text];

    // Draw the barcode. If the barcode doesn't support the content show nothing
    if(self.barcodeObject) {
        self.barcodeImageView.image = [UIImage imageWithBarCode:self.barcodeObject options:options];
    }
    else {
        self.barcodeImageView.image = nil;
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

#pragma mark - UI methods

- (void)_configureView
{
    self.title = self.barcodeClassString;
    
    // Set default options
    _captionOption = YES;
    _debugOption = NO;
    _fillOption = YES;
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
    
    _contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 10.0f, 205.0f, 30.0f)];
    _contentTextField.clearsOnBeginEditing = NO;
    _contentTextField.textAlignment = NSTextAlignmentRight;
    _contentTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _contentTextField.returnKeyType = UIReturnKeyDone;
    _contentTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _contentTextField.delegate = self;
    _contentTextField.placeholder = @"Enter barcode";

    // Initialise the barcode contents with the sample barcode content
    _contentTextField.text = self.barcodeSample;
    
    // Draw the barcode using the current options
    [self _updateWithOptions];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Determine which options to show by adding options to the array used as the tableview model
    NSMutableArray *tmpBarcodeOptions = [NSMutableArray arrayWithObjects:@"Content", @"Debug", @"Bar scale", @"Caption", nil];

    if ([self _implementsMethod:self.barcodeClassString forMethod:@selector(allowsFillingOfEmptyQuietZones)])
        [tmpBarcodeOptions addObject:@"Fill Quiet Zones"];

    if ([self _implementsMethod:self.barcodeClassString forMethod:@selector(markerBarsCanOverlapBottomCaption)]) {
        [tmpBarcodeOptions addObject:@"Caption overlap"];
    }

    self.barcodeOptions = [NSArray arrayWithArray:tmpBarcodeOptions];
    
    // Configure all controls
    [self _configureView];
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
    return [self.barcodeOptions count];
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

    // Set the cell text and add the correct control (switch, slider etc.)
    cell.textLabel.text = [self.barcodeOptions objectAtIndex:indexPath.row];
    
    switch(indexPath.row)
    {
        case CONTENT_TEXTFIELD:
        {
            cell.accessoryView = _contentTextField;
            break;
        }
        case DEBUG_SWITCH:
        {
            cell.accessoryView = _debugSwitch;
            break;
        }
        case BAR_SCALE_SLIDER:
        {
            cell.accessoryView = _barScaleSlider;
            break;
        }
        case FILL_QUIET_ZONES_SWITCH:
        {
            cell.accessoryView = _fillQuietZonesSwitch;
            break;
        }
        case CAPTION_SWITCH:
        {
            cell.accessoryView = _captionSwitch;
            break;
        }
        case CAPTION_OVERLAP_SLIDER:
        {
            cell.accessoryView = _captionOverlapSlider;
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
