//
//  VoiceCell.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "VoiceCell.h"
#import "VoiceModel.h"
#import <AVFoundation/AVFoundation.h>
#import "RecordPlayerViewController.h"


@interface VoiceCell ()

@property (nonatomic, weak) VoiceModel* voiceModel;

@property (nonatomic, weak) IBOutlet UILabel * detailLabel;

@property (nonatomic, weak) IBOutlet UIButton *voiceButton;

@end

@implementation VoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ItemModel *)itemModel{
    [super setItemModel:itemModel];
    
    VoiceModel* voiceModel = (VoiceModel *)itemModel;
    
    if (voiceModel.voicePathTemp.length) {
        
        self.detailLabel.text = @"点击播放按钮播放录音";
        [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"laba"] forState:UIControlStateNormal];
        
    }else{
        
        self.detailLabel.text = @"点击录音按钮录音";
        [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    }
    
    self.voiceModel = voiceModel;
}

- (IBAction)recod:(id)sender{
    
    
    if (self.voiceModel.voicePathTemp.length) {
        
        
        RecordPlayerViewController *recordPlayerViewController = [[RecordPlayerViewController alloc] init];
        recordPlayerViewController.popSize = CGSizeMake(kWidth, 180);
        recordPlayerViewController.voiceToPlayURL = self.voiceModel.voicePathTemp;
        recordPlayerViewController.time = self.voiceModel.time;
        [self.viewController presentViewController:recordPlayerViewController animated:YES completion:nil];
        
    }else{
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            NSLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
            
            if (granted) {
                
                RecordPlayerViewController *recordPlayerViewController = [[RecordPlayerViewController alloc] init];
                recordPlayerViewController.popSize = CGSizeMake(kWidth, 180);
                recordPlayerViewController.recodeFinished = ^(NSString *recodUrl, NSInteger time) {
                    
                    NSDate *date = [NSDate date];
                    NSDateFormatter *fomate = [[NSDateFormatter alloc] init];
                    [fomate setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
                    NSString *dateString = [fomate stringFromDate:date];
                    
                    NSString *aacRecordFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",dateString,@"temp.Wav"]];
                    
                    if (self.voiceModel.voicePathTemp.length) {
                        
                        [[NSFileManager defaultManager] removeItemAtPath:self.voiceModel.voicePathTemp error:nil];
                    }
                    
                    [[NSFileManager defaultManager] moveItemAtPath:recodUrl toPath:aacRecordFilePath error:nil];
                    
                    self.voiceModel.voicePathTemp = aacRecordFilePath;
                    self.voiceModel.time = time;
                    [self setItemModel:self.voiceModel];
                };
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.viewController presentViewController:recordPlayerViewController animated:YES completion:nil];
                });
                
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showHudWithText:@"没有麦克风访问权限"];
                });
            }
            
        }];
    }
    
    

}

- (void)showHudWithText:(NSString *)string{
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.cornerRadius = 4.0f;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = string;
    hud.margin = 18.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}


@end
