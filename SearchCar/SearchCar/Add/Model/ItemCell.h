//
//  ItemCell.h
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemCell : UITableViewCell

@property (nonatomic, weak) ItemModel *itemModel;

- (void)touchEvent;

@end

NS_ASSUME_NONNULL_END
