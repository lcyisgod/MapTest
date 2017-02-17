//
//  MapViewController.m
//  MapTest
//
//  Created by 梁成友 on 16/8/8.
//  Copyright © 2016年 ZhiQing. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnation.h"
#import "Coordinate2D.h"
#import "MapViewController2.h"


@interface MapViewController ()<MKMapViewDelegate>
@property (nonatomic, strong)MKMapView *mapView;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic,strong)Coordinate2D *coordinate;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"系统大头针"];
     [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next:)]];
    [self initGUI];
}

-(void)upDataWiht:(Coordinate2D *)data
{
    self.coordinate = data;
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
}

-(void)next:(UIButton *)sender
{
    MapViewController2 *mapController = [[MapViewController2 alloc] init];
    [mapController upDataWiht:self.coordinate];
    [self.navigationController pushViewController:mapController animated:YES];
}

#pragma mark 添加大头针
-(void)addAnnotation{
    CLLocationCoordinate2D location1=self.coordinate.coordinate2D;
    KCAnnation *annotation1 = [[KCAnnation alloc] init];
    annotation1.title=@"1929 Art Space";
    annotation1.subtitle=@"我的工作地址";
    annotation1.coordinate=location1;
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
    annotation2.coordinate=location2;
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
            //允许交互点击
            annotationView.canShowCallout=true;
            annotationView.calloutOffset=CGPointMake(0, 0);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe.png"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image = ((KCAnnation *)annotation).image;
        return annotationView;
    }else {
        return nil;
    }
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
