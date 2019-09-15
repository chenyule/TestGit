//
//  PopTransition.m
//  HwariotGlobal
//
//  Created by a11 on 2018/7/24.
//  Copyright © 2018年 hrwl. All rights reserved.
//

#import "PopTransition.h"
#import "PopView.h"

@interface PopTransition () <UIGestureRecognizerDelegate>

@property (nonatomic ,weak) UIViewController *presentVC;

@end

@implementation PopTransition


-(NSTimeInterval )transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return .3;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    if (self.type == PopTypePresent) {
        
        [self animationForPresent:transitionContext];
        
    }else if (self.type == PopTypeDismiss){
        
        [self animationForDismiss:transitionContext];
        
    }else if (self.type == PopTypeCenter){
        
        [self animationForPresentCenter:transitionContext];
        
    }else if (self.type == PopTypeDismissCenter){
        
        [self animationForPresentCenterDisMiss:transitionContext];
    }
}


#pragma mark - 底部出现 底部消失
-(void)animationForPresent:(id<UIViewControllerContextTransitioning>)transitionContext{
    

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    self.presentVC = toVC;
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
    [containerView addSubview:toVC.view];
    
    
    PopView *popView = (PopView *)toVC;
    
    CGSize popSize = popView.popSize;
    
    CGFloat x = (containerView.width - popSize.width)/2.0;
    
    toVC.view.frame = CGRectMake(x, containerView.height, popSize.width, popView.popSize.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGFloat bottom = (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) > 20) ? 34 : 0;
        
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -popView.popSize.height-bottom);
        
    } completion:^(BOOL finished) {
       
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    [self addGestureToView:containerView];
}


-(void)animationForDismiss:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        fromVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    

}

#pragma mark - 中心出现 中心消失

-(void)animationForPresentCenter:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    self.presentVC = toVC;
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
    [containerView addSubview:toVC.view];
    
    PopView *popView = (PopView *)toVC;
    
    CGSize popSize = popView.popSize;
    
    toVC.view.bounds = CGRectMake(0, 0, popSize.width,popSize.height);
    
    toVC.view.center = containerView.center;
    
    toVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    
    [UIView animateWithDuration:.3 animations:^{
        
        toVC.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 animations:^{
            
            toVC.view.transform = CGAffineTransformIdentity;
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
    
    
    [self addGestureToView:containerView];
    
}

-(void)animationForPresentCenterDisMiss:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        fromVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


#pragma mark - 添加点击空白处试图消失

-(void)addGestureToView:(UIView *)view{
    
    __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        [weakSelf.presentVC dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [view addGestureRecognizer:tapGesture];
    
    tapGesture.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:self.presentVC.view];
    
    if (CGRectContainsPoint(self.presentVC.view.bounds, point)) {
        
        return NO;
    }

    return YES;
    
}

@end
