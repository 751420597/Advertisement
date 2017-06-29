//
//  LXSelectCityViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/16.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSelectCityViewController.h"

#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "JFCityViewController.h"
#import "CityViewController.h"

#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

@interface LXSelectCityViewController ()

@property (nonatomic, strong) JFLocation *locationManager;
@property (nonatomic, strong) JFAreaDataManager *manager;

@end

@implementation LXSelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市选择";
    self.view.backgroundColor = LXVCBackgroundColor;
 
    CityViewController *cityViewController = [[CityViewController alloc] init];
    
    
    [self addChildViewController:cityViewController];
    [cityViewController.view setFrame:self.view.frame];
    [self.view addSubview:cityViewController.view];
    [cityViewController didMoveToParentViewController:self];
}


@end
