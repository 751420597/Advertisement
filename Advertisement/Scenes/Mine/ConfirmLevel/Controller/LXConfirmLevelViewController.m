//
//  LXConfirmLevelViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXConfirmLevelViewController.h"

#import "LXConfirmLevelVCTableViewCell1.h"
#import "LXConfirmLevelVCTableViewCell2.h"
#import "LXAddCareVCTableViewCell2.h"

#import "LXConfirmLevelModel.h"

// Pictrue
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

#import "LXSandBox.h"

@interface LXConfirmLevelViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *ageTF;
@property (nonatomic, strong) UITextField *identifyTF;
@property (nonatomic, strong) UITextField *socialTF;

@property (nonatomic, strong) UIButton *leftUploadBtn;
@property (nonatomic, strong) UIButton *rightUploadBtn;
@property (nonatomic, strong) UIButton *leftBottomUploadBtn;

@property (nonatomic, strong) LXConfirmLevelModel *confirmLevelModel;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIImage *bottomImage;

@property (nonatomic, copy) NSString *leftImageID;
@property (nonatomic, copy) NSString *rightImageID;
@property (nonatomic, copy) NSString *bottomeImageID;

@property (nonatomic, assign) NSInteger type; // 1:左边，2:右边，3，下边

@property (nonatomic, strong) UIButton *myConfirmBtn1;

@end



@implementation LXConfirmLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"等级认证";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myConfirmBtn1];
    barButtonItem.width = 10;
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    self.confirmLevelModel = [LXConfirmLevelModel new];
    
    [self setUpTable];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 20, LXScreenHeight - LXNavigaitonBarHeight - 10) style:UITableViewStyleGrouped backgroundColor:LXVCBackgroundColor];
    self.tableView.sectionFooterHeight = 0;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self updateData];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - Update

- (void)updateData {
    NSMutableArray *section00 = [NSMutableArray array];
    [section00 addObject:@"参保人姓名"];
    [section00 addObject:@"年龄"];
    [section00 addObject:@"身份证号码"];
    [section00 addObject:@"人员性质"];
    [section00 addObject:@"接受照护服务方式"];
    [section00 addObject:@"社会保障卡号"];
    [section00 addObject:@"诊断照片"];
    
    NSMutableArray *section11 = [NSMutableArray array];
    [section11 addObject:@"待遇等级认证，填入信息后机构初筛。通过提交医保局复审"];
    [section11 addObject:@"审核时间为7～15个工作日"];
    [section11 addObject:@"审核未通过前不可享受长护险政策"];
    
    [self.dataSource addObject:section00];
    [self.dataSource addObject:section11];
}

