//
// Created by yoni on 10/17/13.
//
// \( ﾟ◡ﾟ)/
//


#import "ECUtils.h"


@implementation ECUtils

+ (void)displayNotificationAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

@end