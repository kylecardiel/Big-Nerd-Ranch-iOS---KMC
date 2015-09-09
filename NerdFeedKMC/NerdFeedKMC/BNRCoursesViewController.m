//
//  BNRCourses.m
//  NerdFeedKMC - Chapter 21/22
//
//  Created by Kyle on 9/7/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRCoursesViewController.h"
#import "BNRWebViewController.h"


@interface BNRCoursesViewController () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;

@end



@implementation BNRCoursesViewController


- (instancetype)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.navigationItem.title = @"BNR Courses";
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //_session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    [self fetchFeed];
  }
  return self;
}


- (void)fetchFeed
{
  //NSString *requestingString = @"http://bookapi.bignerdranch.com/courses.json";
  NSString *requestingString = @"https://bookapi.bignerdranch.com/private/courses.json";
  NSURL *url = [NSURL URLWithString:requestingString];
  NSURLRequest *req = [NSURLRequest requestWithURL:url];
  NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",json);
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //NSLog(@"%@", jsonObject);
    self.courses = jsonObject[@"courses"];
    NSLog(@"%@",self.courses);
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  }];
  [dataTask resume];
}



- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.courses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  NSDictionary *course = self.courses[indexPath.row];
  cell.textLabel.text = course[@"title"];
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *course = self.courses[indexPath.row];
  NSURL *URL = [NSURL URLWithString:course[@"url"]];
  self.webViewController.title = course[@"tile"];
  self.webViewController.URL = URL;
  //[self.navigationController pushViewController:self.webViewController animated:YES];
  if (!self.splitViewController) {
    [self.navigationController pushViewController:self.webViewController animated:YES];
  }
  
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
  NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana" persistence:NSURLCredentialPersistenceForSession];
  completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}


@end
