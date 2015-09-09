//
//  BNRImageStore.m
//  HomepwnerKMC
//
//  Created by Kyle on 9/1/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end


@implementation BNRImageStore

+ (instancetype)sharedStore
{
  static BNRImageStore *sharedStore;
  //if (!sharedStore) {
    //sharedStore = [[self alloc] initPrivate];
  //}
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedStore = [[self alloc] initPrivate];
  });
  return sharedStore;
}


- (instancetype)init
{
  [NSException raise:@"Singleton" format:@"Use +[BNRImageStore sharedStore]"];
  return nil;
}


- (instancetype)initPrivate
{
  self = [super init];
  if(self){
    _dictionary = [[NSMutableDictionary alloc] init];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
  }
  return self;
}



- (void)clearCache:(NSNotification *)note
{
  NSLog(@"flushing %d images out of the cache", [self.dictionary count]);
  [self.dictionary removeAllObjects];
}



- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
  //[self.dictionary setObject:image forKey:key];
  self.dictionary[key] = image;
  
  NSString *imagePath = [self imagePathForKey:key];
  NSData *data = UIImageJPEGRepresentation(image, 0.5);
  [data writeToFile:imagePath atomically:YES];
}



- (UIImage *)imageForKey:(NSString *)key
{
  //return [self.dictionary objectForKey:key];
  //return self.dictionary[key];
  
  UIImage *result = self.dictionary[key];
  if (!result) {
    NSString *imagePath = [self imagePathForKey:key];
    result = [UIImage imageWithContentsOfFile:imagePath];
    if (result) {
      self.dictionary[key] = result;
    } else {
      NSLog(@"Error: unable to find %@",imagePath);
    }
  }
  return result;
}




- (void)deletImageForKey:(NSString *)key
{
  if (!key){
    return;
  }
  [self.dictionary removeObjectForKey:key];
  
  NSString *imagePath = [self imagePathForKey:key];
  [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}




- (NSString *)imagePathForKey:(NSString *)key
{
  NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString * documentDirectory = [documentDirectories firstObject];
  return [documentDirectory stringByAppendingPathComponent:key];
}










@end
