//
//  chainReactionPictureViewController.m
//  ReactiveCocoaTest
//
//  Created by 董真真 on 2017/6/16.
//  Copyright © 2017年 董真真. All rights reserved.
//

#import "chainReactionPictureViewController.h"
#import "chainReactionPictureTableViewCell.h"
@interface chainReactionPictureViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation chainReactionPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
       self.tableView = tableView;
    self.tableView.rowHeight = 200;

    [self.tableView registerClass:[chainReactionPictureTableViewCell class] forCellReuseIdentifier:@"chainReactionPictureTableViewCell"];
    [self.view addSubview:self.tableView];
    for (NSUInteger i = 0; i < 13; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"image%03ld.jpg",(unsigned long)i];
        [self.dataArray addObject:imageName];
    }
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    chainReactionPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chainReactionPictureTableViewCell" forIndexPath:indexPath];
    cell.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
//     CGFloat yOffset = -((self.tableView.contentOffset.y - cell.frame.origin.y) / 200) * 10;
//      NSLog(@"%f  %f   %f",yOffset ,self.tableView.contentOffset.y,cell.frame.origin.y);
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (chainReactionPictureTableViewCell *cell in self.tableView.visibleCells) {
//        CGFloat yOffset = ((self.tableView.contentOffset.y - cell.frame.origin.y) / 200) * 10;
//        NSLog(@"%f  %f   %f",yOffset ,self.tableView.contentOffset.y,cell.frame.origin.y);
//        cell.imageOffSet = CGPointMake(0, yOffset);
        [cell updateBackImageViewYForTableView:self.tableView andView:self.view];
    }
}
@end
