//
// Created by guti on 10/17/13.
//
// No bugs for you!
//


#import <Foundation/Foundation.h>

@class ECSetHomeViewController;

@interface ECMultiAddressSelector : NSObject

@property(nonatomic, strong) NSArray *addresses;
@property(nonatomic, strong) UIActionSheet *actionSheet;

- (void)showAlertForAddresses:(NSArray *)addresses inView:(UIView *)view withDelegate:(ECSetHomeViewController *)delegate;

@end