//
//  KCCalloutAnnotatonView.h
//  MapTest
//
//  Created by 梁成友 on 16/8/8.
//  Copyright © 2016年 ZhiQing. All rights reserved.
//

//自定义弹出详情大头针视图
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnation.h"
#import "KCCalloutAnnotation.h"
@interface KCCalloutAnnotatonView : MKAnnotationView
//@property(nonatomic, strong)KCCalloutAnnotation *annotation;
#pragma mark- 从缓存取出标注视图
+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;
@end
