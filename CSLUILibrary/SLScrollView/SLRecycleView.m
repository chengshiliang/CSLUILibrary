//
//  SLRecycleView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "SLRecycleView.h"
#import <SDWebImage/SDWebImage.h>
#import <CSLUILibrary/SLImageView.h>
#import <CSLUILibrary/SLScrollView.h>
#import <CSLUILibrary/SLLabel.h>
#import <CSLUILibrary/SLView.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLPageControl.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/UIViewController+SLBase.h>

@interface SLRecycleView() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL needRefresh;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic, strong) SLPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewArr;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SLRecycleView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initScrollView];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollView];
    }
    return self;
}
- (void)initScrollView {
    self.autoScroll = YES;
    self.manualScroll = YES;
    self.autoTime = 3.0f;
    self.bottomSpace = 15.0f;
    self.titleSpace = 10.0f;
    self.cellMargin = 0.0f;
    self.scrollView = [[SLScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor=[UIColor clearColor];
    [self addSubview:self.scrollView];
    self.viewArr=[NSMutableArray array];
    
    [[UIViewController sl_getCurrentViewController].navigationController.interactivePopGestureRecognizer requireGestureRecognizerToFail:self.scrollView.panGestureRecognizer];//手势冲突处理，此处目前不加也没问题
}

- (void)layoutSubviews {
    self.scrollView.frame = self.bounds;
    if (needRefresh) {
        [self startLoading];
    }
}

- (SLImageView *)imageView:(NSString *)imageUrl {
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    SLImageView *imageView = [[SLImageView alloc]init];
    if (self.verticalScroll) {
        imageView.frame = CGRectMake(0, 0, scrollWidth, scrollHeight-self.cellMargin);
    } else {
        imageView.frame = CGRectMake(0, 0, scrollWidth-self.cellMargin, scrollHeight);
    }
    if ([imageUrl hasPrefix:@"http://"] || [imageUrl hasPrefix:@"https://"]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.placeHolderImage];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
    } else {
        [imageView sl_setImage:[UIImage imageNamed:imageUrl]];
    }
    return imageView;
}

- (SLLabel *)label:(NSString *)title {
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    SLLabel *label = [[SLLabel alloc]init];
    if (self.showTitle) {
        label.text = [title blankString];
    }
    label.textColor = self.titleColor ?: SLUIHexColor(0x333333);
    label.font = self.titleFont ?: SLUINormalFont(15.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = self.breakMode;
    CGFloat height = 0;
    if (self.breakMode <= 1 ) {
        label.numberOfLines = 0;
        height = [title heightWithFont:label.font width:scrollWidth];
    } else {
        label.numberOfLines = 1;
        height = 20;
    }
    if (self.verticalScroll) {
        label.frame = CGRectMake(0, scrollHeight-height-self.bottomSpace-self.titleSpace, scrollWidth, height);
    } else {
        label.frame = CGRectMake(0, scrollHeight-height-self.bottomSpace-self.titleSpace, scrollWidth-self.cellMargin, height);
    }
    return label;
}

- (void)startLoading {
    if (needRefresh == NO) {
        needRefresh = YES;
    }
    [self.viewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewArr removeAllObjects];
    [self.timer invalidate];
    [self.pageControl removeFromSuperview];
    if (self.imageDatas.count == 0) return;
    if (self.showTitle && self.imageDatas.count != self.titleDatas.count) return;
    self.autoScroll = self.imageDatas.count > 1 && self.autoScroll;
    self.manualScroll = self.imageDatas.count > 1 && self.manualScroll;
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    if (self.imageDatas.count == 1) {
        SLView *view = [[SLView alloc]init];
        if (self.verticalScroll) {
            view.frame = CGRectMake(0, self.cellMargin*1.0/2, scrollWidth, scrollHeight-self.cellMargin);
        } else {
            view.frame = CGRectMake(self.cellMargin*1.0/2, 0, scrollWidth-self.cellMargin, scrollHeight);
        }
        [view addSubview:[self imageView:self.imageDatas[0]]];
        [view addSubview:[self label:self.titleDatas[0]]];
        [self.viewArr addObject:view];
        [self.scrollView addSubview:view];
        [self.scrollView setContentSize:CGSizeMake(scrollWidth , scrollHeight)];
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, scrollWidth, scrollHeight) animated:NO];
        self.scrollView.scrollEnabled = NO;
        return;
    }
    
    for (NSInteger i = 0; i < self.imageDatas.count; i++) {
        SLView *view=[[SLView alloc]init];
        if (self.verticalScroll) {
            view.frame = CGRectMake(0, scrollHeight * (i +1) + self.cellMargin*1.0/2, scrollWidth, scrollHeight-self.cellMargin);
        } else {
            view.frame = CGRectMake(scrollWidth * (i +1) + self.cellMargin*1.0/2, 0, scrollWidth-self.cellMargin, scrollHeight);
        }
        [view addSubview:[self imageView:self.imageDatas[i]]];
        [view addSubview:[self label:self.titleDatas[i]]];
        [self.viewArr addObject:view];
        [self.scrollView addSubview:view];
    }
    
    SLView *firstView = [[SLView alloc]init];
    if (self.verticalScroll) {
        firstView.frame = CGRectMake(0, self.cellMargin*1.0/2, scrollWidth, scrollHeight-self.cellMargin);
    } else {
        firstView.frame = CGRectMake(self.cellMargin*1.0/2, 0, scrollWidth-self.cellMargin, scrollHeight);
    }
    [firstView addSubview:[self imageView:self.imageDatas[self.imageDatas.count - 1]]];
    [firstView addSubview:[self label:self.titleDatas[self.titleDatas.count - 1]]];
    [self.viewArr addObject:firstView];
    [self.scrollView addSubview:firstView];
    SLView *endView = [[SLView alloc]init];
    if (self.verticalScroll) {
        endView.frame = CGRectMake(0, scrollHeight * (self.imageDatas.count +1) + self.cellMargin*1.0/2, scrollWidth, scrollHeight-self.cellMargin);
    } else {
        endView.frame = CGRectMake(scrollWidth * (self.imageDatas.count +1) + self.cellMargin*1.0/2, 0, scrollWidth-self.cellMargin, scrollHeight);
    }
    [endView addSubview:[self imageView:self.imageDatas[0]]];
    [endView addSubview:[self label:self.titleDatas[0]]];
    [self.viewArr addObject:endView];
    [self.scrollView addSubview:endView];
    CGSize contentSize = CGSizeMake(scrollWidth * (self.imageDatas.count + 2), scrollHeight);
    if (self.verticalScroll) contentSize = CGSizeMake(scrollWidth, scrollHeight* (self.imageDatas.count + 2));
    [self.scrollView setContentSize:contentSize];
    [self.scrollView scrollRectToVisible:CGRectMake(self.verticalScroll ? 0 : scrollWidth, self.verticalScroll ? scrollHeight : 0, scrollWidth, scrollHeight) animated:NO];
    if (self.autoScroll) {
        self.timer = [NSTimer timerWithTimeInterval:self.autoTime target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
    if (self.hidePageControl || self.imageDatas.count < 2) return;
    
    self.pageControl = [[SLPageControl alloc] initWithFrame:CGRectMake((scrollWidth-100)/2,scrollHeight-15-self.bottomSpace-(self.verticalScroll?self.cellMargin*1.0/2:0), 100, 15)];
    if(!self.manualScroll){
        for(UIGestureRecognizer *g in self.scrollView.gestureRecognizers){
            [self.scrollView removeGestureRecognizer:g];
        }
    }
    if(self.indicatorImage){ // 自定义图片
        self.pageControl.indicatorImage = self.indicatorImage;
        if (self.currentIndicatorImage) {
            self.pageControl.currentIndicatorImage = self.currentIndicatorImage;
        } else {
            self.pageControl.currentIndicatorImage = self.indicatorImage;
        }
    }else{
        self.pageControl.currentPageIndicatorTintColor = self.currentIndicatorColor ?: SLUIHexColor(0xffffff);
        self.pageControl.pageIndicatorTintColor = self.indicatorColor ?: SLUIHexColor(0x999999);
    }
    
    if(self.pageSize.width!=0&&self.pageSize.height!=0){
        self.pageControl.frame=CGRectMake((scrollWidth-self.pageSize.width)/2,scrollHeight-self.bottomSpace , self.pageSize.width, 15);
    }
    self.pageControl.numberOfPages = self.imageDatas.count;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
}

- (void)startLoadingByIndex:(NSInteger)index {
    [self startLoading];
    self.currentPage = index;
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    if(!self.verticalScroll){
        [self.scrollView scrollRectToVisible:CGRectMake(scrollWidth * (index + 1), 0, scrollWidth, scrollHeight) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(0,scrollHeight * (index + 1), scrollWidth, scrollHeight) animated:YES];
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    NSInteger page;
    if(!self.verticalScroll){
        page= floor((self.scrollView.contentOffset.x - scrollWidth/(self.imageDatas.count+2))/scrollWidth) + 1;
    }else{
        page= floor((self.scrollView.contentOffset.y - scrollHeight/(self.imageDatas.count+2))/scrollHeight) + 1;
    }
    page --;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    NSInteger currentPage = floor((self.scrollView.contentOffset.x - scrollWidth/ (self.imageDatas.count+2)) / scrollWidth) + 1;
    if (self.verticalScroll) currentPage= floor((self.scrollView.contentOffset.y - scrollHeight/ (self.imageDatas.count+2)) / scrollHeight) + 1;
    CGFloat startX = self.verticalScroll ? 0 : scrollWidth * self.imageDatas.count;
    CGFloat startY = self.verticalScroll ? scrollHeight * self.imageDatas.count : 0;
    if (currentPage == 0) {
        if (self.indexChangeBlock) {
            self.indexChangeBlock(self.imageDatas.count-1);
        }
        [self.scrollView scrollRectToVisible:CGRectMake(startX, startY, scrollWidth, scrollHeight) animated:NO];
    }else if(currentPage == self.imageDatas.count + 1){
        if (self.indexChangeBlock){
            self.indexChangeBlock(0);
        }
        startX = self.verticalScroll ? 0 : scrollWidth;
        startY = self.verticalScroll ? scrollHeight : 0;
        [self.scrollView scrollRectToVisible:CGRectMake(startX, startY, scrollWidth,scrollHeight) animated:NO];
    }else{
        if (self.indexChangeBlock){
            self.indexChangeBlock(currentPage-1);
        }
    }
    
    if (!self.autoScroll) return;
    self.timer = [NSTimer timerWithTimeInterval:self.autoTime target:self selector:@selector(runTimePage)userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.autoScroll) return;
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    CGFloat startX = self.verticalScroll ? 0 : scrollWidth * self.imageDatas.count;
    CGFloat startY = self.verticalScroll ? scrollHeight * self.imageDatas.count : 0;
    if (self.currentPage == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(startX, startY, scrollWidth, scrollHeight) animated:NO];
    }else if(self.currentPage == self.imageDatas.count){
        startX = self.verticalScroll ? 0 : scrollWidth;
        startY = self.verticalScroll ? scrollHeight : 0;
        [self.scrollView scrollRectToVisible:CGRectMake(startX, startY, scrollWidth,scrollHeight) animated:NO];
    }
}

- (void)turnPage:(NSInteger)page {
    self.currentPage = page;
    CGFloat scrollWidth = self.scrollView.bounds.size.width;
    CGFloat scrollHeight = self.scrollView.bounds.size.height;
    if(!self.verticalScroll){
        [self.scrollView scrollRectToVisible:CGRectMake(scrollWidth * (page + 1), 0, scrollWidth,scrollHeight) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(0,scrollHeight * (page + 1), scrollWidth,scrollHeight) animated:YES];
    }
}

- (void)runTimePage {
    NSInteger page = self.pageControl.currentPage;
    page ++;
    [self turnPage:page];
}

@end
