//
//  ListViewController.m
//  SearchCar
//
//  Created by a11 on 2019/5/29.
//  Copyright © 2019 YuXiang. All rights reserved.
//

#import "ListViewController.h"
#import "ListCarCell.h"
#import "CarModel.h"
#import "AddViewController.h"
#import "LocalManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ListViewController () <UITableViewDataSource,UITableViewDelegate>

/** 停车记录视图 */
@property (nonatomic, weak) IBOutlet UITableView *listTable;
/** 停车记录数据 */
@property (nonatomic, strong) NSMutableArray <CarModel *>*carModelArray;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"停车记录";
    
    [self buidUI];
    [self buidData];
}

- (void)viewDidLayoutSubviews{
    
    CAGradientLayer *grandeLyer = [CAGradientLayer layer];
    grandeLyer.frame = self.view.layer.bounds;
    grandeLyer.startPoint = CGPointMake(0, 1);
    grandeLyer.endPoint = CGPointMake(0, 0);
    grandeLyer.colors = @[(id)[UIColor colorWithRed:214/255.0 green:228/255.0 blue:255/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:214/255.0 green:228/255.0 blue:255/255.0 alpha:1.0].CGColor ];
    [self.view.layer insertSublayer:grandeLyer atIndex:0];
    
}

- (void)buidUI{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGFLOAT_MIN)];
    [self.listTable setTableHeaderView: header];
    [self.listTable registerNib:[UINib nibWithNibName:@"ListCarCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListCarCell class])];
    [self.listTable setShowsVerticalScrollIndicator:NO];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:89/255.0 green:126/255.0 blue:247/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18]}];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)buidData{
    
    NSArray *array = [self.class cacheData];
    
    if (array.count) {
        
        [self.carModelArray addObjectsFromArray:array];
    }
    
    [self.listTable reloadData];
    
}

- (NSMutableArray <CarModel *>*)carModelArray{
    
    if (!_carModelArray) {
        
        _carModelArray = [NSMutableArray array];
        
    }
    
    return _carModelArray;
}


- (IBAction)add:(UIButton *)sender {
    
    AddViewController *addViewController = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    
    addViewController.SureAdd = ^(NSDictionary * _Nonnull dic) {
        
        CarModel *carModel = [[CarModel alloc] init];
        carModel.imagePath = dic[IMAGEPNG];
        carModel.address = dic[ADRESS];
        carModel.voicePath = dic[VIDEO];
        carModel.timeLenth = [dic[TIMELEN] integerValue];
        carModel.time = dic[TIME];
        
        [self.carModelArray insertObject:carModel atIndex:0];
        [self.class saveCache:self.carModelArray];
        [self.listTable insertSection:0 withRowAnimation:UITableViewRowAnimationTop];
    };
    
    
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.carModelArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    CarModel *carModel = self.carModelArray[indexPath.section];
    
    ListCarCell *listCarCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListCarCell class])];
    
    [listCarCell setCarModel:carModel];
    
    return listCarCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"xxxxx");
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    return 120;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}


-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (BOOL )tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删  除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        CarModel *carModel = [self.carModelArray  objectAtIndex:indexPath.section];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:carModel.imagePath]) {
            
            [fileManager removeItemAtPath:carModel.imagePath error:nil];
            
        }
        
        if ([fileManager fileExistsAtPath:carModel.voicePath]) {
            
            [fileManager removeItemAtPath:carModel.voicePath error:nil];
        }
        
        
        [self.carModelArray removeObject:carModel];
        [self.class saveCache:self.carModelArray];
        
        [tableView deleteSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    deleteRowAction.backgroundColor = [UIColor redColor];
    return @[deleteRowAction];
}


#pragma makr - 数据本地化

+ (NSString *)cachePath{
 
    NSString*doucumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    
    NSString *cachePath = [doucumentPath stringByAppendingPathComponent:@"list.archiver"];
    
    return cachePath;
}



+ (NSArray *)cacheData{
    
    
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePath]];
    
    return array;
}

+ (void)saveCache:(NSArray *)arrary{

    [NSKeyedArchiver archiveRootObject:arrary toFile:self.cachePath];
    
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
