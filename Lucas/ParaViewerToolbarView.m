//
//  ParaViewer.m
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import "ParaViewerToolbarView.h"

@implementation ParaViewerToolbarView
// Sub views defined.
UIButton *leftSliderViewButton;
UISearchBar *searchBar;
UIButton *libraryButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //Initialize $leftSliderViewerButton
        int leftSliderViewerButtonOffset = 5;
        int leftSliderViewerButtonLength = self.frame.size.height - leftSliderViewerButtonOffset * 2;
        leftSliderViewButton = [[UIButton alloc] initWithFrame:CGRectMake(leftSliderViewerButtonOffset, leftSliderViewerButtonOffset, leftSliderViewerButtonLength, leftSliderViewerButtonLength )];
        [leftSliderViewButton setBackgroundColor:[UIColor grayColor]];
        
        //Add sub views.
        [self addSubview:leftSliderViewButton];
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

@end
