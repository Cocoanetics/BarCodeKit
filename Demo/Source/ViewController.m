//
//  ViewController.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "ViewController.h"
#import "BarCodeKit.h"
#import "UIImage+BarCodeKit.h"
#import "BCKCode128Code.h"

@interface ViewController ()

@end

@implementation ViewController
{
	CGFloat _barScale;
	CGFloat _captionOverlap;
	BOOL _debugOption;
	BOOL _fillOption;
	BOOL _captionOption;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_barScale = 1.0;
	_captionOverlap = 1.0;
	_captionOption = YES;
	
	[self _updateWithOptions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_updateWithOptions
{
	NSDictionary *options = @{BCKCodeDrawingBarScaleOption: @(_barScale), BCKCodeDrawingFillEmptyQuietZonesOption: @(_fillOption),
									  BCKCodeDrawingDebugOption: @(_debugOption),
									  BCKCodeDrawingPrintCaptionOption: @(_captionOption),
									  BCKCodeDrawingMarkerBarsOverlapCaptionPercentOption: @(_captionOverlap)};
	
	BCKEAN13Code *code1 = [[BCKEAN13Code alloc] initWithContent:@"9780596516178"];
//	BCKCode39Code *code1 = [[BCKCode39Code alloc] initWithContent:@"OLIVER"];
//	BCKInterleaved2of5Code *code1 = [[BCKInterleaved2of5Code alloc] initWithContent:@"1234567890111112312"];
//	BCKCode128Code *code1 = [[BCKCode128Code alloc] initWithContent:@"Wikipedia"];
	self.imageView.image = [UIImage imageWithBarCode:code1 options:options];
	
	BCKEAN8Code *code2 = [[BCKEAN8Code alloc] initWithContent:@"24046985"];
	self.imageView_EAN8.image = [UIImage imageWithBarCode:code2 options:options];
	
	BCKUPCECode *code3 = [[BCKUPCECode alloc] initWithContent:@"12345670"];
	self.imageView_UPCE.image = [UIImage imageWithBarCode:code3 options:options];
}

- (IBAction)debugOptionChange:(UISwitch *)sender
{
	_debugOption = sender.isOn;
	
	[self _updateWithOptions];
}



- (IBAction)fillOptionChange:(UISwitch *)sender
{
	_fillOption = sender.isOn;
	
	[self _updateWithOptions];
}

- (IBAction)captionOptionChange:(UISwitch *)sender
{
	_captionOption = sender.isOn;
	
	[self _updateWithOptions];
}

- (IBAction)barScaleChange:(UISlider *)sender
{
	CGFloat previousScale = _barScale;
	CGFloat newScale = roundf(sender.value*2.0f) / 2.0f;
	
	if (newScale != previousScale)
	{
		_barScale = newScale;
		[self _updateWithOptions];
	}
}

- (IBAction)overlapChange:(UISlider *)sender
{
	_captionOverlap = sender.value;
	
	[self _updateWithOptions];
}
@end
