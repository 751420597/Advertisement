//
//  LXLogInViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/13.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXLogInViewController.h"

#import "LXJudge.h"

#import "LXLogInViewModel.h"
#import "LXVerifyModel.h"
#import "LXCheckModel.h"

#import "LXRootTabbarViewController.h"

#import "DHGuidePageHUD.h"


@interface LXLogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyB;
@property (weak, nonatomic) IBOutlet UIButton *logInB;

- (IBAction)getVerifyClick:(id)sender;
- (IBAction)logInClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *userProtocol;
- (IBAction)userProtocolTap:(id)sender;

@property (nonatomic, strong) LXLogInViewModel *viewModel;
@property (nonatomic, strong) LXVerifyModel *verifyModel;
@property (nonatomic, strong) LXCheckModel *checkModel;

@property (nonatomic, assign) NSUInteger seconds;
@property (nonatomic, strong) YYTimer *timer;

@property (nonatomic, assign) BOOL isValid;

@end


@implementation LXLogInViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置APP引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BoolLoadIntroducePage]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BoolLoadIntroducePage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 静态引导页
        [self setStaticGuidePage];
    }
    
    self.navigationItem.title = @"登录";
    [self.view setBackgroundColor:LXVCBackgroundColor];
    
    [self configureView];
    
    self.viewModel = [LXLogInViewModel new];
    self.seconds = 60;
    self.isValid = NO;
    
//    [self.getVerifyB setTitleColor:LXColorHex(0xb2b2b2) forState:UIControlStateDisabled];
//    [self.getVerifyB setTitleColor:LXColorHex(0xb2b2b2) forState:UIControlStateHighlighted];
//    [self.getVerifyB setTitleColor:LXColorHex(0xb2b2b2) forState:UIControlStateSelected];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidReceiveTouchEventNotification
                                               object:nil];
}


#pragma mark - Introduce

- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"Introduce1", @"Introduce2", @"Introduce3"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight) imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    [self.navigationController.view addSubview:guidePage];
}


#pragma mark - NSNotification

- (void)handleNotification:(NSNotification *)notification {
    if([notification.name isEqualToString:SVProgressHUDDidReceiveTouchEventNotification]){
        [SVProgressHUD dismiss];
    }
}


#pragma mark - Configure

- (void)configureView {
    [self.topBGView lx_setViewCornerRadius:3 borderColor:LXCellBorderColor borderWidth:1];
    [self.getVerifyB lx_setViewCornerRadius:3 borderColor:LXMainColor borderWidth:1];
    [self.logInB lx_setViewCornerRadius:3 borderColor:nil borderWidth:0];
    
    self.phoneTF.delegate = self;
    self.verifyCodeTF.delegate = self;
    
    NSDictionary *leadingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : LXColorHex(0xb2b2b2)};
    NSMutableAttributedString *leadingString = [[NSMutableAttributedString alloc] initWithString:@"点击登录，即表示您同意" attributes:leadingAttributes];
    
    NSDictionary *trailingAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : LXMainColor};
    NSMutableAttributedString *trailingString = [[NSMutableAttributedString alloc] initWithString:@"<i护理用户协议>" attributes:trailingAttributes];
    
    [leadingString appendAttributedString:trailingString];
    [self.userProtocol setAttributedText:leadingString];
    
}


#pragma mark - Action

- (IBAction)getVerifyClick:(id)sender {
    if (![self judgeVerify]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
        
        return;
    }
    
    NSDictionary *dict = @{@"phone_no":self.phoneTF.text};
    [SVProgressHUD showWithStatus:@"加载中……"];
    LXWeakSelf(self);
    
    [self.viewModel getVerifyCodeWithParameters:dict completionHandler:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
        LXStrongSelf(self);
        
        self.timer = [[YYTimer alloc] initWithFireTime:1 interval:1 target:self selector:@selector(countDown) repeats:YES];
        [self.timer fire];
        int code = [result[@"code"] intValue];
        if (code==0) {
            [SVProgressHUD showWithStatus:@"验证码已发送，请查收。"];
            self.verifyModel = [LXVerifyModel modelWithJSON:result];
            
            [self.timer fire];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"哎呀，出错了！"];
        }
    }];
}

- (IBAction)logInClick:(id)sender {
    if (![self judgeLogIn]) {
        [SVProgressHUD showErrorWithStatus:@"手机号或验证码不正确"];
        
        [SVProgressHUD dismissWithDelay:0.5];
        
        return;
    }

    NSBlockOperation *checkOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self checkVerifyCode];
    }];

    NSBlockOperation *logInOperation = [NSBlockOperation blockOperationWithBlock:^{
         [self startLogIn];
    }];

    [logInOperation addDependency:checkOperation];
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperations:@[logInOperation, checkOperation] waitUntilFinished:NO];
}

- (IBAction)userProtocolTap:(id)sender {
    
}