- (void)updateView {
    [self.tableView reloadData];
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
        if (indexPath.row == 5) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:150 color:LXCellBorderColor cell:cell];
            
            LXWeakSelf(self);
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(10);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
                make.height.mas_equalTo(30);
            }];
            
            self.socialTF = [[UITextField alloc] init];
            [self.socialTF setFont:[UIFont systemFontOfSize:16]];
            [self.socialTF setTextColor:LXColorHex(0x4c4c4c)];
            
            if (self.confirmLevelModel.siCardNo) {
                [self.socialTF setText:self.confirmLevelModel.siCardNo];
            }
            else {
                [self.socialTF setPlaceholder:@"请输入社保卡号"];
            }
            
            self.socialTF.delegate = self;
            [cell.contentView addSubview:self.socialTF];
            [self.socialTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cell.contentView).mas_offset(-10);
                make.centerY.mas_equalTo(label1);
            }];
            
            self.leftUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.leftUploadBtn setBackgroundImage:self.leftImage ? self.leftImage : [UIImage imageNamed:@"Order_add_image"] forState:UIControlStateNormal];
            [self.leftUploadBtn addTarget:self action:@selector(leftUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.leftUploadBtn];
            [self.leftUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(30);
                make.top.mas_equalTo(label1.mas_bottom).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
            }];
            
            self.rightUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.rightUploadBtn setBackgroundImage:self.rightImage ? self.rightImage : [UIImage imageNamed:@"Order_add_image"] forState:UIControlStateNormal];
            [self.rightUploadBtn addTarget:self action:@selector(rightUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.rightUploadBtn];
            [self.rightUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(weakself.leftUploadBtn.mas_trailing).mas_offset(20);
                make.top.mas_equalTo(label1.mas_bottom).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                make.trailing.mas_equalTo(cell.contentView).mas_equalTo(-20);
                make.width.mas_equalTo(weakself.leftUploadBtn);
            }];
            
            return cell;
        }
        else if (indexPath.row == 6) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seciton0row3"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:150 color:LXCellBorderColor cell:cell];
            
            LXWeakSelf(self);
            
            UILabel *label1 = [[UILabel alloc] init];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            [label1 setTextColor:LXColorHex(0x4c4c4c)];
            [label1 setText:leadingString];
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(10);
                make.top.mas_equalTo(cell.contentView).mas_offset(10);
                make.height.mas_equalTo(30);
            }];
            
            self.leftBottomUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.leftBottomUploadBtn setBackgroundImage:self.bottomImage ? self.bottomImage : [UIImage imageNamed:@"Order_add_image"] forState:UIControlStateNormal];
            [self.leftBottomUploadBtn addTarget:self action:@selector(leftBottomUploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.leftBottomUploadBtn];
            [self.leftBottomUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(cell.contentView).mas_offset(30);
                make.top.mas_equalTo(label1.mas_bottom).mas_equalTo(10);
                make.bottom.mas_equalTo(cell.contentView).mas_offset(-10);
                make.width.mas_equalTo(135);
            }];
            
            return cell;
        }
        else if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)  {
            LXConfirmLevelVCTableViewCell1 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmLevelVCTableViewCell1" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.leadingL.text = leadingString;
            if ([leadingString isEqualToString:@"参保人姓名"]) {
                self.nameTF = cell.trailingTF;
                self.nameTF.delegate = self;
                
                if (self.confirmLevelModel.name) {
                    [self.nameTF setText:self.confirmLevelModel.name];
                }
                else {
                    [self.nameTF setPlaceholder:@"请输入姓名"];
                }
            }
            else if ([leadingString isEqualToString:@"年龄"]) {
                self.ageTF = cell.trailingTF;
                self.ageTF.delegate = self;
                
                if (self.confirmLevelModel.age) {
                    [self.ageTF setText:self.confirmLevelModel.age];
                }
                else {
                    [self.ageTF setPlaceholder:@"请输入姓名"];
                }
            }
            else if ([leadingString isEqualToString:@"身份证号码"]) {
                self.identifyTF = cell.trailingTF;
                self.identifyTF.delegate = self;
                
                if (self.confirmLevelModel.cardNo) {
                    [self.identifyTF setText:self.confirmLevelModel.cardNo];
                }
                else {
                    [self.identifyTF setPlaceholder:@"请输入身份证号"];
                }
            }
            
            return cell;
        }
        else {
            LXConfirmLevelVCTableViewCell2 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXConfirmLevelVCTableViewCell2" owner:self options:nil].firstObject;
            
            [self addCustomeLineWithArray:cutomArray indexPath:indexPath width:LXScreenWidth - 20 height:50 color:LXCellBorderColor cell:cell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.leadingL.text = leadingString;
            
            if ([leadingString isEqualToString:@"人员性质"]) {
                if ([self.confirmLevelModel.personNatureId isEqualToString:@"1"]) {
                    cell.trailingL.text = @"在职";
                }
                else if ([self.confirmLevelModel.personNatureId isEqualToString:@"2"]) {
                    cell.trailingL.text = @"退休";
                }
                else if ([self.confirmLevelModel.personNatureId isEqualToString:@"3"]) {
                    cell.trailingL.text = @"居民";
                }
                else {
                    cell.trailingL.text = @"请选择";
                }
            }
            else if ([leadingString isEqualToString:@"接受照护服务方式"]) {
                if ([self.confirmLevelModel.careTypeId isEqualToString:@"1"]) {
                    cell.trailingL.text = @"居家";
                }
                else if ([self.confirmLevelModel.careTypeId isEqualToString:@"2"]) {
                    cell.trailingL.text = @"入住机构";
                }
                else {
                    cell.trailingL.text = @"请选择";
                }
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        LXAddCareVCTableViewCell2 *cell = [[NSBundle mainBundle] loadNibNamed:@"LXAddCareVCTableViewCell2" owner:self options:nil].firstObject;
        
        [cell.contentView setBackgroundColor:LXVCBackgroundColor];
        
        cell.leadingLa.text = leadingString;
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 30;
    }
    
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    if ([tempString isEqualToString:@"社会保障卡号"] || [tempString isEqualToString:@"诊断照片"]) {
        return 150;
    }
    else {
        return 50;
    }
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempString = self.dataSource[indexPath.section][indexPath.row];
    
    if ([tempString isEqualToString:@"人员性质"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"在职", @"退休", @"居民"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([tempString isEqualToString:@"接受照护服务方式"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[@"居家", @"入住机构"];
        
        [self addActionTarget:alertController titles:titles];
        [self addCancelActionTarget:alertController title:@"取消"];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.nameTF isEqual:textField]) {
        self.confirmLevelModel.name = textField.text;
    }
    else if ([self.ageTF isEqual:textField]) {
        self.confirmLevelModel.age = textField.text;
    }
    else if ([self.identifyTF isEqual:textField]) {
        self.confirmLevelModel.cardNo = textField.text;
    }
    else if ([self.socialTF isEqual:textField]) {
        self.confirmLevelModel.siCardNo = textField.text;
    }
}


#pragma mark - Action

- (void)myConfirmBtn1Click {
    if (!(self.confirmLevelModel.cardNo || self.confirmLevelModel.personNatureId || self.confirmLevelModel.careTypeId || self.confirmLevelModel.images || self.confirmLevelModel.imageTypes)) {
        [SVProgressHUD showErrorWithStatus:@"条件不够，请继续添加"];
        
        [SVProgressHUD dismissWithDelay:1];
        
        return;
    }
    
    if (!(self.leftImageID || self.rightImageID)) {
        [SVProgressHUD showErrorWithStatus:@"照片不够，请继续添加"];
        
        [SVProgressHUD dismissWithDelay:1];
        
        return;
    }
    
    
    self.confirmLevelModel.images = [NSString stringWithFormat:@"%@,%@", self.leftImageID, self.rightImageID];
    self.confirmLevelModel.imageTypes = [NSString stringWithFormat:@"1,1"];
    
    self.levelBlock(self.confirmLevelModel);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightUploadBtnClick {
    self.type = 2;
    
    [self presentAlterViewController];
}

- (void)leftUploadBtnClick {
    self.type = 1;
    
    [self presentAlterViewController];
}

- (void)leftBottomUploadBtnClick {
    self.type = 3;
    
    [self presentAlterViewController];
}

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
            else if ([title isEqualToString:@"在职"]) {
                [self gotoSelect1];
            }
            else if ([title isEqualToString:@"退休"]) {
                [self gotoSelect2];
            }
            else if ([title isEqualToString:@"居民"]) {
                [self gotoSelect3];
            }
            else if ([title isEqualToString:@"居家"]) {
                [self gotoSelect4];
            }
            else if ([title isEqualToString:@"入住机构"]) {
                [self gotoSelect5];
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


- (void)gotoSelect1 {
    self.confirmLevelModel.personNatureId = @"1";
    
    [self updateView];
}

- (void)gotoSelect2 {
    self.confirmLevelModel.personNatureId = @"2";
    
    [self updateView];
}

- (void)gotoSelect3 {
    self.confirmLevelModel.personNatureId = @"3";
    
    [self updateView];
}

- (void)gotoSelect4 {
    self.confirmLevelModel.careTypeId = @"1";
    
    [self updateView];
}

- (void)gotoSelect5 {
    self.confirmLevelModel.careTypeId = @"2";
    
    [self updateView];
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
        NSData *imageData = UIImageJPEGRepresentation(tempImage, 1.0);
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
    
    [manager POST:@"http://112.74.38.196:8081/healthcare/common/uploadimage.htm" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        
        if (self.type == 1) {
            self.leftImage = image;
            self.leftImageID = responseObject[@"file_id"];
            [self.leftUploadBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
        else if (self.type == 2) {
            self.rightImage = image;
            self.rightImageID = responseObject[@"file_id"];
            [self.rightUploadBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
        else if (self.type == 3) {
            self.bottomImage = image;
            self.bottomeImageID = responseObject[@"file_id"];
            [self.leftBottomUploadBtn setBackgroundImage:image forState:UIControlStateNormal];
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

- (UIButton *)myConfirmBtn1 {
    if (!_myConfirmBtn1) {
        _myConfirmBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myConfirmBtn1 setTitle:@"添加" forState:UIControlStateNormal];
        [_myConfirmBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myConfirmBtn1.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_myConfirmBtn1 setFrame:CGRectMake(0, 0, 40, 30)];
        [_myConfirmBtn1.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_myConfirmBtn1 addTarget:self action:@selector(myConfirmBtn1Click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myConfirmBtn1;
}


@end
