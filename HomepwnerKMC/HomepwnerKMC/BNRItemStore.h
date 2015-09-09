//
//  BNRItemStore.h
//  HomepwnerKMC
//
//  Created by Kyle on 8/30/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject


@property (nonatomic, readonly, copy) NSArray *allItems;


+ (instancetype)sharedStore;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL)saveChanges;
- (NSArray *)allAssetTypes;

@end
