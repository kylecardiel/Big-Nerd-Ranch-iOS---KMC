//
//  BNRItem.m
//  RandomItems
//
//  Created by Kyle on 8/25/15.
//  Copyright (c) 2015 DePaul University. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

+(instancetype)randomItem
{
  NSArray *randomAdjectiveList = @[@"Fluffy", @"Rsuty", @"Shiny"];
  NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
  
  NSInteger adjectiveIndex = arc4random()  % [randomAdjectiveList count];
  NSInteger nounIndex = arc4random()  % [randomNounList count];
  
  //NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                          //[randomAdjectiveList objectAtIndex:adjectiveIndex],
                          //[randomNounList objectAtIndex:nounIndex]];
  
  NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                          randomAdjectiveList[adjectiveIndex],
                          randomNounList[nounIndex]];
  
  
  int randomValue = arc4random() % 100;
  
  NSString *randomSerialNumber = [NSString stringWithFormat:@"%C%C%C%C%C",
                                  (unichar)('0' + arc4random() % 10),
                                  (unichar)('A' + arc4random() % 26),
                                  (unichar)('0' + arc4random() % 10),
                                  (unichar)('A' + arc4random() % 26),
                                  (unichar)('0' + arc4random() % 10)];
  
  BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                     valueInDollars:randomValue
                                       serialNumber:randomSerialNumber];
  
  return newItem;
  
}


- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
  self = [super init];
  
  if (self){
    _itemName = name;
    _serialNumber = sNumber;
    _valueInDollars = value;
    _dateCreated  = [[NSDate alloc] init];
  }
  
  return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
  return [self initWithItemName:name
                 valueInDollars:0
                   serialNumber:@""];
}

- (instancetype)init
{
  return [self initWithItemName:@"Item"];
}


- (void)dealloc
{
  NSLog(@"Destroyed: %@", self);
}


- (NSString *)description
{
  NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                         self.itemName,
                         self.serialNumber,
                         self.valueInDollars,
                         self.dateCreated];
  return descriptionString;
}


- (void)setContainedItem:(BNRItem *)containedItem
{
  _containedItem = containedItem;
  self.containedItem.container = self;
}



/*

- (void)setItemName:(NSString *)str
{
  _itemName = str;
}

- (NSString *)itemName
{
  return _itemName;
}

- (void)setSerialNumber:(NSString *)str
{
  _serialNumber = str;
}

- (NSString *)serialNumber
{
  return _serialNumber;
}

- (void)setValueInDollars:(int)v
{
  _valueInDollars = v;
}

- (int)valueInDollars
{
  return _valueInDollars;
}

- (NSDate *)dateCreated
{
  return _dateCreated;
}

- (void)setContainedItem:(BNRItem *)item
{
  _containedItem = item;
  item.container = self;
}

- (BNRItem *)containedItem
{
  return _containedItem;
}

- (void)setContainer:(BNRItem *)item
{
  _container = item;
}

- (BNRItem *)container
{
  return _container;
}

*/


@end
