//
//  UCSeatItem.m
//  UCCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//  代码地址：https://www.github.com/Upliver/FVSeatsPicker

#import "UCSeatItem.h"

@implementation UCSeatItem

- (NSString *)description
{
    NSArray *properties = @[@"seatId",@"seatName",@"price",@"col",@"row",@"seatStatus",@"coordinateX",@"coordinateY"];
    NSDictionary *propertiesDict = [self dictionaryWithValuesForKeys:properties];
    return [NSString stringWithFormat:@"<%@: %p> %@",self.class, self, propertiesDict];
}

@end
