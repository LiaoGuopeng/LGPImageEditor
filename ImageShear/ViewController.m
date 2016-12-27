//
//  ViewController.m
//  ImageShear
//
//  Created by guopeng Liao on 2016/12/22.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用过程中如果出现bug，或者有任何不适当的地方，请及时以以下任意一种方式联系我。               *
 *                                                                     *
 * 持续更新地址: https://github.com/LiaoGuopeng/LGPImageEditor                             *
 * QQ : 756581014
 *
 * Email : 756581014@qq.com                                                          *
 * GitHub: https://github.com/LiaoGuopeng                                              *                                                                *
 *                                                                                *
 *********************************************************************************
 
 */


#import "ViewController.h"
#import "LGPImageEditor.h"
#import "LGPRectEditVC.h"
#import "LGPOvalEditVC.h"
#import "LGPCustomEditVC.h"

#define WeakObj(o) __weak typeof(o) o##Weak = o;

#define kTitleArr @[@"矩形选取",@"椭圆选取",@"自定义选取"]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}

- (void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return kTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = kTitleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController * vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [LGPRectEditVC new];
            break;
        case 1:
            vc = [LGPOvalEditVC new];
            break;
        default:
            vc = [LGPCustomEditVC new];
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
