//
//  BCKBarcodeListViewController.m
//  BarCodeKitDemo
//
//  Created by Geoff Breemer on 31/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKBarcodeListViewController.h"
#import "BCKBarcodeViewController.h"
#import <objc/objc-runtime.h>

@interface BCKBarcodeListViewController ()

@property (nonatomic) NSArray *barcodeTypes;            // Holds an array of Class structs for all BCKCode subclasses

@end

@implementation BCKBarcodeListViewController

#pragma mark - Other

// Returns an array of Class structs of theClass' subclasses (direct subclasses only)
- (NSArray *) allSubclassesForClass:(Class)theClass
{
    NSMutableArray *mySubclasses = [NSMutableArray array];
    unsigned int numOfClasses;
    
    Class *classes = objc_copyClassList(&numOfClasses);
    
    for (unsigned int ci = 0; ci < numOfClasses; ci++) {
        Class superClass = classes[ci];
        do {
            superClass = class_getSuperclass(superClass);
        } while (superClass && superClass != theClass);
        
        if (superClass == theClass) {                   // change to (superClass) to find all descendants, not just the direct ones
            [mySubclasses addObject: classes[ci]];
        }
    }
    free(classes);
    
    return mySubclasses;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.barcodeTypes = [self allSubclassesForClass:[BCKCode class]];
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
    return self.barcodeTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Just display the Class name
    cell.textLabel.text = NSStringFromClass(self.barcodeTypes[indexPath.row]);
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass the Class struct of the selected barcode type
    if ([[segue identifier] isEqualToString:@"showBarcode"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setBarcodeClass:self.barcodeTypes[indexPath.row]];
    }
}

@end
