//
//  RMDisplayLabel.m
//  BezierLoaders
//
//  Created by Mahesh on 1/30/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "RMDisplayLabel.h"

@interface RMDisplayLabel()

@property(nonatomic, strong)NSTimer *countTimer;

@end

@implementation RMDisplayLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateValue:(NSInteger)value
{
    // Change the text
    self.text = [NSString stringWithFormat:@"%d%%", value/*(int)(value * 100)*/];
}

@end
