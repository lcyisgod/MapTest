//
//  Coordinate2D.m
//  MapTest
//
//  Created by 梁成友 on 16/8/8.
//  Copyright © 2016年 ZhiQing. All rights reserved.
//

#import "Coordinate2D.h"



@implementation Coordinate2D
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.coordinate2D = CLLocationCoordinate2DMake(-3000, -3000);
    }
    return self;
}
@end
