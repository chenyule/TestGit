//
//  WebViewController.m
//  SearchCar
//
//  Created by a11 on 2019/6/3.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *mainWeb;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self loadWeb];
}


-(void)loadWeb{
    
    NSURL *remoteURL = [NSURL URLWithString:self.url];
    NSURLRequest *request =[NSURLRequest requestWithURL:remoteURL];
    self.mainWeb.scrollView.bounces = NO;
    [self.mainWeb loadRequest:request];
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
