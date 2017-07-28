//
//  LXConfirmInfoViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXConfirmInfoViewController.h"

#import "LXConfirmInfoVCTableViewCell.h"
#import "LXAddCareVCTableViewCell2.h"

#import "LXConfirmInfoModel.h"

// Pictrue
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

#import "LXSandBox.h"
#define NUM @"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"

@interface LXConfirmInfoViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *lable1;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UILabel *lable3;
@property (nonatomic, strong) UIButton *leftUploadBtn;
@property (nonatomic, strong) UIButton *rightUploadBtn;
@property (nonatomic, strong) UIButton *leftUploadBtn1;
//@property (nonatomic, strong) UIButton *rightUploadBtn1;

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIImage *leftImage1;
//@property (nonatomic, strong) UIImage *rightImage1;

@property (nonatomic, copy) NSString *leftImageID;
@property (nonatomic, copy) NSString *rightImageID;
@property (nonatomic, copy) NSString *leftImageID1;
//@property (nonatomic, copy) NSString *rightImageID1;
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *identifyTF;
@property (nonatomic, strong) UITextField *appraisalTF;
@property (nonatomic, strong) UITextField *computerTF;

@property (nonatomic, strong) LXConfirmInfoModel *confirmInfoModel;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end


@implementation LXConfirmInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"信息认证";
    self.view.backgroundColor = LXVCBackgroundColor;
    self.confirmInfoModel = [[LXConfirmInfoModel alloc]init];
    if(self.msgAuthenModel){
        NSArray *raImageIdsArr = [self.msgAuthenModel.msgImageIds componentsSeparatedByString:@","];
        self.leftImageID = raImageIdsArr[0];
        self.rightImageID = raImageIdsArr[1];
        self.leftImageID1 = raImageIdsArr[2];
        
        self.confirmInfoModel.siCardNo = self.msgAuthenModel.siCardNo;
        self.confirmInfoModel.acNo = self.msgAuthenModel.acNo;
        self.confirmInfoModel.computerNo = self.msgAuthenModel.computerNo;
    }
    
    if(self.confirmInfoModel_0){
        self.confirmInfoModel = self.confirmInfoModel_0;
        NSArray *raImageIdsArr = [self.confirmInfoModel_0.images componentsSeparatedByString:@","];
        self.leftImageID = raImageIdsArr[0];
        self.rightImageID = raImageIdsArr[1];
        self.leftImageID1 = raImageIdsArr[2];
    }
    
    
    [self setUpTable];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight - 10) style:UITableViewStyleGrouped backgroundColor:LXVCBackgroundColor];
    self.tableView.sectionHeaderHeight = 10;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    NSMutableArray *section0 = [NSMutableArray array];
    [section0 addObject:@"社保卡号"];
    [section0 addObject:@"上传照片"];
    
    NSMutableArray *section1 = [NSMutableArray array];
    [section1 addObject:@"鉴定证书号"];
    [section1 addObject:@"电脑号"];
    [section1 addObject:@"上传照片"];
    
    NSMutableArray *section2 = [NSMutableArray array];
    [section2 addObject:@"确认上传"];
    [section2 addObject:@"参保人认证，需要上传身份证，进行等级认证"];
    [section2 addObject:@"认证时间为2-3个工作日"];
    
    [self.dataSource addObject:section0];
    [self.dataSource addObject:section1];
    [self.dataSource addObject:section2];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cutomArray = [self.dataSource[indexPath.section] copy];
    NSString *leadingString = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:120 color:LXCellBorderColor cell:cell];
            
            LXWeakSelf(self);
            
            self.leftUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           // [self.leftUploadBtn setBackgroundImage:[UIImage imageNamed:@"Order_add_image"] forState:UIControlStateNormal];
            NSString *requestString = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.leftImageID];
            [self.leftUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            
            [self.leftUploadBtn addTarget:self action:@selector(leftUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
            self.leftUploadBtn.userInteractionEnabled = _enableEdit;
            
            
            _lable1 =[[UILabel alloc]init];
            _lable1.text = @"社会保障卡正面照";
            _lable1.textAlignment = NSTextAlignmentCenter;
            _lable1.font = [UIFont systemFontOfSize:14.f];
            _lable1.textColor =  [UIColor lightGrayColor];
            [self.leftUploadBtn addSubview:_lable1];
            [_lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftUploadBtn).mas_offset(0);
                make.bottom.mas_equalTo(self.leftUploadBtn).mas_offset(-10);
                make.width.mas_equalTo(self.leftUploadBtn);
            }];

           
            [cell.contentView addSubview:self.leftUploadBtn];
            [self.leftUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(30);
                make.top.mas_equalTo(cell.contentView).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                
            }];
            
            
            self.rightUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //[self.rightUploadBtn setBackgroundImage:[UIImage imageNamed:@"Order_add_image"] forState:UIControlStateNormal];
            NSString *requestString2 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.rightImageID];
            [self.rightUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            
            [self.rightUploadBtn addTarget:self action:@selector(rightUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.rightUploadBtn];
            [self.rightUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(weakself.leftUploadBtn.mas_trailing).mas_offset(20);
                make.top.mas_equalTo(cell.contentView).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                make.trailing.mas_equalTo(cell.contentView).mas_equalTo(-20);
                make.width.mas_equalTo(weakself.leftUploadBtn);
            }];
           self.rightUploadBtn .userInteractionEnabled = _enableEdit;
            
            _lable3 =[UILabel new];
            _lable3.text = @"社会保障卡背面照";
            _lable3.textAlignment = NSTextAlignmentCenter;
            _lable3.font = [UIFont systemFontOfSize:14.f];
            _lable3.textColor =  [UIColor lightGrayColor];
            [self.rightUploadBtn addSubview:_lable3];
            [_lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.rightUploadBtn).mas_offset(0);
                make.bottom.mas_equalTo(self.rightUploadBtn).mas_offset(-10);
                make.width.mas_equalTo(self.rightUploadBtn);
            }];
            
            
            return cell;
        }
        else  {
            LXConfirmInfoVCTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmInfoVCTableViewCell" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.leadingL.text = leadingString;
            cell.inputTF.delegate = self;
            
            if (indexPath.row == 0) {
                self.identifyTF = cell.inputTF;
                cell.inputTF.returnKeyType  = UIReturnKeyDefault;
                if (!self.confirmInfoModel.siCardNo) {
                    self.identifyTF.placeholder = @"请输入社保卡号";
                }else{
                    cell.inputTF.text = self.confirmInfoModel.siCardNo;
                }
                self.identifyTF.enabled = _enableEdit;
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:120 color:LXCellBorderColor cell:cell];
            
            LXWeakSelf(self);
            
            self.leftUploadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            //[self.leftUploadBtn1 setBackgroundImage:[UIImage imageNamed:@"Order_add_image"] forState:UIControlStateNormal];
            
            NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.leftImageID1];
            [self.leftUploadBtn1 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            [self.leftUploadBtn1 addTarget:self action:@selector(leftUploadBtn1Click) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.leftUploadBtn1];
            [self.leftUploadBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(30);
                make.top.mas_equalTo(cell.contentView).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                make.width.mas_offset(135);
               // make.width.mas_equalTo(weakself.leftUploadBtn);
            }];
            self.leftUploadBtn1.userInteractionEnabled = _enableEdit;
           
            self.lable2 =[[UILabel alloc]init];
            _lable2.text = @"鉴定证书照";
            _lable2.textAlignment = NSTextAlignmentCenter;
            _lable2.font = [UIFont systemFontOfSize:14.f];
            _lable2.textColor =  [UIColor lightGrayColor];
            [self.leftUploadBtn1 addSubview:_lable2];
            [_lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.leftUploadBtn1).mas_offset(0);
                make.bottom.mas_equalTo(self.leftUploadBtn1).mas_offset(-10);
                make.width.mas_equalTo(self.leftUploadBtn1);
            }];
        