- (void)checkVerifyCode {
    LXWeakSelf(self);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSDictionary *dict = @{@"phone_no":self.phoneTF.text,
                          @"verify_no":self.verifyCodeTF.text};
    
    [self.viewModel verifyCodeWithParameters:dict completionHandler:^(NSError *error, id result) {
        LXStrongSelf(self);
        
        
        self.isValid = YES;
//        int code = [result[@"code"] intValue];
//        if (code== 0) {
//            self.checkModel = [LXCheckModel modelWithJSON:result];
//            if ([self.checkModel.code isEqualToString:@"0"]) {
//                self.isValid = YES;
//            }
//            else {
//                self.isValid = NO;
//            }
//        }
//        else {
//            self.isValid = NO;
//        }
//        
        dispatch_semaphore_signal(sema);
   }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)startLogIn {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    if (!self.isValid) {
        [SVProgressHUD showErrorWithStatus:@"验证码和手机号不匹配"];
        
        return;
    }
    
    [SVProgressHUD showErrorWithStatus:@"加载中……"];
    NSDictionary *dict = @{@"phone_no":self.phoneTF.text};
    
    //LXWeakSelf(self);
   
    [self.viewModel logInWithWithParameters:dict completionHandler:^(NSError *error, id result) {
        [SVProgressHUD dismiss];
        
        //LXStrongSelf(self);
        
        if (!error) {
            int code = [result[@"code"] intValue];
            if (code == 0) {
                [LXStandardUserDefaults setObject:self.phoneTF.text forKey:UserUserDefaults];
                [LXStandardUserDefaults setObject:result[@"userId"] forKey:@"userId"];
                [LXStandardUserDefaults synchronize];
                
                LXRootTabbarViewController *tabbarVC = [LXRootTabbarViewController new];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabbarVC;
            }
        }
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

- (void)countDown {
    self.seconds--;
    
    if (self.seconds == 0) {
        [self.timer invalidate];
        self.seconds = 60;
        
        self.getVerifyB.userInteractionEnabled = YES;
        [self.getVerifyB lx_setViewCornerRadius:3 borderColor:LXMainColor borderWidth:1];
        
        [self.getVerifyB setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getVerifyB setTitleColor:LXMainColor forState:UIControlStateNormal];
    }
    else {
        self.getVerifyB.userInteractionEnabled = NO;
        [self.getVerifyB lx_setViewCornerRadius:3 borderColor:LXColorHex(0xb2b2b2) borderWidth:1];
        
        NSString *resendString = [NSString stringWithFormat:@"重发(%lu)",(unsigned long)self.seconds];
        [self.getVerifyB setTitle:resendString forState:UIControlStateNormal];
        [self.getVerifyB setTitleColor:LXColorHex(0xb2b2b2) forState:UIControlStateNormal];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.phoneTF canBecomeFirstResponder]) {
        [self.phoneTF resignFirstResponder];
    }
    
    if ([self.verifyCodeTF canBecomeFirstResponder]) {
        [self.verifyCodeTF resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - UIResonder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.phoneTF canBecomeFirstResponder]) {
        [self.phoneTF resignFirstResponder];
    }
    
    if ([self.verifyCodeTF canBecomeFirstResponder]) {
        [self.verifyCodeTF resignFirstResponder];
    }
}


#pragma mark - Private

- (BOOL)judgeLogIn {
    if ([LXJudge isBlankOfString:self.phoneTF.text]) {
        return NO;
    }
    
    if (![LXJudge isPhoneNumberFormatOfString:self.phoneTF.text]) {
        return NO;
    }
    
    if (![LXJudge isVerifyCode:self.verifyCodeTF.text]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)judgeVerify {
    if ([LXJudge isBlankOfString:self.phoneTF.text]) {
        return NO;
    }
    
    if (![LXJudge isPhoneNumberFormatOfString:self.phoneTF.text]) {
        return NO;
    }
    
    return YES;
}


#pragma mark - Getter

//- (YYTimer *)timer {
//    if (!_timer) {
//        _timer = [[YYTimer alloc] initWithFireTime:1 interval:1 target:self selector:@selector(countDown) repeats:YES];
//    }
//    return _timer;
//}

// 多次请求，后者依赖前者

// 方法1
// NSBlockOperation *checkOperation = [NSBlockOperation blockOperationWithBlock:^{
//    [self checkVerifyCode];
// }];
//
// NSBlockOperation *logInOperation = [NSBlockOperation blockOperationWithBlock:^{
//     [self startLogIn];
// }];
//
// [logInOperation addDependency:checkOperation];
// NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
// [operationQueue addOperations:@[logInOperation, checkOperation] waitUntilFinished:NO];
//
// 请求里边
// dispatch_semaphore_t sema = dispatch_semaphore_create(0);
// [网络请求:{
//    成功：dispatch_semaphore_signal(sema);
//    失败：dispatch_semaphore_signal(sema);
// }]
// dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);



// 某界面存在多个请求，希望所有请求均结束才进行某操作
// 方法1
// dispatch_group_t group =dispatch_group_create();
// dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
//
// dispatch_group_enter(group);
// dispatch_group_async(group, globalQueue, ^{
//    dispatch_group_leave(group);
// });
//
// dispatch_group_enter(group);
// dispatch_group_async(group, globalQueue, ^{
//    dispatch_group_leave(group);
// });
//
// dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
//    
// });

// 方法2
//dispatch_group_t group = dispatch_group_create();
//dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    //请求1
//    NSLog(@"Request_1");
//});
//dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    //请求2
//    NSLog(@"Request_2");
//});
//dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    //请求3
//    NSLog(@"Request_3");
//});
//dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//    //界面刷新
//    NSLog(@"任务均完成，刷新界面");
//});
//dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//[网络请求:{
//    成功：dispatch_semaphore_signal(sema);
//    失败：dispatch_semaphore_signal(sema);
//}];
//dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);



@end
