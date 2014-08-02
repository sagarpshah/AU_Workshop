//
//  ScrollViewContainer.m
//  ScrollViews
//
//  Created by Ishi Systems on 02/08/14.
//  Copyright (c) 2014 Ishi Systems. All rights reserved.
//

#import "ScrollViewContainer.h"

@implementation ScrollViewContainer

@synthesize scrollView = _scrollView;

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _scrollView;
    }
    
    return view;
}

@end