//            self.rightUploadBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self.rightUploadBtn1 setBackgroundImage:[UIImage imageNamed:@"Order_add_image"] forState:UIControlStateNormal];
//            [self.rightUploadBtn1 addTarget:self action:@selector(rightUploadBtn1Click) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:self.rightUploadBtn1];
//            [self.rightUploadBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.leading.mas_equalTo(weakself.leftUploadBtn1.mas_trailing).mas_offset(20);
//                make.top.mas_equalTo(cell.contentView).mas_equalTo(10);
//                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
//                make.trailing.mas_equalTo(cell.contentView).mas_equalTo(-20);
//                make.width.mas_equalTo(weakself.leftUploadBtn1);
//            }];
//            [self.rightUploadBtn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [self.rightUploadBtn1 setTitle:@"身份证反面照" forState:UIControlStateNormal];
//            self.rightUploadBtn1.titleLabel.font = [UIFont systemFontOfSize:14.f];
//            [self.rightUploadBtn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -55, 0)];
            return cell;
        }
        else  {
            LXConfirmInfoVCTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmInfoVCTableViewCell" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.leadingL.text = leadingString;
            cell.inputTF.delegate = self;
            cell.inputTF.returnKeyType =UIReturnKeyDefault;
            if (indexPath.row == 0) {
                self.appraisalTF = cell.inputTF;
                
                if (!self.confirmInfoModel.acNo) {
                    self.appraisalTF.placeholder = @"请输入鉴定证书号";
                }else{
                    cell.inputTF.text =self.confirmInfoModel.acNo;
                }
                self.appraisalTF.enabled = _enableEdit;
            }
            else if (indexPath.row == 1) {
                self.computerTF = cell.inputTF;
                
                if (!self.confirmInfoModel.computerNo) {
                    self.computerTF.placeholder = @"请输入电脑号";
                }else{
                    cell.inputTF.text = self.confirmInfoModel.computerNo;
                }
                self.computerTF.enabled = _enableEdit;
            }
            
            
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton2row0"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:45 color:LXCellBorderColor cell:cell];
            
            UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
            [confirmBtn setBackgroundColor:LXMainColor];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:confirmBtn];
            [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView).mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            confirmBtn.userInteractionEnabled = _enableEdit;
            return cell;
        }
        else {
            LXAddCareVCTableViewCell2 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXAddCareVCTableViewCell2" owner:self options:nil].firstObject;
            
            [cell.contentView setBackgroundColor:LXVCBackgroundColor];
            
            cell.leadingLa.text = leadingString;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return 120;
        }
        else {
            return 50;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            return 120;
        }
        else {
            return 50;
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 45;
        }
        else {
            return 30;
        }
    }
    
    return 0;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
   if ([self.identifyTF isEqual:textField]) {
        self.confirmInfoModel.siCardNo = textField.text;
    }
    else if ([self.appraisalTF isEqual:textField]) {
        self.confirmInfoModel.acNo = textField.text;
    }
    else if ([self.computerTF isEqual:textField]) {
        self.confirmInfoModel.computerNo = textField.text;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
        //NSString *bankCode= [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
        
       // if (bankCode.length>19) {
        //    return NO;
       // }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL  isOrNO= [string isEqualToString:filtered];
        return isOrNO;
}
#pragma mark - Action

