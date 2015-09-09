//
//  BNRDetailViewController.h
//  HomepwnerKMC
//
//  Created by Kyle on 9/1/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BNRItem;

@interface BNRDetailViewController : UIViewController

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
