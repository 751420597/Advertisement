//
//  ReservationStadusController.m
//  Advertisement
//
//  Created by 翟凤禄 on 2017/7/23.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "ReservationStadusController.h"
#import "LXCareVCTableCell.h"
static NSString *const LXCareVCTableCellID = @"LXCareVCTableCellID";
#define LXCareTableViewHeight  (LXScreenHeight - LXNavigaitonBarHeight - LXCareTableViewOriginY)
#define LXCareTableViewWidth   (LXScreenWidth - LXCareTableViewOriginX * 2)
static CGFloat LXCareTableViewRowHeight = 50;
static CGFloat LXCareTableViewOriginX = 10;
static CGFloat LXCareTableViewOriginY = 10;

@interface ReservationStadusController ()
{
    NSMutableArray *dataArr;
    NSMutableArray *dataArr2;
}
@end

@implementation ReservationStadusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"服务类型";
    self.view.backgroundColor = LXVCBackgroundColor;
    dataArr =[NSMutableArray array];
    [dataArr addObject:@"基本生活照料服务"];
    [dataArr addObject:@"医疗护理服务"];

    dataArr2 =[NSMutableArray array];
    [dataArr2 addObject:@"1"];
    [dataArr2 addObject:@"2"];
    [self setUpTableViewWithFrame:CGRectMake(LXCareTableViewOriginX, LXCareTableViewOriginY, LXCareTableViewWidth,LXCareTableViewHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    
    self.tableView.rowHeight = LXCareTableViewRowHeight;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* indent = @"indent";
    UITableViewCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:indent];
    
    if (!cell_1) {
        cell_1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indent];
        cell_1.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self addCustomeLineWithArray:[self.dataSource copy] indexPath:indexPath width:LXCareTableViewWidth height:50 color:LXCellBorderColor cell:cell_1];
        UILabel *nameL = [[UILabel alloc]init];
        nameL.font =[UIFont systemFontOfSize:15.f];
        nameL.tag = 100;
        [cell_1.contentView addSubview:nameL];
        
        UIImageView *iamgeV =[[UIImageView alloc]init];
        iamgeV.contentMode =UIViewContentModeScaleAspectFit;
        iamgeV.tag = 101;
        
        [cell_1.contentView addSubview:iamgeV];
    }
    UILabel *nameL =[cell_1.contentView viewWithTag:100];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell_1);
        make.leading.equalTo(cell_1).offset(15);
    }];
    
     UIImageView *iamgeV =[cell_1.contentView viewWithTag:101];
    [iamgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell_1);
        make.trailing.equalTo(cell_1.contentView).offset(-15);
        make.width.offset(20);
        make.height.offset(20);
    }];
    NSString *ObjID = dataArr2[indexPath.row];
        if([ObjID isEqualToString:self.careID_0]){
            iamgeV.image =[UIImage imageNamed:@"Home_cell_selected"];
        }else{
            iamgeV.image =[UIImage imageNamed:@""];
        }
    
    
    nameL.text = dataArr[indexPath.row];
    
        return cell_1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *ID = dataArr2[indexPath.row] ;
    if (self.black) {
        self.black(ID.integerValue);
        [self.navigationController popViewControllerAnimated:YES];
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
