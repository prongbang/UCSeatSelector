//
//  UCSeatTypeItem.m
//  pocSeatSelector
//
//  Created by anonymous on 2/9/2562 BE.
//  Copyright © 2562 anonymous. All rights reserved.
//

#import "UCSeatTypeItem.h"

@implementation UCSeatTypeItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _seatTypeCode = @"";
        _seatColor = @"";
    }
    return self;
}

- (instancetype)initWithSeatTypeCode:(NSString *)seatTypeCode seatColor:(NSString *)seatColor {
    self = [super init];
    if (self) {
        _seatTypeCode = seatTypeCode;
        _seatColor = seatColor;
    }
    return self;
}

@end