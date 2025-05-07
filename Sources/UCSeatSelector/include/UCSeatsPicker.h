//
//  UCSeatsPicker.h
//  FVCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//  代码地址：https://www.github.com/Upliver/UCSeatsPicker

#import <UIKit/UIKit.h>
#import "UCSeatItem.h"
#import "UCSeatTypeItem.h"

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
@property (nonatomic, strong) NSString* screenText;
@property (nonatomic, strong) UIFont* screenTextFont;
@property (nonatomic, strong) UIColor* screenTextColor;
@property (nonatomic, strong) NSArray<UCSeatItem *>* seats;
@property (nonatomic, strong) NSArray<UCSeatTypeItem *>* seatTypes;
@property (nonatomic, strong) NSArray<NSString *>* customIndexList;
@property (nonatomic, strong) UIFont* customIndexListFont;
@property (nonatomic, strong) UIColor* customIndexListLabelColor;
@property (nonatomic, strong) UIColor* customIndexListBackgroundColor;

- (NSArray<UCSeatItem *>*)selectedSeats;
- (void)setImage:(UIImage* )image forState:(UIControlState)state;
- (void)reloadData;
- (void)tryToChangeSelectionOfSeat:(UCSeatItem *)seat;

@end
