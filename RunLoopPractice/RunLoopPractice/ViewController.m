//
//  ViewController.m
//  RunLoopPractice
//
//  Created by kimiLin on 2017/3/13.
//  Copyright © 2017年 KimiLin. All rights reserved.
//

#import "ViewController.h"
#import "RunLoopTool.h"
#import <objc/runtime.h>

@interface UITableViewCell (indexPath)
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

@implementation UITableViewCell (indexPath)

- (NSIndexPath *)currentIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    objc_setAssociatedObject(self, @selector(currentIndexPath), currentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end



@implementation ViewController

CGFloat rowHei = 120.;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.table.delegate = self;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHei;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.currentIndexPath = indexPath;
    
    [self cellAddText:cell];
    
//    [self cellAddImage1:cell];
//    [self cellAddImage2:cell];
//    [self cellAddImage3:cell];
    
    [RunLoopTool addUnit:^BOOL{
        if (![cell.currentIndexPath isEqual:indexPath]) {
            return NO;
        }
        [self cellAddImage1:cell];
        return YES;
    }];
    
    [RunLoopTool addUnit:^BOOL{
        if (![cell.currentIndexPath isEqual:indexPath]) {
            return NO;
        }
        [self cellAddImage2:cell];
        return YES;
    }];
    
    [RunLoopTool addUnit:^BOOL{
        if (![cell.currentIndexPath isEqual:indexPath]) {
            return NO;
        }
        [self cellAddImage3:cell];
        return YES;
    }];
    
    return cell;
}

- (void)cellAddText:(UITableViewCell *)cell {
    for (UIView *sv in cell.contentView.subviews) {
        [sv removeFromSuperview];
    }
    UILabel *la = [[UILabel alloc]init];
    la.text = [NSString stringWithFormat:@"%@--Description",cell.currentIndexPath];
    la.font = [UIFont systemFontOfSize:15];
    [la sizeToFit];
    [cell.contentView addSubview:la];
}

- (void)cellAddImage1:(UITableViewCell *)cell {
    int i = 0;
    CGFloat ypos = 20, wid = 100, mar = 5., xpos = mar * (i+1) + wid * i;
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(xpos, ypos, wid, rowHei - ypos)];
    imv.contentMode = UIViewContentModeScaleToFill;
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    imv.image = [UIImage imageWithContentsOfFile:imgPath];
//    [cell.contentView addSubview:imv];
    [UIView transitionWithView:cell.contentView duration:0.05 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imv];
    } completion:nil];
    
}

- (void)cellAddImage2:(UITableViewCell *)cell {
    int i = 1;
    CGFloat ypos = 20, wid = 100, mar = 5., xpos = mar * (i+1) + wid * i;
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(xpos, ypos, wid, rowHei - ypos)];
    imv.contentMode = UIViewContentModeScaleToFill;
    imv.image = [UIImage imageNamed:@"test.jpg"];
//    [cell.contentView addSubview:imv];
    [UIView transitionWithView:cell.contentView duration:0.05 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imv];
    } completion:nil];
}

- (void)cellAddImage3:(UITableViewCell *)cell {
    int i = 2;
    CGFloat ypos = 20, wid = 100, mar = 5., xpos = mar * (i+1) + wid * i;
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(xpos, ypos, 100, rowHei - ypos)];
    imv.contentMode = UIViewContentModeScaleToFill;
    imv.image = [UIImage imageNamed:@"test.jpg"];
//    [cell.contentView addSubview:imv];
    [UIView transitionWithView:cell.contentView duration:0.05 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [cell.contentView addSubview:imv];
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
