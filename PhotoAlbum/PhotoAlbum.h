//
//  PhotoAlbum.h
//  PhotoAlbum
//
//  Created by foreveross－bj on 15/6/12.
//  Copyright (c) 2015年 foreveross－bj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAlbum : UIScrollView

@property (nonatomic, readonly) NSInteger totalCount;  //子视图的总数量
@property (nonatomic, copy) UIView *(^AddSubView)(NSInteger index); //block返回要加载的view

#pragma mark - init

/**
 * 出事化相册
 * @param frame
 * @param totalCount 子视图的总数量
 */
- (id)initWithFrame:(CGRect)frame totalCount:(NSInteger)totalCount;


@end
