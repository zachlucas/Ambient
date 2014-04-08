#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface MultiViewViewController : UIViewController <UITextViewDelegate>
{
    GPUImageView *view1, *view2, *view3, *view4;
    GPUImageVideoCamera *videoCamera;
}

@property (strong, nonatomic) IBOutlet UITextView *textView;

-(void)textChanged:(NSNotification*)notification;

@end
