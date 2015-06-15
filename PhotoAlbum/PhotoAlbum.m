//
//  PhotoAlbum.m
//  PhotoAlbum
//
//  Created by foreveross－bj on 15/6/12.
//  Copyright (c) 2015年 foreveross－bj. All rights reserved.
//

#import "PhotoAlbum.h"

/**
 * 滑动的方向
 */
typedef NS_ENUM(NSInteger, ScrollDirection){
    ScrollNODirection = 0,    //没划动
    ScrollLeftDirection,      //向左划
    ScrollRightDirection      //向右划
};

@interface PhotoAlbum ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger ppIndex;                //上上一个view的索引
@property (nonatomic, assign) NSInteger previousIndex;          //上一个view的索引
@property (nonatomic, assign) NSInteger currentIndex;           //当前页的索引
@property (nonatomic, assign) NSInteger nextIndex;              //下一个view的索引
@property (nonatomic, assign) NSInteger nnIndex;                //下下一个view的索引
@property (nonatomic, strong) NSMutableArray *contentViews;     //当前显示的view
@property (nonatomic, assign) ScrollDirection scrollDirection;  //当前滑动的方向


@end
@implementation PhotoAlbum
/**
 * 出事化相册
 * @param frame
 * @param totalCount 子视图的总数量
 */
- (id)initWithFrame:(CGRect)frame totalCount:(NSInteger)totalCount{
    self = [super initWithFrame:frame];
    if (self) {
        _totalCount = totalCount;
    }
    return self;
}

- (void)setAddSubView:(UIView *(^)(NSInteger))AddSubView{
    _AddSubView = AddSubView;
    //初始化子视图
    [self initSubviews];
}

/**
 * 初始化子视图
 */
- (void)initSubviews{
    _ppIndex = _totalCount - 2;
    _previousIndex = _totalCount - 1;
    _currentIndex = 0;
    _nextIndex = 1;
    _nnIndex = 2;
    self.contentViews = [[NSMutableArray alloc] init];
    _scrollDirection = ScrollNODirection;
    self.delegate = self;
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 5, CGRectGetHeight(self.frame));
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self setSubviews];
}

/**
 * 设置子视图内容
 */

- (void)setSubviews{
    [_contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_AddSubView) {
        if (_contentViews.count == 0) {
            [_contentViews addObject:_AddSubView(_ppIndex)];
            [_contentViews addObject:_AddSubView(_previousIndex)];
            [_contentViews addObject:_AddSubView(_currentIndex)];
            [_contentViews addObject:_AddSubView(_nextIndex)];
            [_contentViews addObject:_AddSubView(_nnIndex)];
        }else{
            if (_scrollDirection == ScrollLeftDirection) {
                [_contentViews removeObjectAtIndex:4];
                [_contentViews insertObject:_AddSubView(_ppIndex) atIndex:0];
            }else if(_scrollDirection == ScrollRightDirection){
                [_contentViews removeObjectAtIndex:0];
                [_contentViews addObject:_AddSubView(_nnIndex)];
            }
        }
        
        for (int i = 0; i < _contentViews.count; i++) {
            [_contentViews[i] setFrame:CGRectMake(i * CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
            [self addSubview:_contentViews[i]];
        }
    }
    [self scrollRectToVisible:CGRectMake(CGRectGetWidth(self.frame) * 2, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) animated:NO];
}


/**
 * 获取新的索引
 * @param direction 划动的方向
 */
- (void)getNewIndex{
    if (_scrollDirection == ScrollLeftDirection) {
        _ppIndex = [self indexWithNewIndex:_ppIndex - 1];
        _previousIndex = [self indexWithNewIndex:_previousIndex - 1];
        _currentIndex = [self indexWithNewIndex:_currentIndex - 1];
        _nextIndex = [self indexWithNewIndex:_nextIndex - 1];
        _nnIndex = [self indexWithNewIndex:_nnIndex - 1];
    }else if(_scrollDirection == ScrollRightDirection){
        _ppIndex = [self indexWithNewIndex:_ppIndex + 1];
        _previousIndex = [self indexWithNewIndex:_previousIndex + 1];
        _currentIndex = [self indexWithNewIndex:_currentIndex + 1];
        _nextIndex = [self indexWithNewIndex:_nextIndex + 1];
        _nnIndex = [self indexWithNewIndex:_nnIndex + 1];
    }
}

/**
 * 检测索引值是否合法，如果不合法返回合法的值
 * @param newIndex
 * @return
 */
- (NSInteger)indexWithNewIndex:(NSInteger)newIndex{
    if (newIndex < 0) {
        return _totalCount - 1;
    }else if(newIndex > _totalCount - 1){
        return 0;
    }else{
        return newIndex;
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.contentOffset.x < CGRectGetWidth(self.frame) * 2) {
         _scrollDirection = ScrollLeftDirection;
        [self getNewIndex];
    }else if(self.contentOffset.x > CGRectGetWidth(self.frame) * 2){
        _scrollDirection = ScrollRightDirection;
        [self getNewIndex];
    }else{
        _scrollDirection = ScrollNODirection;
    }
    [self setSubviews];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
