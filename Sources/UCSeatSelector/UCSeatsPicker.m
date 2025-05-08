//
//  UCSeatsPicker.m
//  UCCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//  代码地址：https://www.github.com/Upliver/FVSeatsPicker

#import "UCSeatsPicker.h"
#import "UCSeatsPickerIndexView.h"
#import <objc/runtime.h>

static const CGFloat kRowIndexWidth = 14;
static const char kSeatInfo;


@interface UCSeatsPicker()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *screenLabel;
@end

@implementation UCSeatsPicker
{
    UIView* _contentView;
    UCSeatsPickerIndexView* _rowIndexView;
    
    NSMutableDictionary<NSNumber*, UIImage*>* _imageDict;
    NSArray<UIButton*>* _buttons;
    
    UIEdgeInsets _boundsInset;
    
    struct {
        BOOL responseToShouldSelectSeat: 1;
        BOOL responseToShouldDeselectSeat: 1;
        BOOL responseToDidSelectSeat: 1;
        BOOL responseToDidDeselectSeat: 1;
        BOOL responseToSelectionChanged: 1;
    } _flags;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageDict = [NSMutableDictionary dictionary];
        [self configDefaultSeatsIcon];
        _boundsInset = UIEdgeInsetsMake(20, 20, 20, 20);
        self.delegate = self;
        
        // Initialize new properties with default values
        _screenText = @"Screen";
        _screenTextFont = [UIFont boldSystemFontOfSize:16.0];
        _screenTextColor = [UIColor blackColor];
        _customIndexListFont = [UIFont systemFontOfSize:10.0];
        _customIndexListLabelColor = [UIColor whiteColor];
        _customIndexListBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentView.center = [self contentCenter];
}

- (void)setImage:(UIImage*)image forState:(UIControlState)state
{
    if (image != nil)
    {
        _imageDict[@(state)] = image;
    }
    [self configDefaultSeatsIcon];
}

