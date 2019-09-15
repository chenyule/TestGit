//
//  VoiceModel.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "VoiceModel.h"
#import "VoiceCell.h"

@implementation VoiceModel


- (NSString *)itemCellIdentiferString{
    
    return NSStringFromClass([VoiceCell class]);
}


- (void)chengError{
    
    if (!self.voicePathTemp.length || self.time < MINRECORDTIME) {
        
        self.empty = YES;
        self.errorString = @"录一段备忘语音吧";
        
    }else{
        
        [super chengError];
    }
    
}

- (NSDictionary *)serverDic{
    
    return @{VIDEO:self.localPath,
             TIMELEN:@(self.time)
             };
}

- (NSString *)localPath{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fomate = [[NSDateFormatter alloc] init];
    [fomate setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *dateString = [fomate stringFromDate:date];
    
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *aacRecordFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",dateString,@"local.Wav"]];
    [[NSFileManager defaultManager] moveItemAtPath:self.voicePathTemp toPath:aacRecordFilePath error:nil];
    
    return aacRecordFilePath;
}


@end
