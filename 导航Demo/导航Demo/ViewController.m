//
//  ViewController.m
//  导航Demo
//
//  Created by silence on 2017/9/9.
//  Copyright © 2017年 silence. All rights reserved.
//

#import "ViewController.h"

#import "MapNavigationTool.h"

@interface ViewController ()

@property(strong,nonatomic)MapNavigationTool  *navTool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(self.view.bounds.size.width*.5 - 60,self.view.bounds.size.height*.5 - 25 , 120, 50);
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"导航" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)navAction{
    
    [self.navTool gotoNavigateWithLongitude:121.46896925568 latitude:31.20873257494 placeName:@"上海田子坊"];
}


- (MapNavigationTool *)navTool
{
    if (_navTool == nil)
    {
        _navTool  = [[MapNavigationTool alloc]init];
    }
    
    return _navTool;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
