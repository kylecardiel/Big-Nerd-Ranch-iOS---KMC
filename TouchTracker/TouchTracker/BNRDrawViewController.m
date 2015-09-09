//
//  BNRDrawViewController.m
//  TouchTracker - BNR chapter12
//
//  Created by Kyle on 9/1/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@interface BNRDrawViewController ()

@end

@implementation BNRDrawViewController

- (void)viewDidLoad {
  self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
