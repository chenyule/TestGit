//
//  ItemModel.h
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemModel : NSObject

@property (nonatomic, copy,nullable) NSString *errorString;

@property (nonatomic, assign) BOOL empty;

- (NSString *)itemCellIdentiferString;

- (void)chengError;

- (NSDictionary *)serverDic;




@end

NS_ASSUME_NONNULL_END
