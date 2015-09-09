//
//  BNRImageTransformer.m
//  HomepwnerKMC
//
//  Created by Kyle on 9/7/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRImageTransformer.h"
#import "UIKit/UIKit.h"

@implementation BNRImageTransformer


+ (Class)transformedValueClass
{
  return [NSData class];
}


- (id)transformedValue:(id)value
{
  if (!value) {
    return nil;
  }
  
  if ([value isKindOfClass:[NSData class]]) {
    return value;
  }
  
  return UIImagePNGRepresentation(value);
}


- (id)reverseTransformedValue:(id)value
{
  return [UIImage imageWithData:value];
}


@end
