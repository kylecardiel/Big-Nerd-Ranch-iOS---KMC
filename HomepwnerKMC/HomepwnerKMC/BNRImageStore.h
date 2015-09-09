//
//  BNRImageStore.h
//  HomepwnerKMC
//
//  Created by Kyle on 9/1/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import <Foundation/Foundation.h>
//Added UIKit becuase with the release of swift UIImage is no longer part of the foundations framework
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deletImageForKey:(NSString *)key;

@end
