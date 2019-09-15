//
//  PopView.m
//  HwariotGlobal
//
//  Created by a11 on 2018/7/24.
//  Copyright © 2018年 hrwl. All rights reserved.
//

#import "PopView.h"


@interface PopView ()

@property(nonatomic,strong) PopTransition *popTransition;

@end

@implementation PopView

-(instancetype )initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self addDelegate];
    }
    
    return self;
}

-(instancetype )init{
    
    if (self = [super init]) {
        
        [self addDelegate];
    }
    
    return self;
}

-(void)addDelegate{
    
    self.transitioningDelegate = (id) self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.popTransition = [[PopTransition alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    self.popTransition.type = [self presentType];
    
    return self.popTransition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    self.popTransition.type = [self dismisType];
    
    return self.popTransition;
}


-(PopType)presentType{
    
    return PopTypePresent;
}

-(PopType)dismisType{
    
    return PopTypeDismiss;
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
