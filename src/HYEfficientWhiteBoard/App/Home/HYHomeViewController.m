//
//  HYHomeViewController.m
//  HYEfficientWhiteBoard
//
//  Created by apple on 2017/10/20.
//  Copyright © 2017年 HaydenYe. All rights reserved.
//

#import "HYHomeViewController.h"
#import "HYConversationManager.h"

#define kUploadPort    23333     // 上传端口
#define kServerPort    22222     // 会话端口

@interface HYHomeViewController () <UITextFieldDelegate>

@property (nonatomic, strong)UIButton    *serverBtn;     // 选择按钮
@property (nonatomic, strong)UILabel     *serverLb;      // 显示服务器ip地址

@property (nonatomic, strong)UIButton    *clientBtn;     // 选择按钮
@property (nonatomic, strong)UITextField *clientTf;      // 输入连接服务器的地址

@property (nonatomic, strong)UILabel     *loadingLb;     // loading...

@end

@implementation HYHomeViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络连接";
    [self _configOwnViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
// 输入ip地址完成
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.loadingLb.text = @"连接中...";
    
    // 连接服务器
    __weak typeof(self) ws = self;
    [[HYConversationManager shared] connectWhiteboardServer:textField.text port:kServerPort successed:^(HYSocketService *service) {
        // 上传图片
        
    } failed:^(NSError *error) {
        NSLog(@"****HY Error:%@", error.domain);
        ws.loadingLb.text = error.domain;
    }];
}


#pragma mark - Private methods
// 设置子视图
- (void)_configOwnViews {
    self.serverBtn.frame = CGRectMake(0, 250.f, [UIScreen mainScreen].bounds.size.width, 44.f);
    self.clientBtn.frame = CGRectMake(0, 300.f, [UIScreen mainScreen].bounds.size.width, 44.f);
    [self.view addSubview:_serverBtn];
    [self.view addSubview:_clientBtn];
}


// 选择按钮点击事件
- (void)_didClickButton:(UIButton *)sender {
    
    _serverBtn.hidden = YES;
    _clientBtn.hidden = YES;
    
    // 服务器
    if (sender.tag == 100) {
        self.serverLb.frame = CGRectMake(0, 250.f, [UIScreen mainScreen].bounds.size.width, 44.f);
        [self.view addSubview:_serverLb];
        
        // 开启服务器监听
        __weak typeof(self) ws = self;
        [[HYConversationManager shared] startServerWithPort:kServerPort completion:^(NSString *host) {
            ws.serverLb.text = [@"服务器ip: " stringByAppendingString:host];
        } clientConnectedSuccessed:^(HYSocketService *service) {
            ws.serverLb.text = @"连接成功";
        } failed:^(NSError *error) {
            NSLog(@"****HY Error:客户端连接失败");
            ws.serverLb.text = error.domain;
        }];
    }
    // 客户端
    else {
        self.clientTf.frame = CGRectMake(0, 250.f, [UIScreen mainScreen].bounds.size.width, 44.f);
        [self.view addSubview:_clientTf];
        [_clientTf becomeFirstResponder];
    }
}


#pragma mark - Property
// 选择按钮（服务器）
- (UIButton *)serverBtn {
    if (_serverBtn == nil) {
        _serverBtn = [UIButton new];
        [_serverBtn setTitle:@"将此设备设置为服务器" forState:UIControlStateNormal];
        [_serverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _serverBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _serverBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _serverBtn.layer.borderWidth = 1.f;
        _serverBtn.tag = 100;
        [_serverBtn addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _serverBtn;
}

// 显示服务器ip地址
- (UILabel *)serverLb {
    if (_serverLb == nil) {
        _serverLb = [UILabel new];
        _serverLb.textAlignment = NSTextAlignmentCenter;
        _serverLb.font = [UIFont systemFontOfSize:15.f];
    }
    
    return _serverLb;
}

// 选择按钮（客户端）
- (UIButton *)clientBtn {
    if (_clientBtn == nil) {
        _clientBtn = [UIButton new];
        [_clientBtn setTitle:@"将此设备设置为客户端" forState:UIControlStateNormal];
        [_clientBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clientBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _clientBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _clientBtn.layer.borderWidth = 1.f;
        _clientBtn.tag = 200;
        [_clientBtn addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _clientBtn;
}

// 输入连接服务器的地址
- (UITextField *)clientTf {
    if (_clientTf == nil) {
        _clientTf = [UITextField new];
        _clientTf.placeholder = @"输入服务器ip地址";
        _clientTf.delegate = self;
        _clientTf.textAlignment = NSTextAlignmentCenter;
        _clientTf.font = [UIFont systemFontOfSize:14.f];
        _clientTf.borderStyle = UITextBorderStyleLine;
        _clientTf.returnKeyType = UIReturnKeyDone;
    }
    
    return _clientTf;
}

// loading...
- (UILabel *)loadingLb {
    if (_loadingLb == nil) {
        _loadingLb = [UILabel new];
        _loadingLb.textAlignment = NSTextAlignmentCenter;
        _loadingLb.font = [UIFont systemFontOfSize:15.f];
        [self.view addSubview:_loadingLb];
        self.loadingLb.frame = CGRectMake(0, 300.f, [UIScreen mainScreen].bounds.size.width, 44.f);
    }
    
    return _loadingLb;
}

@end