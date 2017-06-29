//
//  CityViewController.m
//  Advertisement
//
//  Created by 翟凤禄 on 2017/6/29.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "CityViewController.h"
#define currentViewHeight [UIScreen mainScreen].bounds.size.height
#define currentViewWidth [UIScreen mainScreen].bounds.size.width
@interface CityViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    UITableView *_tableView;
    NSMutableArray *currentCityArr;
    NSMutableArray *allCityArr;
}
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, currentViewWidth, currentViewHeight-60)];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    currentCityArr = [NSMutableArray array];
    allCityArr = [NSMutableArray array];
    [currentCityArr addObject:@"北京"];
    [allCityArr addObject:@"北京"];
     [allCityArr addObject:@"天津"];
     [allCityArr addObject:@"南京"];
     [allCityArr addObject:@"济南"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return  currentCityArr.count;
    }else{
        return allCityArr.count;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident =@"cell";
    UITableViewCell *taskListCell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!taskListCell) {
        taskListCell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    if(indexPath.section==0){
        taskListCell.textLabel.text = currentCityArr[indexPath.row];
    }else{
        taskListCell.textLabel.text = allCityArr[indexPath.row];
    }
    taskListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return taskListCell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"当前定位城市";
    }else{
        return @"已开通服务城市";
    }
    
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
