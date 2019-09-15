//
//  AddressModel.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "AddressModel.h"
#import "AddressCell.h"

@implementation AddressModel


- (NSString *)itemCellIdentiferString{
    
    return NSStringFromClass([AddressCell class]);
}

- (void)chengError{
    
    if (!self.address || [self.address isEqualToString:@""]) {
        
        self.empty = YES;
        self.errorString = @"请输入停车定点吧";
    }else{
        
        [super chengError];
    }
    
}

- (NSDictionary *)serverDic{
    
    return @{ADRESS:self.address
             
             };
    
}


@end
