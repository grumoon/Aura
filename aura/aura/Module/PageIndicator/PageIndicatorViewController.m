//
//  PageIndicatorViewController.m
//  aura
//
//  Created by Grumoon on 2020/6/7.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "PageIndicatorViewController.h"
#import "GPageIndicator.h"


#define PAGE_TOTAL_COUNT 5

#define CAROUSEL_INTERVAL 4.0 //轮播间隔
#define CAROUSEL_ANIMATION_DURATION 1.0 //轮播切换动画时长

@interface PageIndicatorViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) GPageIndicator *pageIndicator;

@property (nonatomic, strong) NSMutableArray *viewArray;

@property (nonatomic, assign) UInt32 currentIndex;

@property (nonatomic, assign) BOOL carouselRunningFlag; //自动轮播中标志位
@property (nonatomic, assign) BOOL draggingFlag; //控件拖动中标志位
@property (nonatomic, assign) BOOL turnPageAnimatingFlag; // 正在做翻页动画标志位


@property (nonatomic, strong) NSTimer *autoCarouselTimer;

@end

@implementation PageIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self initView];
    [self tryStartAutoCarousel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    self.scrollView.delegate = nil;
    self.viewArray = nil;
    [self stopAutoCarousel];
}

- (void)initView {
    self.view.clipsToBounds = NO;
    self.view.userInteractionEnabled = YES;

    [self.container addSubview:self.scrollView];
    [self.container addSubview:self.pageCtrl];
    [self.container addSubview:self.pageIndicator];

    self.currentIndex = 0;
    
    int viewTotalCount = PAGE_TOTAL_COUNT + 2;
    self.viewArray = [NSMutableArray arrayWithCapacity: viewTotalCount];
    
    int originX = 0;
    for (int i = 0; i < viewTotalCount; i++) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.frame = CGRectMake(originX, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        view.layer.backgroundColor = UIColor.blackColor.CGColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 80)];
        label.backgroundColor = [UIColor grayColor];
        label.text = [NSString stringWithFormat: @"第 %ld 页面", [self getDataIndexFromViewIndex:i] + 1];
        [view addSubview:label];
        
        [self.viewArray addObject:view];
        [self.scrollView addSubview:view];
        originX += view.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(originX, self.scrollView.frame.size.height);
    [self adjustScrollView];
    
    self.scrollView.frame = CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height);
    
    
    self.pageCtrl.frame = CGRectMake(0,
                                     self.container.frame.size.height - 10 - self.pageCtrl.frame.size.height,
                                     self.container.frame.size.width,
                                     self.pageCtrl.frame.size.height);
        
    self.pageCtrl.currentPage = self.currentIndex;
    
    
    
    self.pageIndicator.frame = CGRectMake((self.container.frame.size.width - self.pageIndicator.frame.size.width) / 2,
                                          self.container.frame.size.height - 50 - self.pageIndicator.frame.size.height,
                                          self.pageIndicator.frame.size.width,
                                          self.pageIndicator.frame.size.height);
    
}


- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }

    return _scrollView;
}

- (UIPageControl *)pageCtrl {
    if (_pageCtrl == nil) {
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageCtrl.userInteractionEnabled = NO;
        _pageCtrl.numberOfPages = PAGE_TOTAL_COUNT;
        _pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
        _pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    
    }

    return _pageCtrl;
}

- (GPageIndicator *)pageIndicator {
    if (_pageIndicator == nil) {
        _pageIndicator = [[GPageIndicator alloc] initWithFrame:CGRectZero];
        _pageIndicator.userInteractionEnabled = NO;
        _pageIndicator.numberOfPages = PAGE_TOTAL_COUNT;
    }
    return _pageIndicator;
}


#pragma mark - Carousel
/**
 为了实现无限轮播效果
 当 data 元素数量超过 1 个的时候
 在 ScrollView 的首尾，分别额外添加了 1 个页面
 所以 ScrollView 的页数，是 data 元素数 + 2
 */
- (NSInteger)getDataIndexFromViewIndex:(NSInteger)viewIndex {
    NSInteger dataCount = PAGE_TOTAL_COUNT;
    // 元素不超过一个，没有添加额外页面，所以 dataIndex 和 viewIndex 相同
    if (dataCount <= 1) {
        return viewIndex;
    }

    // 如果 viewIndex 超过 data 最大的 index + 2，认为出错，返回 0
    if (viewIndex - (dataCount - 1) > 2) {
        return 0;
    }

    if (viewIndex == 0) {
        return dataCount - 1;
    } else if (viewIndex == dataCount + 1) {
        return 0;
    } else {
        return viewIndex - 1;
    }
}

- (NSInteger)getViewIndexFromDataIndex:(NSInteger)dataIndex {
    NSInteger dataCount = PAGE_TOTAL_COUNT;

    // 元素不超过一个，没有添加额外页面，所以 dataIndex 和 viewIndex 相同
    if (dataCount <= 1) {
        return dataIndex;
    }

    return dataIndex + 1;
}

/**
 调整到合适位置
 */
