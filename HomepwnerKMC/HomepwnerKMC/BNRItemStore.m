//
//  BNRItemStore.m
//  HomepwnerKMC
//
//  Created by Kyle on 8/30/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@import CoreData;

@interface BNRItemStore()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetsTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end


@implementation BNRItemStore


+ (instancetype)sharedStore
{
  static BNRItemStore *sharedStore;
  
  //if(!sharedStore) {
    //sharedStore = [[self alloc] initPrivate];
  //}
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedStore = [[self alloc] initPrivate];
  });
  
  return sharedStore;
  
}


- (instancetype)initPrivate
{
  self = [super init];
  if(self){
    //_privateItems = [[NSMutableArray alloc] init];
    //NSString *path = [self itemArchivePath];
    //_privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    //if (!_privateItems) {
      //_privateItems = [[NSMutableArray alloc] init];
    //}
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    NSString *path = self.itemArchivePath;
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    NSError *error;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
      [NSException raise:@"Open Failure" format:[error localizedDescription]];
    }
    
    _context = [[NSManagedObjectContext alloc] init];
    _context.persistentStoreCoordinator = psc;
    
    [self loadAllItems];
  }
  return self;
}


- (instancetype)init
{
  [NSException raise:@"Singleton"
              format:@"Use +[BNRItemStore sharedStore]"];
  
  return nil;
}


- (NSArray *)allItems
{
  return [self.privateItems copy];
}


- (BNRItem *)createItem
{
  //BNRItem *item = [[BNRItem alloc] init];
  double order;
  if ([self.allItems count] == 0) {
    order = 1.0;
  } else {
    order = [[self.privateItems lastObject] orderingValue] + 1.0;
  }
  NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
  BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:self.context];
  item.orderingValue = order;
  
  [self.privateItems addObject:item];
  
  return item;
}



- (void)removeItem:(BNRItem *)item
{
  NSString *key = item.itemKey;
  [[BNRImageStore sharedStore] deletImageForKey:key];
  [self.context deleteObject:item];
  [self.privateItems removeObjectIdenticalTo:item];
}



- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
  if (fromIndex == toIndex) {
    return;
  }
  
  BNRItem *item = self.privateItems[fromIndex];
  [self.privateItems removeObjectAtIndex:fromIndex];
  [self.privateItems insertObject:item atIndex:toIndex];
  
  double lowerBound = 0.0;
  if (toIndex > 0) {
    lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
  } else {
    lowerBound = [self.privateItems[1] orderingValue] - 2.0;
  }
  
  double upperBound = 0.0;
  if (toIndex < [self.privateItems count] - 1) {
    upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
  } else {
    upperBound = [self.privateItems[(toIndex - 1)] orderingValue];
  }
  
  double newOrderValue = (lowerBound + upperBound) / 2.0;
  NSLog(@"moving to order %f", newOrderValue);
  item.orderingValue = newOrderValue;

}



- (NSString *)itemArchivePath
{
  NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [documentDirectories firstObject];
  
  //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
  return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}


- (BOOL)saveChanges
{
  //NSString *path = [self itemArchivePath];
  //return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
  
  NSError *error;
  BOOL successful = [self.context save:&error];
  if (!successful) {
    NSLog(@"Error saving: %@", [error localizedDescription]);
  }
  return successful;
}



- (void)loadAllItems
{
  if (!self.privateItems) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
    request.entity = e;
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
    request.sortDescriptors = @[sd];
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
      [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    self.privateItems = [[NSMutableArray alloc] initWithArray:result];
  }
}



- (NSArray *)allAssetTypes
{
  if (!_allAssetsTypes) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:self.context];
    request.entity = e;
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
      [NSException raise:@"Fecth failed" format:@"Reason: %@", [error localizedDescription]];
    }
    _allAssetsTypes = [result mutableCopy];
  }
  if ([_allAssetsTypes count] == 0) {
    NSManagedObject *type;
    type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
    [type setValue:@"Action Figure" forKey:@"label"];
    [_allAssetsTypes addObject:type];
    
    type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
    [type setValue:@"Vehicle" forKey:@"label"];
    [_allAssetsTypes addObject:type];
    
    type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:self.context];
    [type setValue:@"Other" forKey:@"label"];
    [_allAssetsTypes addObject:type];
  }
  return _allAssetsTypes;
}










@end