- (void)rightUploadBtnClick {
    self.type = 2;
    [self presentAlterViewController];
}

- (void)leftUploadBtnClick {
    self.type = 1;
    [self presentAlterViewController];
}

//- (void)rightUploadBtn1Click {
//    self.type = 4;
//    [self presentAlterViewController];
//}

- (void)leftUploadBtn1Click {
    self.type = 3;
    [self presentAlterViewController];
}

- (void)confirmBtnClick {
    if (self.confirmInfoModel.acNo.length<=0&& self.confirmInfoModel.siCardNo.length<=0&& self.confirmInfoModel.computerNo.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"条件不够，请继续添加"];
        
        [SVProgressHUD dismissWithDelay:1];
        
        return;
    }
    
    if (self.leftImageID.length<=0 && self.leftImageID1.length<=0 && self.rightImageID.length<=0) {
        [SVProgressHUD showInfoWithStatus:@"照片不完善，请继续添加"];
        
        [SVProgressHUD dismissWithDelay:1];
        
        return;
    }
    
    
    self.confirmInfoModel.images = [NSString stringWithFormat:@"%@,%@,%@", self.leftImageID, self.rightImageID, self.leftImageID1];
    self.confirmInfoModel.imageTypes = [NSString stringWithFormat:@"1,1,2"];
    
    if(self.infoBlock){
        self.infoBlock(self.confirmInfoModel);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Photo

- (void)presentAlterViewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles = @[@"拍照", @"相册"];
    
    [self addActionTarget:alertController titles:titles];
    [self addCancelActionTarget:alertController title:@"取消"];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles {
    // @[@"在职", @"退休", @"居民"]; @[@"居家", @"入住机构"];
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([title isEqualToString:@"拍照"]) {
                [self gotoPerformTakePictrue];
            }
            else if ([title isEqualToString:@"相册"]) {
                [self gotoGetFromLibrary];
            }
        }];
        
        [alertController addAction:action];
    }
}

- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:action];
}

#pragma mark - Go to

