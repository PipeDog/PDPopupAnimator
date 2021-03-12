//
//  PDActionSheetController.m
//  PDPopupAnimator_Example
//
//  Created by liang on 2021/3/12.
//  Copyright © 2021 liang. All rights reserved.
//

#import "PDActionSheetController.h"
#import "PDAlertAction+Internal.h"
#import <PDPopupWidget.h>

static inline CGFloat PDGetActionSheetCellHeight(PDAlertActionStyle style) {
    return (style == PDAlertActionStyleCancel ? 60.f : 50.f);
}

@interface PDActionSheetCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;

- (void)setTitle:(NSString *)title;
- (void)setBottomLineHidden:(BOOL)isHidden;

@end

@implementation PDActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInitializeConfiguration];
        [self createViewHierarchy];
        [self layoutContentViews];
    }
    return self;
}

- (void)setupInitializeConfiguration {
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)createViewHierarchy {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.bottomLine];
}

- (void)layoutContentViews {
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [self.titleLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomLine.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [self.bottomLine.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
        [self.bottomLine.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
        [self.bottomLine.heightAnchor constraintEqualToConstant:1.f / [UIScreen mainScreen].scale],
    ]];
}

#pragma mark - Setter Methods
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title ?: @"";
}

- (void)setBottomLineHidden:(BOOL)isHidden {
    self.bottomLine.hidden = isHidden;
}

#pragma mark - Getter Methods
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomLine;
}

@end

@interface PDActionSheetController () <UITableViewDelegate, UITableViewDataSource, PDPopupControllerWidget>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<PDAlertAction *> *internalActions;

@end

@implementation PDActionSheetController

PD_REGISTER_POPUP_WIDGET(actionSheetController, PDActionSheetController)

- (instancetype)initWithStyle:(PDAlertControllerStyle)style {
    self = [super initWithStyle:PDAlertControllerStyleActionSheet];
    if (self) {
        _internalActions = [NSMutableArray array];
        _autoDismissWhenHitAction = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addAction:(PDAlertAction *)action {
    [_internalActions addObject:action];
}

#pragma mark - Override Methods
- (UIView *)contentView {
    return self.tableView;
}

- (CGRect)contentViewRect {
    CGFloat cornerRadius = 10.f;
    CGFloat bottomHeight = 0;
    if (@available(iOS 11, *)) {
        bottomHeight = self.view.safeAreaInsets.bottom;
    }
    
    CGFloat height = cornerRadius + bottomHeight;
    for (PDAlertAction *action in [self.internalActions copy]) {
        height += PDGetActionSheetCellHeight(action.style);
    }
    
    CGFloat top = CGRectGetHeight([UIScreen mainScreen].bounds) - height + cornerRadius;
    return CGRectMake(0.f, top, CGRectGetWidth([UIScreen mainScreen].bounds), height);
}

#pragma mark - UITableViewDelegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.internalActions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDAlertAction *action = self.internalActions[indexPath.row];
    return PDGetActionSheetCellHeight(action.style);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PDActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PDActionSheetCell class])];
    if (!cell) {
        cell = [[PDActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PDActionSheetCell class])];
    }
    PDAlertAction *action = self.internalActions[indexPath.row];
    [cell setTitle:action.title];
    [cell setBottomLineHidden:(indexPath.row == self.internalActions.count - 1)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.autoDismissWhenHitAction) {
        [self dismissWithAnimated:YES];
    }

    PDAlertAction *action = self.internalActions[indexPath.row];
    !action.handler ?: action.handler(action);
}

#pragma mark - Getter Methods
- (NSArray<PDAlertAction *> *)actions {
    return [self.internalActions copy];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.layer.cornerRadius = 10.f;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

@end
