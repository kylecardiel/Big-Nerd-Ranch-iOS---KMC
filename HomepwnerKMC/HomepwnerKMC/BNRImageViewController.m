//
//  BNRImageViewController.m
//  HomepwnerKMC
//
//  Created by Kyle on 9/7/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 - (void)loadView
{
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  self.view = imageView;
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  UIImageView *imageView = (UIImageView *)self.view;
  imageView.image = self.image;
}

@end
