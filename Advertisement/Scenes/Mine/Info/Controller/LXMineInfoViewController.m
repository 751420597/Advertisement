//
//  LXMineInfoViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/12.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXMineInfoViewController.h"

#import "LXMineInfoVCTableViewCell.h"

#import "LXMineInfoViewModel.h"
#import "IQKeyboardManager.h"
// Pictrue
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

static CGFloat const BGViewHeight = 246.f;
static NSString *const LXMineInfoVCTableViewCellID = @"LXMineInfoVCTableViewCellID";

@interface LXMineInfoViewController () <UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy  ) NSString *birthday;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSMutableArray *trailingDataSource;

@property (nonatomic, strong) LXMineInfoViewModel *viewModel;

@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic) BOOL canSelect;
@end


@implementation LXMineInfoViewController

- (instancetype)init {
    if (self = [super init]) {
        self.mineModel = [LXMineModel new];
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager=[IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    IQKeyboardManager *manager=[IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    self.navigationItem.title = @"个人信息";
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmBtn];
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    
    self.viewModel = [LXMineInfoViewModel new];
    
    self.birthday = @"1990-1-1";
    self.canSelect = NO;
    [self setUpTable];
}


#pragma mark - Set Up

- (void)setUpTable {
    [self setUpTableViewWithFrame:CGRectMake(10, 10, LXScreenWidth - 10 * 2, LXScreenHeight - LXNavigaitonBarHeight) style:UITableViewStylePlain backgroundColor:LXVCBackgroundColor];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.dataSource addObject:@"头像"];
    [self.dataSource addObject:@"姓名"];
    [self.dataSource addObject:@"性别"];
    [self.dataSource addObject:@"生日"];
    [self.dataSource addObject:@"手机号码"];
    
    self.trailingDataSource = [NSMutableArray new];
     NSString *requestString = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, self.mineModel.avatarImageId];
    [self.trailingDataSource addObject:requestString];
    //[self.trailingDataSource addObject:self.mineModel.avatarImageId.length>0 ? self.mineModel.avatarImageId : @"Mine_tableview_person"];
    [self.trailingDataSource addObject:self.mineModel.userName.length>0 ? self.mineModel.userName : @"没有名字"];
    [self.trailingDataSource addObject:self.mineModel.sexName.length>0?self.mineModel.sexName:@"未填写"];
    [self.trailingDataSource addObject:self.mineModel.birthday.length>0?self.mineModel.birthday:self.birthday];
    [self.trailingDataSource addObject:self.mineModel.mobile.length>0?self.mineModel.mobile:@"未填写"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXMineInfoVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LXMineInfoVCTableViewCellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LXMineInfoVCTableViewCell" owner:self options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth - 20, 1)];
        [topLine setBackgroundColor:LXCellBorderColor];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:topLine];
        }
        
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 50)];
        [leftLine setBackgroundColor:LXCellBorderColor];
        [cell.contentView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(LXScreenWidth - 1 - 20, 0, 1, 50)];
        [rightLine setBackgroundColor:LXCellBorderColor];
        [cell.contentView addSubview:rightLine];
        
        NSInteger myBottomLineWidth;
        NSInteger myBottomLineOriginX;
        if (indexPath.row == [self.dataSource count] - 1) {
            myBottomLineOriginX = 0;
            myBottomLineWidth = LXScreenWidth - 10 * 2 - myBottomLineOriginX;
            
        }
        else {
            myBottomLineOriginX = 10;
            myBottomLineWidth = LXScreenWidth - 10 * 2 - myBottomLineOriginX;
        }
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(myBottomLineOriginX, 50 - 1, myBottomLineWidth, 1)];
        [bottomLine setBackgroundColor:LXCellBorderColor];
        [cell.contentView addSubview:bottomLine];
    }
    
    NSString *tempString = self.dataSource[indexPath.row];
    if ([tempString isEqualToString:@"头像"]) {
        [cell.trailingL removeFromSuperview];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LXScreenWidth - 20 - 50, 0, 25, 25)];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.trailingDataSource[indexPath.row]] placeholderImage:[UIImage imageNamed:@"Mine_male"]];
        [self.avatarImageView setCenterY:50 / 2];
        [cell.contentView addSubview:self.avatarImageView];
    }
    else if ([tempString isEqualToString:@"姓名"] || [tempString isEqualToString:@"手机号码"]) {
        cell.btnConstrait.constant = 0;
        if(_canSelect){
            cell.trailingL.enabled = YES;
        }else{
            cell.trailingL.enabled = NO;
        }
        
    }else{
        cell.trailingL.enabled = NO;
    }
    
    cell.leadingL.text = self.dataSource[indexPath.row];
    cell.trailingL.text = self.trailingDataSource[indexPath.row];
    cell.trailingL.delegate = self;
    cell.trailingL.returnKeyType = UIReturnKeyDefault;
    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.canSelect){
        NSString *tempString = self.dataSource[indexPath.row];
        _index = indexPath;
        if ([tempString isEqualToString:@"头像"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            NSArray *titles = @[@"拍照", @"相册"];
            
            [self addActionTarget:alertController titles:titles];
            [self addCancelActionTarget:alertController title:@"取消"];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if ([tempString isEqualToString:@"性别"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            NSArray *titles = @[@"男", @"女"];
            
            [self addActionTarget:alertController titles:titles];
            [self addCancelActionTarget:alertController title:@"取消"];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if ([tempString isEqualToString:@"生日"]) {
            [self.view addSubview:self.bgView];
        }

    }
}


#pragma mak - Aciton

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles {
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([title isEqualToString:@"拍照"]) {
                [self gotoPerformTakePictrue];
            }
            else if ([title isEqualToString:@"相册"]) {
                [self gotoGetFromLibrary];
            }
            else if ([title isEqualToString:@"男"]) {
                [self gotoSelectMale];
            }
            else if ([title isEqualToString:@"女"]) {
                [self gotoSelectFemale];
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

- (void)gotoSelectMale {
    self.mineModel.sexName = @"男";
    LXMineInfoVCTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.trailingL.text =self.mineModel.sexName;
    self.mineModel.sexCode = @"1";
}

- (void)gotoSelectFemale {
    self.mineModel.sexName = @"女";
    self.mineModel.sexCode = @"2";
    LXMineInfoVCTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.trailingL.text =self.mineModel.sexName;
}


#pragma mark - Aciton

- (void)confirmButtonClick:(id)sender {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *birthdayTime = [formatter stringFromDate:self.datePicker.date];
    self.birthday = birthdayTime;
    
    self.mineModel.birthday = self.birthday;
    LXMineInfoVCTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.trailingL.text =self.birthday;

    [self.bgView removeFromSuperview];
}

- (void)cancelButtonClick:(id)sender {
    [self.bgView removeFromSuperview];
}

- (void)confirmBtnClick {
    if(_canSelect){
        // 上传到服务器
        LXWeakSelf(self);
        [SVProgressHUD showWithStatus:@"加载中……"];
        LXMineInfoVCTableViewCell *cell0 =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        self.mineModel.userName=cell0.trailingL.text;
        
        LXMineInfoVCTableViewCell *cell1 =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        self.mineModel.mobile=cell1.trailingL.text;
        
        NSMutableDictionary *dictP = [NSMutableDictionary dictionary];
        if (self.mineModel.tmUserId) {
            [dictP setValue:self.mineModel.tmUserId forKey:@"userId"];
        }
        
        if (self.mineModel.avatarImageId) {
            [dictP setValue:self.mineModel.avatarImageId forKey:@"fileId"];
        }
        
        if (self.mineModel.userName) {
            [dictP setValue:self.mineModel.userName forKey:@"userName"];
        }
        
        if (self.mineModel.sexCode) {
            [dictP setValue:self.mineModel.sexCode forKey: @"sexCode"];
        }
        
        if (self.mineModel.mobile) {
            [dictP setValue:self.mineModel.mobile forKey:@"mobile"];
        }
        
        if (self.mineModel.birthday) {
            [dictP setValue:self.mineModel.birthday forKey:@"birthday"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请选择您的生日"];
            return;
        }
        
        [self.viewModel updateMineInfoWithParameters:dictP completionHandler:^(NSError *error, id result) {
            LXStrongSelf(self);
            [SVProgressHUD dismiss];
            int code = [result[@"code"] intValue];
            if (code == 0) {
                if(self.okBlock){
                    self.okBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
            }
        }];

    }else{
        self.canSelect = YES;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.tableView reloadData];
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
        
        self.avatarImage = image;
        
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
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        
        // 获取图片的url
        NSURL * url1 = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSString *urlString = [url1 absoluteString];
        NSArray *array = [urlString componentsSeparatedByString:@"="];
        NSString *nameString = array[1];
        NSArray *array1 = [nameString componentsSeparatedByString:@"&"];
        NSString *name = array1[0];
        NSString *uploadName = [NSString stringWithFormat:@"%@", name];
        
        [self uploadImageWithData:data name:uploadName];
    }
    else {
        LXLog(@"************相册进入*************");
        
        NSError *error1;
        
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:url error:&error1];
        

        self.avatarImage = image;
        
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
        
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        // 获取图片的url
        NSURL * url1 = [info objectForKey:UIImagePickerControllerReferenceURL];
        NSString *urlString = [url1 absoluteString];
        NSArray *array = [urlString componentsSeparatedByString:@"="];
        NSString *nameString = array[1];
        NSArray *array1 = [nameString componentsSeparatedByString:@"&"];
        NSString *name = array1[0];
        NSString *uploadName = [NSString stringWithFormat:@"%@", name];
        
        [self uploadImageWithData:data name:uploadName];
        
    }
}

- (void)uploadImageWithData:(NSData*)data name:(NSString *)name{
    
    
//    LXWeakSelf(self);
    [SVProgressHUD showWithStatus:@"正在上传照片……"];
//    
//    NSDictionary *dictP = @{@"image_type":@"png"};
//    
//    [self.viewModel uploadImageWithParameters:nil imageData:data completionHandler:^(NSError *error, id result) {
//        LXStrongSelf(self);
//        [SVProgressHUD dismiss];
//        
//        if (error.code == 0) {
//            
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
//        }
//    }];
    
    // 准备
    __block __weak typeof(self) weakSelf = self;
    
    // 1.创建一个请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requsetSerialzer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = requsetSerialzer;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.开始上传
    [manager POST:@"http://112.74.38.196:8081/ihealthcare/common/uploadimage.htm" parameters:@{@"image_type":@"1"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *err = nil;
        
        [formData appendPartWithFileData:data name:@"image" fileName:name mimeType:@"image/jpeg"];
        
        LXLog(@"%@", formData);
        LXLog(@"%@", err);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 不做处理
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功回调
        id dict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"获取到的数据为：%@",dict);;
        int code = [dict[@"code"] intValue] ;
        [SVProgressHUD dismiss];
        if (code == 0) {
            weakSelf.mineModel.avatarImageId = dict[@"file_id"];
            NSString *requestString = [NSString stringWithFormat:@"%@.htm?id=%@", GetImage, weakSelf.mineModel.avatarImageId];
            
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:requestString] placeholderImage:[UIImage imageNamed:@"Mine_male"]];
            
        }else{
            
             [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LXLog(@"%@", error);
    }];
}

- (void)gotoUploadUserImageWithURLString:(NSString *)urlString {
//    __block __weak typeof(self) weakSelf = self;
//    [JYTMessageShowTool hiddenCustomHUD];
//    
//    [LXMineService settingUserLogoWithLogoURL:urlString successBlock:^(id object) {
//        if ([object[@"status"] isEqualToString:@"0"]) {
//            [JYTMessageShowTool showTextHUDWith:@"上传成功"];
//            
//            [weakSelf.avaraImageView setImage:weakSelf.avatarImage];
//        }
//    } failureBlock:^(NSError *error) {
//        [JYTMessageShowTool showTextHUDWith:@"上传失败"];
//    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        // 改变取消按钮颜色
        NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
        // 设置返回按钮的背景图片
        [buttonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
        
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

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setFrame:CGRectMake(LXScreenWidth - 10 - 60, LXScreenHeight - LXNavigaitonBarHeight - BGViewHeight, 60, 30)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setFrame:CGRectMake(10, LXScreenHeight - LXNavigaitonBarHeight - BGViewHeight, 60, 30)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - BGViewHeight + 30, LXScreenWidth, BGViewHeight - 30)];
        
        NSDate *minDate =[self convertDateFromString:@"1896-01-01"];
        NSDate *maxDate = [self convertDateFromString:@"2016-12-31"];
        NSDate *dafaultData = [self convertDateFromString:self.birthday];
        _datePicker.minimumDate = minDate;
        _datePicker.maximumDate = maxDate;
        _datePicker.date = dafaultData;
        
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
    }
    
    return _datePicker;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth,LXScreenHeight - LXNavigaitonBarHeight)];
        _bgView.backgroundColor = [UIColor lightGrayColor];
        _bgView.alpha = 0.7f;
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - BGViewHeight, LXScreenWidth, BGViewHeight )];
        view1.backgroundColor = LXColorHex(0xEDEDED);
        [_bgView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, LXScreenHeight - LXNavigaitonBarHeight - BGViewHeight + 29.5, LXScreenWidth, 0.5)];
        view2.backgroundColor = LXColorHex(0xD5D5D6);
        [_bgView addSubview:view2];
        
        [_bgView addSubview:self.confirmButton];
        [_bgView addSubview:self.cancelButton];
        [_bgView addSubview:self.datePicker];
    }
    
    return _bgView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_confirmBtn setFrame:CGRectMake(0, 0, 40, 30)];
        [_confirmBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


#pragma mark - Private method

- (NSDate *) convertDateFromString:(NSString *)uiDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    
    return date;
}



@end
