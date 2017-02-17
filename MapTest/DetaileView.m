//
//  DetaileView.m
//  MapTest
//
//  Created by apple on 2016/12/16.
//  Copyright © 2016年 ZhiQing. All rights reserved.
//

#import "DetaileView.h"

@interface DetaileView ()
@property(nonatomic, strong)UILabel *tiltelbl;
@end
@implementation DetaileView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:self.tiltelbl];
    }
    return self;
}

-(UILabel *)tiltelbl
{
    if (!_tiltelbl) {
        self.tiltelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.frame.size.width, 50)];
        [self.tiltelbl setTextColor:[UIColor redColor]];
        self.tiltelbl.textAlignment = NSTextAlignmentCenter;
    }
    return _tiltelbl;
}

-(void)showWithStr:(NSString *)str
{
    [self.tiltelbl setText:str];
}
@end
