//
//  MapNavigationTool.h
//  Now
//
//  Created by silence on 2017/9/9.
//  Copyright © 2017年 ijiyo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 地图（定位／导航）
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>
#import <MapKit/MapKit.h>


@interface MapNavigationTool : NSObject


/**
 导航

 @param longitude    经度
 @param latitude     纬度
 @param placeName   地点名称
 */
- (void)gotoNavigateWithLongitude:(double)longitude latitude:(double)latitude placeName:(NSString *)placeName;

@end
