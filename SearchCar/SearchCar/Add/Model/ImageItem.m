//
//  ImageItem.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "ImageItem.h"
#import "ImageCell.h"

@implementation ImageItem

- (NSString *)itemCellIdentiferString{
    
    return NSStringFromClass([ImageCell class]);
}


- (void)chengError{
    
    if (!self.image) {
        
        self.empty = YES;
        self.errorString = @"拍张停车位置图片吧";
    }else{
        
        [super chengError];
        
    }
    
}

- (NSDictionary *)serverDic{
    
    return @{IMAGEPNG:self.imagePath,
             TIME:[self currentTimeWithFormater:@"yyyy-MM-dd HH:mm"]
             };
}

- (NSString *)imagePath{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dateString = [self currentTimeWithFormater:@"yyyyMMddHHmmss"];
    NSString *aacRecordFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",dateString]];
    
    NSData *imageData = UIImageJPEGRepresentation(self.image,0.5);
    
    BOOL isSuccess = [imageData writeToFile:aacRecordFilePath atomically:YES];
    
    if (isSuccess) {
        
        NSLog(@"图片路径 %@",aacRecordFilePath);
    }
    
    
    return aacRecordFilePath;
}


- (NSString *)currentTimeWithFormater:(NSString *)formaterString{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fomate = [[NSDateFormatter alloc] init];
    [fomate setDateFormat:formaterString];
    NSString *dateString = [fomate stringFromDate:date];
    
    return dateString;
    
}

@end
