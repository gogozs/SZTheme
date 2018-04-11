//
//  ViewController.m
//  SZTheme
//
//  Created by songzhou on 2018/4/11.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "ViewController.h"
#import "SZThemeManager.h"

@interface SZSampleViewControllerView : UIView

@property (nonatomic) UIButton *btn1;

@end

@implementation SZSampleViewControllerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // add subviews
        UIView *view1 = [UIView new];
        view1.sztheme_id = @"#firstname";
        [self addSubview:view1];
        
        UISegmentedControl *sgc1 = [[UISegmentedControl alloc] initWithItems:@[@"item1", @"item2", @"item3"]];
        [self addSubview:sgc1];
        
        _btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btn1 setTitle:@"Button" forState:UIControlStateNormal];
        [self addSubview:_btn1];
        
        // layout
        view1.frame = CGRectMake(0, 0, 400, 400);
        sgc1.frame = CGRectMake(8, 40, 200, 20);
        [_btn1 sizeToFit];
        _btn1.frame = CGRectMake(8, 60, CGRectGetWidth(_btn1.bounds), CGRectGetHeight(_btn1.bounds));

//        sgc1.tintColor = [UIColor redColor];
    }
    return self;
}

@end

@interface ViewController ()

@property (nonatomic) SZSampleViewControllerView *view;

@end

@implementation ViewController

@dynamic view;
- (void)loadView {
    self.view = [SZSampleViewControllerView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.btn1 addTarget:self action:@selector(changeTheme) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SEL recursiveDesc = NSSelectorFromString(@"recursiveDescription");
    IMP imp = [self.view methodForSelector:recursiveDesc];
    
    NSString *(*func)(UIView *, SEL) = (void *)imp;
    
    __unused NSString *ret = func(self.view, recursiveDesc);
    
    [[SZThemeManager sharedManager] changeToTheme:[SZThemeManager sharedManager].lightTheme fromView:self.view];

}

- (void)changeTheme {
    if ([SZThemeManager sharedManager].currentTheme == [SZThemeManager sharedManager].lightTheme) {
        [[SZThemeManager sharedManager] changeToTheme:[SZThemeManager sharedManager].darkTheme fromView:self.view];
    } else {
        [[SZThemeManager sharedManager] changeToTheme:[SZThemeManager sharedManager].lightTheme fromView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
