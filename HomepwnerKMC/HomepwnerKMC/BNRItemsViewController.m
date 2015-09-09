//
//  BNRItemsViewController.m
//  HomepwnerKMC
//
//  Created by Kyle on 8/30/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRDetailViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"


@interface BNRItemsViewController () <UIPopoverControllerDelegate>

//@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (strong, nonatomic) UIPopoverController *imagePopover;

@end

@implementation BNRItemsViewController



- (instancetype)init
{
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    //for (int i = 0; i < 5; i++) {
      //[[BNRItemStore sharedStore] createItem];
    //}
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Homepwner";
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddNewItem:)];
    navItem.rightBarButtonItem = bbi;
    navItem.leftBarButtonItem = self.editButtonItem;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
  }
  return self;
}



- (void)dealloc
{
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}



- (instancetype)initWithStyle:(UITableViewStyle)style
{
  return [self init];
}



- (void)viewDidLoad {
  [super viewDidLoad];
  //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
  
  //UIView *header = self.headerView;
  //[self.tableView setTableHeaderView:header];
  
  UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
  
}



- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  //[self.tableView reloadData];
  [self updateTableViewForDynamicTypeSize];
}



- (void)updateTableViewForDynamicTypeSize
{
  static NSDictionary *cellHeightDictionary;
  if (!cellHeightDictionary) {
    cellHeightDictionary = @{UIContentSizeCategoryExtraSmall : @44,
                             UIContentSizeCategorySmall : @44,
                             UIContentSizeCategoryMedium : @44,
                             UIContentSizeCategoryLarge : @44,
                             UIContentSizeCategoryExtraLarge : @55,
                             UIContentSizeCategoryExtraExtraLarge : @65,
                             UIContentSizeCategoryExtraExtraExtraLarge : @75 };
  }
  NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
  NSNumber *cellHeight = cellHeightDictionary[userSize];
  [self.tableView setRowHeight:cellHeight.floatValue];
  [self.tableView reloadData];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //BNRDetailViewController *detialViewController = [[BNRDetailViewController alloc] init];
  BNRDetailViewController *detialViewController = [[BNRDetailViewController alloc] initForNewItem:NO];

  
  
  NSArray *items = [[BNRItemStore sharedStore] allItems];
  BNRItem *selectedItem = items[indexPath.row];
  detialViewController.item = selectedItem;
  
  [self.navigationController pushViewController:detialViewController animated:YES];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[[BNRItemStore sharedStore] allItems] count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
  //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  
  BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
  
  NSArray *items = [[BNRItemStore sharedStore] allItems];
  BNRItem *item = items[indexPath.row];
  
  //cell.textLabel.text = [item description];
  cell.nameLabel.text = item.itemName;
  cell.serialNumberLabel.text = item.serialNumber;
  cell.valueLabel.text = [NSString stringWithFormat:@"$%d",item.valueInDollars];
  
  /*
  if (item.valueInDollars > 50.00) {
    cell.valueLabel.textColor = [UIColor greenColor];
  } else {
    cell.valueLabel.textColor = [UIColor redColor];
  }
   */
  
  cell.thumbnailView.image = item.thumbnail;
  
  
  __weak BNRItemCell *weakCell = cell;
  
  cell.actionBlock = ^{

    NSLog(@"Going to show image for %@", item);
    BNRItemCell *strongCell = weakCell;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
      NSString *itemKey = item.itemKey;
      UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
      if (!img) {
        return;
      }
      //CGRect rect = [self.view convertRect:cell.thumbnailView.bounds fromView:cell.thumbnailView];
      CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
      BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
      ivc.image = img;
      self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
      self.imagePopover.delegate = self;
      self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
      [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
  };
  return cell;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
  self.imagePopover = nil;
}




- (IBAction)AddNewItem:(id)sender
{
  
  //NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
  BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
  //NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
  //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
  //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
  
  BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
  
  detailViewController.item = newItem;
  detailViewController.dismissBlock = ^{
    [self.tableView reloadData];
  };
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
  navController.modalPresentationStyle = UIModalPresentationFormSheet; 
  [self presentViewController:navController animated:YES completion:NULL];
  
}





- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    [[BNRItemStore sharedStore] removeItem:item];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}





- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}







/*- (IBAction)toggleEditingMode:(id)sender
 {
 if(self.isEditing) {
 [sender setTitle:@"Edit" forState:UIControlStateNormal];
 [self setEditing:NO animated:YES];
 } else {
 [sender setTitle:@"Done" forState:UIControlStateNormal];
 [self setEditing:YES animated:YES];
 }
 }
 
 
 
 
 - (UIView *)headerView
 {
 if(!_headerView) {
 [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
 }
 return _headerView;
 }*/





@end
