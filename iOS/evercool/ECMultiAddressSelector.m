//
// Created by guti on 10/17/13.
//
// No bugs for you!
//


#import "ECMultiAddressSelector.h"
#import "ECSetHomeViewController.h"
#import <AddressBookUI/AddressBookUI.h>


@interface ECMultiAddressSelector () <UIActionSheetDelegate>
@property(nonatomic, weak) ECSetHomeViewController *delegate;
@end

@implementation ECMultiAddressSelector

- (void)showAlertForAddresses:(NSArray *)addresses 
                       inView:(UIView *)view 
                 withDelegate:(ECSetHomeViewController *)delegate 
{
    self.delegate = delegate;
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Home"
                              delegate:self
                     cancelButtonTitle:nil
                destructiveButtonTitle:nil
                     otherButtonTitles:nil];
    
    self.addresses = addresses;

    for (CLPlacemark *address in addresses) {
        [self.actionSheet addButtonWithTitle:ABCreateStringWithAddressDictionary(address.addressDictionary, NO)];
    }

    NSInteger cancelIndex = [self.actionSheet addButtonWithTitle:@"Cancel"];
    self.actionSheet.cancelButtonIndex = cancelIndex;

    [self.actionSheet showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
        clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= self.addresses.count) return;
    
    NSLog(@"Tapped %@", self.addresses[buttonIndex]);

    [self.delegate setAddressTo:self.addresses[buttonIndex]];
}


@end