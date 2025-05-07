//
//  UCSeatItem.h
//  UCCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//  代码地址：https://www.github.com/Upliver/FVSeatsPicker

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UCSeatState)
{
    UCSeatsStateAvailable   = 0,          // 可用
    UCSeatsStateUnavailable = 1,          // 不可用
    UCSeatsStateLocked      = 2,          // 被锁定
    UCSeatsStateSellOut     = 3           // 售出
};

@interface UCSeatItem : NSObject

@property(nonatomic, assign) int seatId;
@property(nonatomic, strong) NSString *seatName;
@property(nonatomic, assign) int price;
@property(nonatomic, assign) int col;
@property(nonatomic, assign) int row;
@property(nonatomic, assign) UCSeatState seatStatus;
@property(nonatomic, assign) int coordinateX;
@property(nonatomic, assign) int coordinateY;

@end
