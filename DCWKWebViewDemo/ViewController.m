//
//  ViewController.m
//  DCWKWebViewDemo
//
//  Created by chy on 17/1/22.
//  Copyright © 2017年 Chy. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

static NSString * const DCTestDirectoryName = @"/test_2";
static NSString * const DCIndexName         = @"index.html";

@interface ViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) UIBarButtonItem       * backButton;
@property (nonatomic, strong) UIView                * progressView;
@property (nonatomic, strong) WKWebView             * webView;
@property (nonatomic, strong) NSString              * testPath;
@property (nonatomic, strong) NSString              * testFilePath;

@end

@implementation ViewController

// MARK: - Getter Mthods
//--------------------------------------------------------------------

// app/resource/test
- (NSString *)testPath
{
    if (_testPath == nil) {
        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
        _testPath = [resourcePath stringByAppendingString:DCTestDirectoryName];
    }
    
    return _testPath;
}

// app/resource/test/XXXX.html
- (NSString *)testFilePath
{
    if (_testFilePath == nil) {
        _testFilePath = [self.testPath stringByAppendingPathComponent:DCIndexName];
    }
    
    return _testFilePath;
}

// MARK: - Life Cycle
//--------------------------------------------------------------------

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    [self setupNavigation];
    [self setupWebView];
    [self setupProgressView];
    DC_LOG(@"setupUI");
    
}

- (void)setupNavigation
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"后退" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[backItem];
    _backButton = backItem;
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button2 setTitle:@"测试" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(testButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItems = @[testItem];
}

- (void)setupProgressView
{
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(- kScreenWidth + 10, 0, kScreenWidth, 4)];
    progressView.backgroundColor = [UIColor redColor];
    _progressView = progressView;
    [self.view addSubview:progressView];
}

- (void)setupWebView
{
    WKWebViewConfiguration *configration = [self getConfigration];
    [configration.userContentController addScriptMessageHandler:self name:@"toweixin://"];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight - 64) configuration:configration];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:self.testFilePath];
    NSURL *directoryPath = [NSURL fileURLWithPath:self.testPath];
    
    [self.webView loadFileURL:fileUrl allowingReadAccessToURL:directoryPath];
    
}

- (WKWebViewConfiguration *)getConfigration
{
    DC_LOG(@"getCOnfigration");
    WKWebViewConfiguration *configration = [[WKWebViewConfiguration alloc] init];
    configration.preferences.javaScriptEnabled = YES;
    
    NSString *changBackground = @"document.body.style.background = \"#f3704b\"";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:changBackground injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:userScript];
    
    [userContentController addScriptMessageHandler:self name:@"Cancel"];
    configration.userContentController = userContentController;
    
    return configration;
}

// MARK: - WKUIDelegate Methods
//--------------------------------------------------------------------

- (void)webViewDidClose:(WKWebView *)webView
{
    DC_LOG(@"webViewEnd,progress:%f", webView.estimatedProgress);
}

// MARK: - WKNavigationDelegate Methods
//--------------------------------------------------------------------

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    DC_LOG(@"webView111,progress:%f", webView.estimatedProgress);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
//    DC_LOG(@"webView222,progress:%f", webView.estimatedProgress);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    DC_LOG(@"webView333,progress:%f", webView.estimatedProgress);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
//    DC_LOG(@"webView444,progress:%f", webView.estimatedProgress);
}

// MARK: - WKScriptMessageHandler Methods
//--------------------------------------------------------------------

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    DC_LOG(@"didReceiveScriptMessage:%@", message.body);
}

// MARK: - Private Methods
//--------------------------------------------------------------------

- (void)backButtonTouched:(UIBarButtonItem *)sender
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        DC_LOG(@"go back");
    } else {
        CGRect rect = self.progressView.frame;
        rect.origin.x = -kScreenWidth;
        self.progressView.frame = rect;
        [self.webView reload];

        DC_LOG(@"cant go back")
    }
}

- (void)testButtonTouched:(UIBarButtonItem *)sender
{
    // test
    [self javaScript:@"callJsAlert()"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGRect rect = self.progressView.frame;
        rect.origin.x = - (1 - self.webView.estimatedProgress) * kScreenWidth;
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.frame = rect;
        }];
    }
}

- (void)javaScript:(NSString *)method
{
    [self.webView evaluateJavaScript:method completionHandler:^(_Nullable id object, NSError * _Nullable error) {
        if (error) {
            DC_LOG(@"%@", error);
        } else {
            DC_LOG(@"evaluate success");
        }
    }];
}

@end
