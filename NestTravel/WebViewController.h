#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark macros

#pragma mark const

#pragma mark enum

#pragma mark typedef

#pragma mark Protocol

@interface WebViewController : UIViewController
#pragma mark Properties

@property(weak, nonatomic) IBOutlet UIWebView *webView;

@property(copy, nonatomic) NSURL *url;

#pragma mark Methods

@end