- (void)configDefaultSeatsIcon
{
    NSString *source1 = [[self fv_bundle] pathForResource:@"seat_available@2x" ofType:@"png"];
    _imageDict[@(UIControlStateNormal)] = [[UIImage imageWithContentsOfFile:source1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSString *source2 = [[self fv_bundle] pathForResource:@"seat_disabled@2x" ofType:@"png"];
    _imageDict[@(UIControlStateDisabled)] = [[UIImage imageWithContentsOfFile:source2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSString *source3 = [[self fv_bundle] pathForResource:@"seat_selected@2x" ofType:@"png"];
    _imageDict[@(UIControlStateSelected)] = [[UIImage imageWithContentsOfFile:source3] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (NSBundle *)fv_bundle
{
    static NSBundle *seatBundle = nil;
    if (seatBundle == nil)
    {
        seatBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"UCSeatsPicker" ofType:@"bundle"]];
    }
    return seatBundle;
}

- (NSArray<UCSeatItem *>*)selectedSeats
{
    NSArray<UIButton*>* buttons = [_buttons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected = %@", @(YES)]];
    if (buttons.count)
    {
        NSMutableArray<UCSeatItem *>* list = [NSMutableArray array];
        [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UCSeatItem* info = objc_getAssociatedObject(obj, &kSeatInfo);
            if (info) {[list addObject:info];};
        }];
        [list sortUsingComparator:^NSComparisonResult(UCSeatItem* _Nonnull obj1, UCSeatItem* _Nonnull obj2) {
            if (obj1.row < obj2.row) return NSOrderedAscending;
            else if (obj1.row > obj2.row) return NSOrderedDescending;
            else if (obj1.col < obj2.col) return NSOrderedAscending;
            else if (obj1.col > obj2.col) return NSOrderedDescending;
            else return NSOrderedSame;
        }];
        return [NSArray arrayWithArray:list];
    }
    return nil;
}

- (void)setSeatsDelegate:(id<UCSeatsPickerDelegate>)seatsDelegate
{
    _seatsDelegate = seatsDelegate;
    
    _flags.responseToShouldSelectSeat = [seatsDelegate respondsToSelector:@selector(shouldSelectSeat:inPicker:)];
    _flags.responseToShouldDeselectSeat = [seatsDelegate respondsToSelector:@selector(shouldDeselectSeat:inPicker:)];
    _flags.responseToDidSelectSeat = [seatsDelegate respondsToSelector:@selector(seatsPicker:didSelectSeat:)];
    _flags.responseToDidDeselectSeat = [seatsDelegate respondsToSelector:@selector(seatsPicker:didDeselectSeat:)];
    _flags.responseToSelectionChanged = [seatsDelegate respondsToSelector:@selector(selectionDidChangeInSeatsPicker:)];
}

- (void)reloadData
{
    [_contentView removeFromSuperview];
    [_screenLabel removeFromSuperview];
    _buttons = nil;
    _rowIndexView = nil;
    
    if (_cellSize.width < 1 || _cellSize.height < 1 || !_seats.count)
    {
        if (_flags.responseToSelectionChanged)
        {
            [_seatsDelegate selectionDidChangeInSeatsPicker:self];
        }
        return;
    }
    
    _contentView = [UIView new];
    NSMutableArray<UIButton*>* buttons = [NSMutableArray array];
    
    for (UCSeatItem* info in _seats)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((info.coordinateX - 1) * _cellSize.width + _boundsInset.left,
                                  (info.coordinateY - 1) * _cellSize.height + _boundsInset.top,
                                  _cellSize.width,
                                  _cellSize.height);
        
        for (NSNumber* state in _imageDict)
        {
            [button setImage:_imageDict[state] forState:state.unsignedIntegerValue];
        }
        
        button.enabled = info.seatStatus == UCSeatsStateAvailable;
        objc_setAssociatedObject(button, &kSeatInfo, info, OBJC_ASSOCIATION_ASSIGN);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
        
        [_contentView addSubview:button];
    }
    
    self.zoomScale = 1;
    CGSize size = CGSizeMake(_colCount * _cellSize.width + _boundsInset.left + _boundsInset.right,
                             _rowCount * _cellSize.height + _boundsInset.top + _boundsInset.bottom);
    _contentView.frame = (CGRect){0, 0, size};
    [self addSubview:_contentView];
    self.contentSize = size;
    _buttons = [NSArray arrayWithArray:buttons];
    
    // Add screen label
    [self setupScreenLabel];
    
    // Create row index view with customization options
    _rowIndexView = ({
        UCSeatsPickerIndexView* indexView = [[UCSeatsPickerIndexView alloc] initWithFrame:CGRectMake(0, _boundsInset.top, kRowIndexWidth, _rowCount * _cellSize.height)];
        indexView.backgroundColor = _customIndexListBackgroundColor ?: [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
        
        // Use custom index list if provided
        if (_customIndexList && _customIndexList.count > 0) {
            indexView.indexList = _customIndexList;
        } else {
            indexView.indexList = [self buildRowIndexList];
        }
        
        [_contentView addSubview:indexView];
        indexView;
    });
}

- (NSArray<NSString*>*)buildRowIndexList
{
    if (_seats.count)
    {
        NSMutableArray<NSString*>* arr = [[NSMutableArray alloc] initWithCapacity:_rowCount];
        for (NSUInteger row = 0; row < _rowCount; row ++) {
            [arr addObject:[NSString string]];
        }
        
        [_seats enumerateObjectsUsingBlock:^(UCSeatItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger row = obj.coordinateY - 1;
            if (row < _rowCount && arr[row].length == 0)
            {
                arr[row] = @(obj.row).stringValue;
            }
        }];
        
        return [NSArray arrayWithArray:arr];
    }
    else
    {
        return nil;
    }
}

- (void)buttonClicked:(UIButton* )button
{
    UCSeatItem *info = objc_getAssociatedObject(button, &kSeatInfo);
    if (button.selected)
    {
        if (!_flags.responseToShouldDeselectSeat || [_seatsDelegate shouldDeselectSeat:info inPicker:self])
        {
            button.selected = NO;
            if (_flags.responseToDidDeselectSeat)
            {
                [_seatsDelegate seatsPicker:self didDeselectSeat:info];
            }
            if (_flags.responseToSelectionChanged)
            {
                [_seatsDelegate selectionDidChangeInSeatsPicker:self];
            }
        }
    }
    else
    {
        if (!_flags.responseToShouldSelectSeat || [_seatsDelegate shouldSelectSeat:info inPicker:self])
        {
            button.selected = YES;
            if (_flags.responseToDidSelectSeat)
            {
                [_seatsDelegate seatsPicker:self didSelectSeat:info];
            }
            if (_flags.responseToSelectionChanged)
            {
                [_seatsDelegate selectionDidChangeInSeatsPicker:self];
            }
        }
    }
}

- (void)tryToChangeSelectionOfSeat:(UCSeatItem *)seat
{
    if (!seat || !_buttons.count)
    {
        return;
    }
    
    NSUInteger index = [_buttons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        return objc_getAssociatedObject(obj, &kSeatInfo) == seat;
    }];
    
    if (index != NSNotFound)
    {
        [self buttonClicked:_buttons[index]];
    }
}

- (CGPoint)contentCenter
{
    CGSize outerSize = self.bounds.size;
    CGSize innerSize = self.contentSize;
    return CGPointMake(MAX(outerSize.width / 2, innerSize.width / 2), MAX(outerSize.height / 2, innerSize.height / 2));
}

- (void)repositionIndexView
{
    _rowIndexView.frame = ({
        CGRect rect = _rowIndexView.frame;
        rect.origin.x = self.contentOffset.x / self.zoomScale;
        rect;
    });
}

#pragma mark - Scroll View Delegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _contentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self repositionIndexView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self repositionIndexView];
}

- (void)setupScreenLabel
{
    if (_screenText.length > 0) {
        if (!_screenLabel) {
            _screenLabel = [[UILabel alloc] init];
            _screenLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        _screenLabel.text = _screenText;
        _screenLabel.font = _screenTextFont ?: [UIFont boldSystemFontOfSize:16.0];
        _screenLabel.textColor = _screenTextColor ?: [UIColor blackColor];
        
        CGFloat labelWidth = _colCount * _cellSize.width;
        CGFloat labelHeight = 30.0; // Default height for screen label
        
        _screenLabel.frame = CGRectMake(_boundsInset.left, 0, labelWidth, labelHeight);
        [_contentView addSubview:_screenLabel];
    }
}

- (void)setScreenText:(NSString *)screenText
{
    if (![_screenText isEqualToString:screenText]) {
        _screenText = [screenText copy];
        if (_contentView) {
            [self setupScreenLabel];
        }
    }
}

- (void)setScreenTextFont:(UIFont *)screenTextFont
{
    _screenTextFont = screenTextFont;
    if (_screenLabel) {
        _screenLabel.font = screenTextFont;
    }
}

- (void)setScreenTextColor:(UIColor *)screenTextColor
{
    _screenTextColor = screenTextColor;
    if (_screenLabel) {
        _screenLabel.textColor = screenTextColor;
    }
}

- (void)setCustomIndexList:(NSArray<NSString *> *)customIndexList
{
    _customIndexList = [customIndexList copy];
    if (_rowIndexView) {
        _rowIndexView.indexList = customIndexList;
    }
}

- (void)setCustomIndexListBackgroundColor:(UIColor *)customIndexListBackgroundColor
{
    _customIndexListBackgroundColor = customIndexListBackgroundColor;
    if (_rowIndexView) {
        _rowIndexView.backgroundColor = customIndexListBackgroundColor;
    }
}

@end
