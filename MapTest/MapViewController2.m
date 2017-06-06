//
//  MapViewController2.m
//  MapTest
//
//  Created by 梁成友 on 16/8/8.
//  Copyright © 2016年 ZhiQing. All rights reserved.
//

#import "MapViewController2.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnation.h"
#import "Coordinate2D.h"
#import "KCCalloutAnnotatonView.h"
#import "KCCalloutAnnotation.h"
#import "MapViewController3.h"
#import "DetaileView.h"

@interface MapViewController2 ()<MKMapViewDelegate>
@property (nonatomic, strong)MKMapView *mapView;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)Coordinate2D *coordinate;
@property (nonatomic, strong)DetaileView *detaileView;
@end

@implementation MapViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"自定义大头针"];
    [self initGUI];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next:)]];
    // Do any additional setup after loading the view.
}


-(void)initGUI
{
    CGRect rect = [UIScreen mainScreen].bounds;
    _mapView = [[MKMapView alloc] initWithFrame:rect];
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    /*地图类型
     MKMapTypeStandard  标准地图
     MKMapTypeSatellite 卫星地图
     MKMapTypeHybrid    混合地图
     */
    _mapView.mapType=MKMapTypeStandard;
    
    //添加大头针
    [self addAnnotation];
    [self.view addSubview:self.detaileView];
}

-(void)upDataWiht:(Coordinate2D *)data
{
    self.coordinate = data;
}

-(void)next:(UIButton *)sender
{
    MapViewController3 *mapController = [[MapViewController3 alloc] init];
    [self.navigationController pushViewController:mapController animated:YES];
}

-(DetaileView *)detaileView
{
    if (!_detaileView) {
        self.detaileView = [[DetaileView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
        self.detaileView.hidden = YES;
    }
    return _detaileView;
}

#pragma mark 添加大头针
-(void)addAnnotation{
    CLLocationCoordinate2D location1=self.coordinate.coordinate2D;
    KCAnnation *annotation1 = [[KCAnnation alloc] init];
    annotation1.title=@"1929 Art Space";
    annotation1.subtitle=@"我的工作地址";
    annotation1.image=[UIImage imageNamed:@"icon_pin_floating.png"];
    annotation1.icon=[UIImage imageNamed:@"icon_mark1.png"];
    annotation1.detail=@"1929 Art Space";
    annotation1.rate=[UIImage imageNamed:@"icon_Movie_Star_rating.png"];
    annotation1.coordinate = location1;
    [_mapView addAnnotation:annotation1];
    
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(31.249, 121.501);
    KCAnnation *annotation2 = [[KCAnnation alloc] init];
    annotation2.title=@"Kenshin&Kaoru";
    annotation2.subtitle=@"Kenshin Cui's Home";
    annotation2.image=[UIImage imageNamed:@"icon_paopao_waterdrop_streetscape.png"];
    annotation2.icon=[UIImage imageNamed:@"icon_mark2.png"];
    annotation2.detail=@"Kenshin Cui...";
    annotation2.rate=[UIImage imageNamed:@"icon_Movie_Star_rating.png"];
    annotation2.coordinate = location2;
    [_mapView addAnnotation:annotation2];
    
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[KCAnnation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            //如果要显示自定义的详情界面，则要不允许交互点击
            //允许交互点击
            //annotationView.canShowCallout=true;
            annotationView.calloutOffset=CGPointMake(0, 0);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe.png"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image = ((KCAnnation *)annotation).image;
        return annotationView;
    }else if ([annotation isKindOfClass:[KCCalloutAnnotation class]]){
        //对于作为弹出详情视图的自定义大头针无弹出交互功能(canShowCallout=false，这是默认值），在其中可以自由添加其他视图（因为它本身继承于UIView）
        KCCalloutAnnotatonView *calloutView=[KCCalloutAnnotatonView calloutViewWithMapView:_mapView];
        calloutView.annotation=annotation;
        return calloutView;
    }
    else {
        return nil;
    }
}

#pragma mark 选中大头针时触发
//点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    KCAnnation *annotation=view.annotation;
    if ([view.annotation isKindOfClass:[KCAnnation class]]) {
        //点击一个大头针时移除其他弹出详情视图
        [self removeCustomAnnotation];
        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
        KCCalloutAnnotation *annotation1=[[KCCalloutAnnotation alloc]init];
        annotation1.icon=annotation.icon;
        annotation1.detail=annotation.detail;
        annotation1.rate=annotation.rate;
        annotation1.coordinate=view.annotation.coordinate;
        [mapView addAnnotation:annotation1];
        self.detaileView.hidden = NO;
        [self.detaileView showWithStr:annotation.detail];
    }
}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCustomAnnotation];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[KCCalloutAnnotation class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
}



#pragma mark - 更新用户位置,主要用户改变则调用此方法
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    NSLog(@"%@",userLocation);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
