//
//  UCSeatsPicker.h
//  UCCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//  代码地址：https://www.github.com/Upliver/FVSeatsPicker

#import <UIKit/UIKit.h>
#import "UCSeatItem.h"

@class UCSeatsPicker;

@protocol UCSeatsPickerDelegate<NSObject>

@optional
- (BOOL)shouldSelectSeat:(UCSeatItem *)seatInfo inPicker:(UCSeatsPicker* )picker;
- (BOOL)shouldDeselectSeat:(UCSeatItem *)seatInfo inPicker:(UCSeatsPicker* )picker;

- (void)seatsPicker:(UCSeatsPicker* )picker didSelectSeat:(UCSeatItem *)seatInfo;
- (void)seatsPicker:(UCSeatsPicker* )picker didDeselectSeat:(UCSeatItem *)seatInfo;

- (void)selectionDidChangeInSeatsPicker:(UCSeatsPicker *)picker;

@end

@interface UCSeatsPicker : UIScrollView

@property (nonatomic, weak) id<UCSeatsPickerDelegate> seatsDelegate;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) NSUInteger rowCount;
@property (nonatomic, assign) NSUInteger colCount;
@property (nonatomic, assign) NSArray<UCSeatItem *>* seats;

- (NSArray<UCSeatItem *>*)selectedSeats;
- (void)setImage:(UIImage* )image forState:(UIControlState)state;
- (void)reloadData;
- (void)tryToChangeSelectionOfSeat:(UCSeatItem *)seat;

@end