- (void)adjustScrollView {
    NSInteger adjustViewIndex = [self getViewIndexFromDataIndex:self.currentIndex];
    NSInteger oldOffsetX = self.scrollView.contentOffset.x;
    NSInteger newOffsetX = self.scrollView.frame.size.width * adjustViewIndex;
    if (newOffsetX != oldOffsetX) {
        self.scrollView.contentOffset = CGPointMake(newOffsetX, 0);
    }
}

/**
 尝试启动自动轮播
 */
- (void)tryStartAutoCarousel {
    // 组件拖动中
    if (self.draggingFlag) {
        return;
    }

    // 只有一个元素，不自动轮播
    if (PAGE_TOTAL_COUNT <= 1) {
        return;
    }

    // 已经启动，不重复启动
    if (self.carouselRunningFlag) {
        return;
    }
    self.carouselRunningFlag = YES;

    NSLog(@"startAutoCarousel");
    // 因为第一次启动的时间特殊性，MMTimer无法满足，用 performSelector 配合
    [self performSelector:@selector(turnPageImmediatelyAndInitTimer)
               withObject:nil
               afterDelay:CAROUSEL_INTERVAL
                  inModes:[NSArray arrayWithObjects:NSDefaultRunLoopMode, NSRunLoopCommonModes, nil]];
    [self.pageIndicator autoFillCurrent:0.0 duration:CAROUSEL_INTERVAL * 1000];
}

/**
 关闭自动轮播
 */
- (void)stopAutoCarousel {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(turnPageImmediatelyAndInitTimer) object:nil];
    [self.autoCarouselTimer invalidate];
    self.autoCarouselTimer = nil;
    self.carouselRunningFlag = NO;
    self.pageIndicator.progressOfCurrent = 1.0;
}

/**
 立即翻页，并且初始化计时器
 */
- (void)turnPageImmediatelyAndInitTimer {
    NSLog(@"turnPageImmediatelyAndInitTimer");
    [self.autoCarouselTimer invalidate];
    self.autoCarouselTimer = nil;
    self.autoCarouselTimer = [NSTimer scheduledTimerWithTimeInterval:(CAROUSEL_INTERVAL + CAROUSEL_ANIMATION_DURATION)
                                                              target:self
                                                            selector:@selector(turnPage) userInfo:nil repeats:YES];

    // 保证 timer 在 ScrollView 滑动的时候正常运行
    [[NSRunLoop currentRunLoop] addTimer:self.autoCarouselTimer forMode:NSRunLoopCommonModes];

    // 立即执行一次
    [self.autoCarouselTimer fire];
}

/**
 翻页
 */
- (void)turnPage {
    if (PAGE_TOTAL_COUNT <= 1) {
        return;
    }

    UInt32 currentViewIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    UInt32 nextViewIndex = currentViewIndex + 1;

    if (nextViewIndex >= self.viewArray.count) {
        return;
    }

    NSInteger newOffsetX = self.scrollView.frame.size.width * nextViewIndex;

    self.turnPageAnimatingFlag = YES;
    [UIView animateWithDuration:CAROUSEL_ANIMATION_DURATION
    delay:0.0f
    options:UIViewAnimationOptionCurveEaseInOut
    animations:^{
        [self.scrollView setContentOffset:CGPointMake(newOffsetX, 0) animated:NO];
    }
    completion:^(BOOL finished) {
        self.turnPageAnimatingFlag = NO;
        [self.pageIndicator autoFillCurrent:0.0 duration:CAROUSEL_INTERVAL * 1000];
        [self scrollViewDidEndScrollingAnimation:self.scrollView];
    }];
    
    [self.pageIndicator autoNextPage:(currentViewIndex - 1)
                            duration:CAROUSEL_ANIMATION_DURATION * 1000
                 progressOfStartPage:1.0
                  progressOfNextPage:0.0];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UInt32 viewIndex = round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    NSInteger index = [self getDataIndexFromViewIndex:viewIndex];

    if (index >= PAGE_TOTAL_COUNT) {
        return;
    }
    if (index != self.pageCtrl.currentPage) {
        self.pageCtrl.currentPage = index;
    }
    
    if (!self.turnPageAnimatingFlag) {
        [self updatePageIndicatorByScrollView];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 用户拖动，关闭自动轮播
    self.draggingFlag = YES;
    [self stopAutoCarousel];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.draggingFlag = NO;
        [self tryStartAutoCarousel];
        
        [self updatePageIndicatorByScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:nil];
    uint32_t viewIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    NSInteger dataIndex = [self getDataIndexFromViewIndex:viewIndex];

    if (dataIndex >= PAGE_TOTAL_COUNT) {
        return;
    }
    uint32_t uLastIndex = self.currentIndex;
    self.currentIndex = (UInt32)dataIndex;
    if (uLastIndex != self.currentIndex) {
        self.pageCtrl.currentPage = self.currentIndex;
    }

    [self adjustScrollView];


    self.draggingFlag = NO;
    [self tryStartAutoCarousel];
    
    [self updatePageIndicatorByScrollView];
}

#pragma mark - GPageIndicator
- (void)updatePageIndicatorWithProgres:(CGFloat)progress {
    self.pageIndicator.progressOfTotal = progress;
}

- (void)updatePageIndicatorByScrollView {
    CGFloat progress = (self.scrollView.contentOffset.x / self.scrollView.frame.size.width) - 1.0;
    self.pageIndicator.progressOfTotal = progress;
}

@end
