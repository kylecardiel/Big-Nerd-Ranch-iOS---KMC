//
//  BNRDetailViewController.m
//  HomepwnerKMC
//
//  Created by Kyle on 9/1/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "BNRAssetTypeViewController.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@end

@implementation BNRDetailViewController

- (instancetype)initForNewItem:(BOOL)isNew
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    if (isNew) {
      UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
      self.navigationItem.rightBarButtonItem = doneItem;
      
      UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
      self.navigationItem.leftBarButtonItem = cancelItem;
      
      NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
      [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
  }
  return self;
}


- (void)dealloc
{
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter removeObserver:self];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  [NSException raise:@"Wrong initializer" format:@"Use initForNewItem:"];
  return nil;
}


- (void)save:(id)sender
{
  //[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}


- (void)cancel:(id)sender
{
  [[BNRItemStore sharedStore] removeItem:self.item];
  //[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
  [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}



//Added for silver challenge to remove picture from
//detailview and from image store
- (IBAction)deleteImage:(id)sender
{
  [[BNRImageStore sharedStore] deletImageForKey:self.item.itemKey];
  self.imageView.image = nil;
}



- (IBAction)backgroundTapped:(id)sender
{
  [self.view endEditing:YES];
  
  /*
  for (UIView *subview in self.view.subviews) {
    if ([subview hasAmbiguousLayout]) {
      [subview exerciseAmbiguityInLayout];
    }
  }
   */
}


- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    return;
  }
  
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    self.imageView.hidden = YES;
    self.cameraButton.enabled = NO;
  } else {
    self.imageView.hidden = NO;
    self.cameraButton.enabled = YES;
  }
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [self prepareViewsForOrientation:toInterfaceOrientation];
}





- (IBAction)takePicture:(id)sender
{
  if ([self.imagePickerPopover isPopoverVisible]) {
    [self.imagePickerPopover dismissPopoverAnimated:YES];
    self.imagePickerPopover = nil;
    return;
  }
  
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  //Bronze Challenge for edited photo
  imagePicker.allowsEditing = YES;
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  } else {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  imagePicker.delegate = self;
  
  //[self presentViewController:imagePicker animated:YES completion:NULL];
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    self.imagePickerPopover.delegate = self;
    
    [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
  } else {
    [self presentViewController:imagePicker animated:YES completion:NULL];
  }
  
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
  NSLog(@"User dismissed popover");
  self.imagePickerPopover = nil;
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  //UIImage *image = info[UIImagePickerControllerOriginalImage];
  //Bronze Challenge for edited photo
  UIImage *image = info[UIImagePickerControllerEditedImage];
  [self.item setThumbnailFromImage:image];
  [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
  self.imageView.image = image;
  //[self dismissViewControllerAnimated:YES completion:NULL];
  if (self.imagePickerPopover) {
    [self.imagePickerPopover dismissPopoverAnimated:YES];
    self.imagePickerPopover = nil;
  } else {
    [self dismissViewControllerAnimated:YES completion:NULL];
  }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
  //commetted out next line, b/c picture was to large(?)
  //iv.contentMode = UIViewContentModeScaleAspectFill;
  iv.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:iv];
  self.imageView = iv;
  
  [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
  [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
  
  NSDictionary *nameMap = @{@"imageView" : self.imageView,
                            @"dateLabel" : self.dateLabel,
                            @"toolbar" : self.toolBar};
  

  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-8-[imageView]-8-[toolbar]" options:0 metrics:nil views:nameMap];
  
  [self.view addConstraints:horizontalConstraints];
  [self.view addConstraints:verticalConstraints];
  

}


/*
- (void)viewDidLayoutSubviews
{
  for (UIView *subview in self.view.subviews) {
    if ([subview hasAmbiguousLayout]) {
      NSLog(@"AMBIGUOUS: %@", subview);
    }
  }
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
  [self prepareViewsForOrientation:io];
  
  BNRItem *item = self.item;
  
  self.nameField.text = item.itemName;
  self.serialField.text = item.serialNumber;
  self.valueField.text= [NSString stringWithFormat:@"%d", item.valueInDollars];
  
  static NSDateFormatter *dateFormatter;
  if(!dateFormatter){
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
  }
  self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
  
  NSString *itemKey = self.item.itemKey;
  UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
  self.imageView.image = imageToDisplay;
  
  NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
  if(!typeLabel){
    typeLabel = @"None";
  }
  
  self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
  
  [self updateFonts];
}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.view endEditing:YES];
  
  BNRItem *item = self.item;
  item.itemName = self.nameField.text;
  item.serialNumber = self.serialField.text;
  item.valueInDollars = [self.valueField.text intValue];
}


- (void)setItem:(BNRItem *)item
{
  _item = item;
  self.navigationItem.title = _item.itemName;
}



- (void)updateFonts
{
  UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  
  self.nameLabel.font = font;
  self.serialNumberLabel.font = font;
  self.valueLabel.font = font;
  self.dateLabel.font = font;
  
  self.nameField.font = font;
  self.serialNumberLabel.font = font;
  self.valueField.font = font;
  
}


- (IBAction)showAssetTypPicker:(id)sender {
  
  [self.view endEditing:YES];
  BNRAssetTypeViewController *avc = [[BNRAssetTypeViewController alloc] init];
  avc.item = self.item;
  [self.navigationController pushViewController:avc animated:YES];
  
}






@end