- (void)gotoPerformTakePictrue {
    // Device authorization
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        NSString *alterTitle = @"无法使用相机";
        NSString *alterMessage = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alterTitle message:alterMessage preferredStyle:UIAlertControllerStyleAlert];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else {
        // Library authorization
        ALAuthorizationStatus authStatusXC = [ALAssetsLibrary authorizationStatus];
        
        // Refuse
        if(authStatusXC==ALAuthorizationStatusRestricted || authStatusXC == ALAuthorizationStatusDenied) {
            NSString *alterTitle = @"无法使用相机";
            NSString *alterMessage = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alterTitle message:alterMessage preferredStyle:UIAlertControllerStyleAlert];
            [self addCancelActionTarget:alertController title:@"取消"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        else {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.delegate=self;
            self.imagePickerController.allowsEditing  =YES;
            
            if(self.presentedViewController){
                [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            [self presentViewController:self.imagePickerController animated:YES completion:^{
                self.imagePickerController.delegate=self;
            }];
        }
    }
}

- (void)gotoGetFromLibrary {
    // Library authorization
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    
    // Refuse
    if (authStatus==ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied) {
        NSString *alterTitle = @"无法使用相机";
        NSString *alterMessage = @"请在iPhone的“设置-隐私-相机”中允许访问相机";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alterTitle message:alterMessage preferredStyle:UIAlertControllerStyleAlert];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            self.imagePickerController.allowsEditing  =YES;
            self.imagePickerController.delegate=self;
            
            if(self.presentedViewController){
                [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            self.imagePickerController.navigationController.navigationBar.tintColor =[UIColor whiteColor];
            self.imagePickerController.navigationController.navigationBar.barTintColor = LXMainColor;
            
            // 改变取消按钮颜色
            NSDictionary *dict = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
            
            UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
            // 设置返回按钮的背景图片
            [buttonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
            
            [self presentViewController:self.imagePickerController animated:YES completion:^{
                self.imagePickerController.delegate=self;
                self.imagePickerController.navigationController.delegate=self;
                self.imagePickerController.navigationController.navigationBar.tintColor =[UIColor whiteColor];
                self.imagePickerController.navigationController.navigationBar.barTintColor = LXMainColor;
            }];
        });
    }
}

#pragma mark - UINavigationControllerDelegate

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.imagePickerController.delegate=self;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.imagePickerController.delegate=self;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        // 改变取消按钮颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
        // 设置返回按钮的背景图片
        [buttonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    }];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        LXLog(@"************照相进入*************");
        
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        [self saveImage:image WithName:[NSString stringWithFormat:@"%d", arc4random() % 1000]];
    }
    else {
        LXLog(@"************相册进入*************");
        
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        
        [self saveImage:image WithName:[NSString stringWithFormat:@"%d", arc4random() % 1000]];
    }
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    if ([self imageDocument]) {
        [LXSandBox createDirectoryAtPath:[self imageDocument]];
    }
    
    NSString *totalPath = [[self imageDocument] stringByAppendingPathComponent:imageName];
    
    @synchronized (self) {
        NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
        [imageData writeToFile:totalPath atomically:YES];
    }
    
    
    [self uploadImageWithURL:[[NSURL alloc] initFileURLWithPath:totalPath] iamge:tempImage];
}

- (NSString *)imageDocument {
    return [[LXSandBox getHomeDocumentsPath] stringByAppendingPathComponent:@"ImageDocument"];
}


- (void)uploadImageWithURL:(NSURL *)imageURL iamge:(UIImage *)image {
    // 准备
    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"上传中……"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requsetSerialzer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = requsetSerialzer;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://112.74.38.196:8081/ihealthcare/common/uploadimage.htm" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *err = nil;
        
        [formData appendPartWithFileURL:imageURL name:@"image" error:&err];
        
        LXLog(@"%@", formData);
        LXLog(@"%@", err);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LXStrongSelf(self);
        [SVProgressHUD dismiss];
        
        @synchronized (weakself) {
            [LXSandBox deleteFielWithFileURL:imageURL];
        }
        id dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        int code = [dic[@"code"] intValue];
        if(code==0){
            if (self.type == 1) {
                self.leftImage = image;
                self.leftImageID = dic[@"file_id"];
                NSString *requestString = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.leftImageID];
                [self.leftUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 2) {
                self.rightImage = image;
                self.rightImageID = dic[@"file_id"];
                NSString *requestString2 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.rightImageID];
                [self.rightUploadBtn sd_setImageWithURL:[NSURL URLWithString:requestString2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
            else if (self.type == 3) {
                self.leftImage1 = image;
                self.leftImageID1 = dic[@"file_id"];
                NSString *requestString3 = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.leftImageID1];
                [self.leftUploadBtn1 sd_setImageWithURL:[NSURL URLWithString:requestString3] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Order_add_image"]];
            }
//            else if (self.type == 4) {
//                self.rightImage1 = image;
//                self.rightImageID1 = dic[@"file_id"];
//                [self.rightUploadBtn1 setBackgroundImage:image forState:UIControlStateNormal];
//            }
 
        }else{
            [SVProgressHUD showErrorWithStatus:@"哎呀,出错了!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        LXLog(@"上传照片出错%@", error);
    }];
}

#pragma mark - Getter

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
            _imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
        }
        
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            _imagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            _imagePickerController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:_imagePickerController.sourceType];
        }
        
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        // Orientation
        if (self.interfaceOrientation==UIDeviceOrientationLandscapeRight) {
            _imagePickerController.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*1/2);
        }
        else if (self.interfaceOrientation==UIDeviceOrientationLandscapeLeft){
            _imagePickerController.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*3/2);
        }
#pragma clang diagnostic pop
    }
    
    return _imagePickerController;
}

@end
