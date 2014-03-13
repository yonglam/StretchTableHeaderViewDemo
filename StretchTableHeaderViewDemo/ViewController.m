//
//  ViewController.m
//  StretchTableHeaderViewDemo
//
//  Created by Lin Yong on 14-3-13.
//  Copyright (c) 2014年 Lin Yong. All rights reserved.
//

#import "ViewController.h"
#import "StretchTableHeaderView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) StretchTableHeaderView *headerView;
@property (nonatomic) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.tableView];
    
    self.headerView = [[StretchTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kOneRowHeight)];
    self.headerView.scrollView = self.tableView;
    [self.view addSubview:self.headerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self.headerView handleScrollEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.headerView handleScrollEnd];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.headerView handleScrollBeginDraging];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.headerView handleScrollAnimationEnd];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
