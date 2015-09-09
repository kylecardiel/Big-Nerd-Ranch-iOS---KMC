//
//  BNRReminderViewController.m
//  HypnoNerdKMC
//
//  Created by Kyle on 8/29/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end


@implementation BNRReminderViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if(self) {
    self.tabBarItem.title = @"Reminder";
    UIImage *image = [UIImage imageNamed:@"Time.png"];
    
    self.tabBarItem.image = image;
    
    
  }
  
  return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
      NSLog(@"BNRReminderViewController loaded its view.");
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addReminder:(id)sender
{
  NSDate *date = self.datePicker.date;
  NSLog(@"Setting a reminder for %@", date);
  
  
  UILocalNotification *note = [[UILocalNotification alloc] init];
  note.alertBody = @"Hypnotize me!";
  note.fireDate = date;
  
  [[UIApplication sharedApplication] scheduleLocalNotification:note];
  
  
  //If statement added from http://stackoverflow.com/questions/24203066/ask-user-for-permission-to-show-alert-when-firing-local-notification to allow notifcation/premission for notification.
  if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
  }
  
  
  
  
}





@end
