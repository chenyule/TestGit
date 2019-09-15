//
//  ListCarCell.m
//  SearchCar
//
//  Created by a11 on 2019/5/29.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "ListCarCell.h"
#import "RecordPlayerViewController.h"

@interface ListCarCell ()

/** 拍照图片 */
@property (nonatomic, weak) IBOutlet UIImageView *carImageView;

/** 时间 */
@property (nonatomic, weak) IBOutlet UILabel *timelabel;
/** 地址 */
@property (nonatomic, weak) IBOutlet UILabel *addressLabe;

@end

@implementation ListCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor redColor];
    
    self.carImageView.layer.masksToBounds = YES;
    self.carImageView.layer.cornerRadius = 10.0;
    self.carImageView.backgroundColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.7 alpha:0.7];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCarModel:(CarModel *)carModel{
    _carModel = carModel;
    
    self.carImageView.image = [UIImage imageWithContentsOfFile:carModel.imagePath];
    self.timelabel.text = [NSString stringWithFormat:@"时间 : %@",carModel.time];
    self.addressLabe.text = [NSString stringWithFormat:@"地址 : %@",carModel.address];
    self.carImageView.image = [UIImage imageWithContentsOfFile:carModel.imagePath];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 5, 2) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.path = path.CGPath;

    self.layer.mask = shapLayer;
    
}


- (IBAction)viocePlay:(id)sender{
    
    RecordPlayerViewController *recordPlayerViewController = [[RecordPlayerViewController alloc] init];
    recordPlayerViewController.popSize = CGSizeMake(kWidth, 180);
    recordPlayerViewController.voiceToPlayURL = self.carModel.voicePath;
    recordPlayerViewController.time = self.carModel.timeLenth;
    [self.viewController presentViewController:recordPlayerViewController animated:YES completion:nil];
    
    
}

@end
