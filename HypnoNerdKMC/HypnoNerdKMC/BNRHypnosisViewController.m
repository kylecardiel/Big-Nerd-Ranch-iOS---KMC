//
//  BNRHypnosisViewController.m
//  HypnoNerdKMC
//
//  Created by Kyle on 8/29/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController () <UITextFieldDelegate>

@end

@implementation BNRHypnosisViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if(self) {
    self.tabBarItem.title = @"Hypnotize";
    UIImage *image = [UIImage imageNamed:@"Hypno.png"];
    
    self.tabBarItem.image = image;
    
    
  }
  
  return self;
}



- (void)loadView
{
  CGRect frame = [UIScreen mainScreen].bounds;
  BNRHypnosisView *backrgoundView = [[BNRHypnosisView alloc] initWithFrame:frame];
  
  CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
  UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
  
  textField.borderStyle  = UITextBorderStyleRoundedRect;
  textField.placeholder = @"Hypnotize";
  textField.returnKeyType  = UIReturnKeyDone;
  
  textField.delegate = self;
  
  
  [backrgoundView addSubview:textField];
  
  self.view = backrgoundView;
  
}

- (void)viewDidLoad {
      [super viewDidLoad];
  
    NSLog(@"BNRHypnosisViewController loaded its view.");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  //NSLog(@"%@", textField.text);
  [self drawHypnotivMessage:textField.text];
  
  textField.text = @"";
  [textField resignFirstResponder];
  
  return YES;
}


- (void)drawHypnotivMessage:(NSString *)message
{
  for (int i = 0; i < 20; i++) {
    
    UILabel *messageLabel = [[UILabel alloc] init];
    
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.text = message;
    
    [messageLabel sizeToFit];
    
    int width = self.view.bounds.size.width - messageLabel.bounds.size.width;
    int x = arc4random() % width;
    
    int height = self.view.bounds.size.height - messageLabel.bounds.size.height;
    int y = arc4random() % height;
    
    
    CGRect frame = messageLabel.frame;
    frame.origin = CGPointMake(x, y);
    messageLabel.frame = frame;
    
    [self.view addSubview:messageLabel];
    
    
    UIInterpolatingMotionEffect *motionEffect;
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @-25;
    motionEffect.maximumRelativeValue = @25;
    
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffect.minimumRelativeValue = @-25;
    motionEffect.maximumRelativeValue = @25;
    
    [messageLabel addMotionEffect:motionEffect];
    
  }
}



@end
