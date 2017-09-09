//
//  MapNavigationTool.m
//  Now
//
//  Created by silence on 2017/9/9.
//  Copyright © 2017年 ijiyo. All rights reserved.
//

#import "MapNavigationTool.h"

#import "CustomActionSheet.h"
#import "JZLocationConverter.h"

@interface MapNavigationTool()<CustomActionSheetDelagate>

@property(strong,nonatomic)NSString  *placeName;


/**
 用于存储当前手机中可用的地图
 */
@property(strong,nonatomic)NSArray   *maps;

/**
 要导航位置的坐标
 */
@property(assign,nonatomic)CLLocationCoordinate2D locationCoordinate2D;

@end

@implementation MapNavigationTool


/**
 导航
 
 @param longitude    经度
 @param latitude     纬度
 */
- (void)gotoNavigateWithLongitude:(double)longitude latitude:(double)latitude placeName:(NSString *)placeName{
    
    self.placeName = placeName;
    self.locationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude);

    self.maps = [self getInstalledMapAppWithEndLocation:self.locationCoordinate2D];

    NSMutableArray *titlesArr = [NSMutableArray array];
    for (int i = 0; i < self.maps.count; i++) {
        
        NSDictionary *dict = [self.maps objectAtIndex:i];
        NSString *temp = [dict objectForKey:@"title"];
        [titlesArr addObject:temp];
    }
    
    CustomActionSheet *mySheet = [[CustomActionSheet alloc] initWithTitle:nil otherButtonTitles:titlesArr];
    
    mySheet.delegate = self;
    [mySheet show];
}


/**
 统计可以使用的地图

 需要注意：苹果自带的地图以外，使用其他地图需要添加白名单
 即：再Info.plist 文件中添加元素
 
  LSApplicationQueriesSchemes   Array     数组类型
  NSString                      iosamap
  NSString                      comgooglemaps
  NSString                      baidumap
  NSString                      qqmap

 @param endLocation 终点坐标
 @return 返回可以使用的地图的数组
 */
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];
    
    // 苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图（推荐）";
    
    [maps addObject:iosMapDic];
    
    // 高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    // 谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航功能",@"nav123456",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    // 百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude,self.placeName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    // 腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }

    return maps;
}

#pragma mark - delegate
- (void)sheet:(CustomActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != -1) {
        
        if (buttonIndex == 0) {
            [self navAppleMap];
            return;
        }
        
        NSDictionary *dic = self.maps[buttonIndex];
        NSString *urlString = dic[@"url"];
        
        CGFloat systemVersion =  [[[UIDevice currentDevice] systemVersion] floatValue];

        if (systemVersion < 10.0) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }else{
            
            [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        }
    }
}

// 苹果地图
- (void)navAppleMap
{
    // 终点坐标
    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:self.locationCoordinate2D];
    
    // 当前坐标
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    
    // 终点坐标
    if (self.placeName) {
        toLocation.name = self.placeName;
    }
    
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dict = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsShowsTrafficKey:@(YES)};
    [MKMapItem openMapsWithItems:items launchOptions:dict];
}

@end
