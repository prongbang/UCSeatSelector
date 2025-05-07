//
//  UCSeatRelationItem.m
//  pocSeatSelector
//
//  Created by anonymous on 3/9/2562 BE.
//  Copyright © 2562 anonymous. All rights reserved.
//

#import "UCSeatRelationItem.h"

@implementation UCSeatRelationItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _rowIndex = 0;
        _columnIndex = 0;
    }
    return self;
}

- (instancetype)initWithRowIndex:(int)rowIndex columnIndex:(int)columnIndex {
    self = [super init];
    if (self) {
        _rowIndex = rowIndex;
        _columnIndex = columnIndex;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"UCSeatRelationItem: row=%d, column=%d", _rowIndex, _columnIndex];
}

@end