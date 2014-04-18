//
//  EDTVisitorAddAttributeViewController.m
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 23/01/13.
//  Copyright (c) 2013 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import "EDTVisitorAddAttributeViewController.h"
#import "EightDigits.h"

@interface EDTVisitorAddAttributeViewController ()

@property (strong, nonatomic)   UIBarButtonItem *doneItem;

@property (strong, nonatomic)   UITextField     *keyField;
@property (strong, nonatomic)   UITextField     *valueField;

- (void)sendAttribute;
- (void)textFieldValueChanged:(UITextField *)textField;

- (void)popFromNavigationStack;

@end

@implementation EDTVisitorAddAttributeViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        self.doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendAttribute)];
        [self.doneItem setEnabled:NO];
        [self.navigationItem setRightBarButtonItem:self.doneItem];
        
        self.title = @"Add Attribute";
        
        self.keyField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        self.valueField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        
        for (UITextField *textField in @[self.keyField, self.valueField]) {
            [textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }
        
        [self.keyField setPlaceholder:@"Attribute key"];
        [self.valueField setPlaceholder:@"Attribute value"];
    
    }
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.keyField becomeFirstResponder];
}

- (void)sendAttribute {
    
    self.title = @"Sending...";
    self.doneItem.enabled = NO;
    
    /**
        Send the text from key field as attribute key and text from value field as attribute value
     */
    [[EDVisitor currentVisitor] setVisitorAttributesFromDictionary:@{self.keyField.text : self.valueField.text} withCompletionHandler:^(NSString *error) {
        
        /**
            Handle error
         */
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to send attribute" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            self.title = @"Add Attribute";
            self.doneItem.enabled = YES;
        }
        
        /**
            No error, communication successful
         */
        else {
            self.title = @"Sent";
            [self performSelector:@selector(popFromNavigationStack) withObject:nil afterDelay:1];
        }
        
        
    }];
}

- (void)popFromNavigationStack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UITextField *textField = indexPath.row == 0 ? self.keyField : self.valueField;
    [textField setFrame:CGRectInset(cell.contentView.bounds, 10, 10)];
    [cell.contentView addSubview:textField];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITextField *textField = indexPath.row == 0 ? self.keyField : self.valueField;
    [textField becomeFirstResponder];
}

- (void)textFieldValueChanged:(UITextField *)textField {
    [self.doneItem setEnabled:(self.keyField.text.length && self.valueField.text.length)];
}

@end
