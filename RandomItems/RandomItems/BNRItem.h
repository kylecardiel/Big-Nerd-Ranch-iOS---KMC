//
//  BNRItem.h
//  RandomItems
//
//  Created by Kyle on 8/25/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;


+ (instancetype) randomItem;

- (instancetype)initWithItemName:(NSString *)name
                    valueInDollars:(int)value
                     serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;


//constructors/initializers
//Designated initializer for BNRItem

/*{
 
 //Data members of a class
 NSString *_itemName;
 NSString *_serialNumber;
 int _valueInDollars;
 NSDate *_dateCreated;
 
 
 BNRItem *_containedItem;
 __weak BNRItem *_container;
 }*/

/*
- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)v;
- (int)valueInDollars;

- (NSDate *)dateCreated;

- (void)setContainedItem:(BNRItem *)item;
- (BNRItem *)containedItem;

- (void)setContainer:(BNRItem *)item;
- (BNRItem *)container;
*/

@end
