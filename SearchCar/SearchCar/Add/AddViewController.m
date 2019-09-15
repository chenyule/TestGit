//
//  AddViewController.m
//  SearchCar
//
//  Created by a11 on 2019/5/30.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "AddViewController.h"
#import "ItemCell.h"
#import "ImageItem.h"
#import "VoiceModel.h"
#import "AddressModel.h"

#import "LocalManager.h"

@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *addListView;

@property (nonatomic, strong) NSMutableArray <ItemModel *> *itemModelArray;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记停车";
    
    [self buidUI];
    [self buidData];
}

- (void)buidUI{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGFLOAT_MIN)];
    [self.addListView setTableHeaderView: header];
    [self.addListView setShowsVerticalScrollIndicator:NO];
    self.addListView.rowHeight = UITableViewAutomaticDimension;
    self.addListView.estimatedRowHeight = 100;
    
    if ([self.addListView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.addListView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.addListView respondsToSelector:@selector(setLayoutManager:)]){
     
        [self.addListView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)finish:(id)sender{
    
    //检测输入
    [self.itemModelArray makeObjectsPerformSelector:@selector(chengError)];
    //筛选出空输入项
    NSPredicate *prede = [NSPredicate predicateWithFormat:@"SELF.empty = 1"];
    NSArray <ItemModel *>*emptyItems = [self.itemModelArray filteredArrayUsingPredicate:prede];
    
    if (emptyItems.count) {
        
        ItemModel *itemModel = emptyItems.firstObject;
        
        [self showHudWithText:itemModel.errorString];
        
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [self.itemModelArray enumerateObjectsUsingBlock:^(ItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *itemParm = [obj serverDic];
        
        if (itemParm) {
            
            [params addEntriesFromDictionary:itemParm];
        }
        
    }];
    
    //创建对象(回传)
    if (self.SureAdd) {
        
        self.SureAdd(params);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (void)buidData{
    
    //图片
    ImageItem *imageItem = [[ImageItem alloc] init];
    [self.itemModelArray addObject:imageItem];
    //录音
    VoiceModel *voiceModel = [[VoiceModel alloc] init];
    [self.itemModelArray addObject:voiceModel];
    //地址
    AddressModel *adressModel = [[AddressModel alloc] init];
    [self.itemModelArray addObject:adressModel];
    
    [self.addListView reloadData];
    
    
    __weak typeof(self) wealSelf = self;
    [[LocalManager shareInstace] startLocalWithResult:^(NSString * _Nonnull address) {
        
        adressModel.address = address;
        
        [wealSelf.addListView reloadData];
        
    } faild:nil];
}

- (NSMutableArray <ItemModel *>*)itemModelArray{
 
    if (!_itemModelArray) {
        
        _itemModelArray = [NSMutableArray array];
    }
    
    return _itemModelArray;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.itemModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemModel *itemModel = self.itemModelArray[indexPath.row];
    
    ItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:itemModel.itemCellIdentiferString];
    
    if (!itemCell) {
        
        [tableView registerNib:[UINib nibWithNibName:itemModel.itemCellIdentiferString bundle:nil] forCellReuseIdentifier:itemModel.itemCellIdentiferString];
        
        itemCell = [tableView dequeueReusableCellWithIdentifier:itemModel.itemCellIdentiferString];
    }
    
    [itemCell setItemModel:itemModel];
    
    return itemCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *itemCel = (ItemCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    [itemCel touchEvent];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}


-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
