//
//  ViewController.m
//  MapTest
//
//  Created by 梁成友 on 16/8/5.
//  Copyright © 2016年 ZhiQing. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "KCAnnation.h"
#import "Coordinate2D.h"
#import "MapViewController.h"

//参考博客地址:http://www.cnblogs.com/kenshincui/p/4125570.html#autoid-3-0-0

@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)CLGeocoder *geocooder;
@property (nonatomic, strong)Coordinate2D *coorDination;
@property (nonatomic, strong)CLLocation *Loction;

@property (nonatomic, strong)UIButton *startCurrentLocation;       //开启定位
@property (nonatomic, strong)UIButton *codeLocation;               //地址编码
@property (nonatomic, strong)UIButton *goldeLocation;              //逆地址编码
@property (nonatomic, assign)int type;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initElem];
}

-(void)initElem
{
    [self.navigationItem setTitle:@"地图首页"];
    self.coorDination = [Coordinate2D new];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next:)]];
    [self.view addSubview:self.codeLocation];
    [self.view addSubview:self.startCurrentLocation];
    [self.view addSubview:self.goldeLocation];
}


-(UIButton *)codeLocation
{
    if (!_codeLocation) {
        self.codeLocation = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-40, self.view.center.y-25, 80, 50)];
        [self.codeLocation setTitle:@"地理定位" forState:UIControlStateNormal];
        self.codeLocation.backgroundColor = [UIColor colorWithRed:36/255.0 green:131/255.0 blue:203/255.0 alpha:1.0];
        [self.codeLocation addTarget:self action:@selector(nowLocation:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _codeLocation;
}

-(UIButton *)startCurrentLocation
{
    if (!_startCurrentLocation) {
        self.startCurrentLocation = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-40, CGRectGetMidY(self.codeLocation.frame)-100, 80, 50)];
        [self.startCurrentLocation setTitle:@"开始定位" forState:UIControlStateNormal];
        self.startCurrentLocation.backgroundColor = [UIColor colorWithRed:36/255.0 green:131/255.0 blue:203/255.0 alpha:1.0];
        [self.startCurrentLocation addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startCurrentLocation;
}

-(UIButton *)goldeLocation
{
    if (!_goldeLocation) {
        self.goldeLocation = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-40, CGRectGetMaxY(self.codeLocation.frame)+30, 80, 50)];
        [self.goldeLocation setTitle:@"反编码" forState:UIControlStateNormal];
        self.goldeLocation.backgroundColor = [UIColor colorWithRed:36/255.0 green:131/255.0 blue:203/255.0 alpha:1.0];
        [self.goldeLocation addTarget:self action:@selector(glodeNowLocation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goldeLocation;
}
-(void)startLocation
{
    //定位管理器
    //注意:在开启定位时需要到info.plist文件中设置相应参数
    _locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前尚未打开,请设置打开!");
        return;
    }
    
    //如果没有授权啧请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位频率,每隔多少米定位一次
        CLLocationDistance distance = 0.1;
        _locationManager.distanceFilter = distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

-(void)nowLocation:(UIButton *)sender
{
    //信息编码
    if (!_geocooder) {
        _geocooder = [[CLGeocoder alloc] init];
    }
    [self getCoordinateByAddress:@"上海东大名路687号"];
}

-(void)glodeNowLocation:(UIButton *)sender
{
    //反地址编码
    if (!_geocooder) {
        _geocooder = [[CLGeocoder alloc] init];
    }
    [self getaAddressByLatitude:self.Loction.coordinate.latitude longitude:self.Loction.coordinate.latitude];
}

-(void)next:(UIButton *)sender
{
    self.coorDination.coordinate2D = CLLocationCoordinate2DMake(31.24995550, 121.50117850);
    MapViewController *mapController = [[MapViewController alloc] init];
    [mapController upDataWiht:self.coorDination];
    [self.navigationController pushViewController:mapController animated:YES];
}


#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];//取出第一个位置
    self.Loction = location;
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",location.coordinate.longitude,location.coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，就关闭定位
    [_locationManager stopUpdatingLocation];
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address
{
    //地理编码
    [_geocooder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //取得第一个地标,地标中存储了详细的地址信息
        CLPlacemark *placemark = [placemarks firstObject];
        
        CLLocation *location = placemark.location;//位置
        CLRegion *region = placemark.region;//区域
        NSDictionary *addressDic = placemark.addressDictionary;//详细地址信息字典，,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@\n区域:%@\n详细信息:%@",location,region,addressDic);
        
    }];
}

#pragma mark 根据坐标取得地名
-(void)getaAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [_geocooder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
