//
//  MZGuidePages.m
//  MZGuidePages
//
//  Created by boco on 15/11/13.
//  Copyright © 2015年 Machelle. All rights reserved.
//

#import "MZGuidePages.h"



@interface MZGuidePages () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation MZGuidePages

// init
- (instancetype)init
{
    return [self initWithImageDatas:nil completion:nil];
}

// init with imageDatas and completion
- (instancetype)initWithImageDatas:(NSArray *)imageDatas completion:(void (^)(void))buttonAction
{
    self = [super init];
    if (self)
    {
        [self initView];
        //因为使用了懒加载，_imageDatas = imageDatas不会调用initContentView
        [self setImageDatas:imageDatas];
        _buttonAction = buttonAction;
    }
    return self;
}

//懒加载，并初始化内容
- (void)setImageDatas:(NSArray *)imageDatas
{
    _imageDatas = imageDatas;
    [self initContentView];
}

//基础视图初始化
- (void)initView
{
    // init view
    self.frame = CGRectMake(0, 0, LFscreenW, LFscreenH);

    // init scrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 0, LFscreenW, LFscreenH);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    // init pageControl
    _pageControl =
        [[UIPageControl alloc] initWithFrame:CGRectMake(0, LFscreenH - 30, LFscreenW, 10)];
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];

    // init button
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
}

//指定数据后，初始化显示内容
- (void)initContentView
{
    if (_imageDatas.count)
    {
        _pageControl.numberOfPages = _imageDatas.count;
        _scrollView.contentSize = CGSizeMake(LFscreenW * _imageDatas.count, LFscreenH);
        for (int i = 0; i < _imageDatas.count; i++)
        {
            NSString *imageName = _imageDatas[i];
            UIImageView *imgView =
                [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imgView.frame = CGRectMake(LFscreenW * i, 0, LFscreenW, LFscreenH);
            [self.scrollView addSubview:imgView];

            if (i == _imageDatas.count - 1)
            {
                _actionButton.frame =
                    imgView.bounds;
                _actionButton.layer.cornerRadius = 5;
                _actionButton.layer.masksToBounds = YES;
              //  [_actionButton setTitle:@"进  入" forState:UIControlStateNormal];
//                _actionButton.tintColor = [UIColor whiteColor];
//                _actionButton.backgroundColor = [UIColor redColor];
                [_actionButton addTarget:self
                                  action:@selector(enterButtonClick)
                        forControlEvents:UIControlEventTouchUpInside];
                [imgView addSubview:_actionButton];
                //设置可以响应交互，UIImageView的默认值为NO
                imgView.userInteractionEnabled = YES;
            }
        }
    }
}

#pragma mark Action
- (void)enterButtonClick
{
    if (_buttonAction)
    {
        _buttonAction();
    }
}

#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = (_scrollView.contentOffset.x + LFscreenW / 2) / LFscreenW;
    
//    if (_pageControl.currentPage>=_imageDatas.count-1) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self enterButtonClick ];
//        });
//  
//    }

    }

@end