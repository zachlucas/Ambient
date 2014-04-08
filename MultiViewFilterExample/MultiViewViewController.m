#import "MultiViewViewController.h"

@implementation MultiViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textViewDidBeginEditing:(UITextView *)mainTextView {
    NSLog(@"did start typing");
    if ([_textView.text isEqualToString:@"start typing..."]){
        _textView.text = @"";
        _textView.textColor = [UIColor blackColor];
    }
}

#pragma mark - View lifecycle

- (void)loadView
{
    NSLog(@"view loadeed");
    
    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];	
	UIView *primaryView = [[[UIView alloc] initWithFrame:mainScreenFrame] autorelease];
    primaryView.backgroundColor = [UIColor blackColor];
	self.view = primaryView;

    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    [videoCamera rotateCamera];
    
    CGFloat halfWidth = round(mainScreenFrame.size.width / 2.0);
    CGFloat halfHeight = round(mainScreenFrame.size.height / 2.0);    
    view1 = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, halfWidth, halfHeight)];
    view2 = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 570)];
    view3 = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, halfHeight, halfWidth, halfHeight)];
    view4 = [[GPUImageView alloc] initWithFrame:CGRectMake(halfWidth, halfHeight, halfWidth, halfHeight)];
    //[self.view addSubview:view1];
    view2.alpha = 0.7;
    [self.view addSubview:view2];
    //[self.view addSubview:view3];
    //[self.view addSubview:view4];
    /*
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:22.0f];
    textField.textColor = [UIColor whiteColor];
    textField.backgroundColor = [UIColor grayColor];
    textField.placeholder = @"enter text";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //textField.delegate = self;
    [self.view addSubview:textField];*/
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10,200,300,300)];
    textView.backgroundColor = [UIColor clearColor];
    //textView.text = @"start typing...";
    textView.textColor = [UIColor whiteColor];
    textView.font =[UIFont fontWithName:@"Helvetica-LightOblique" size:24.0f];
    [self.view addSubview:textView];
    
    GPUImageFilter *filter1 = [[[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"Shader2"] autorelease];
    GPUImageFilter *filter2 = [[[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"Shader2"] autorelease];
    GPUImageSepiaFilter *filter3 = [[[GPUImageSepiaFilter alloc] init] autorelease];
    GPUImageGaussianBlurFilter *filterGaussian = [[[GPUImageGaussianBlurFilter alloc] init] autorelease];
    filterGaussian.blurRadiusInPixels = 16;
    
    
    GPUImageBrightnessFilter *filterBrightness = [[[GPUImageBrightnessFilter alloc]init] autorelease];
    filterBrightness.brightness = .2;
    
    //GPUImagePolkaDotFilter *filterPolka = [[[GPUImagePolkaDotFilter alloc] init] autorelease];
    //filterPolka.dotScaling = 10;

//    GPUImageBrightnessFilter *filter1 = [[GPUImageBrightnessFilter alloc] init];
//    GPUImageBrightnessFilter *filter2 = [[GPUImageBrightnessFilter alloc] init];
//    [filter2 setBrightness:0.5];
//    GPUImageBrightnessFilter *filter3 = [[GPUImageBrightnessFilter alloc] init];
//    [filter3 setBrightness:-0.5];

//    GPUImageSobelEdgeDetectionFilter *filter1 = [[GPUImageSobelEdgeDetectionFilter alloc] init];
//    GPUImageSobelEdgeDetectionFilter *filter2 = [[GPUImageSobelEdgeDetectionFilter alloc] init];
//    [filter2 setTexelHeight:(1.0 / 1024.0)];
//    [filter2 setTexelWidth:(1.0 / 768.0)];
//    GPUImageSobelEdgeDetectionFilter *filter3 = [[GPUImageSobelEdgeDetectionFilter alloc] init];
//    [filter3 setTexelHeight:(1.0 / 200.0)];
//    [filter3 setTexelWidth:(1.0 / 400.0)];
    
//    GPUImageTransformFilter *filter1 = [[GPUImageTransformFilter alloc] init];
//    GPUImageTransformFilter *filter2 = [[GPUImageTransformFilter alloc] init];
//    CATransform3D perspectiveTransform = CATransform3DIdentity;
//    perspectiveTransform.m34 = 0.4;
//    perspectiveTransform.m33 = 0.4;
//    perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
//    perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.5, 0.0, 1.0, 0.0);
//    [filter2 setTransform3D:perspectiveTransform];
//    GPUImageTransformFilter *filter3 = [[GPUImageTransformFilter alloc] init];
//    [filter3 setAffineTransform:CGAffineTransformMakeRotation(1.0)];
    
    // For thumbnails smaller than the input video size, we currently need to make them render at a smaller size.
    // This is to avoid wasting processing time on larger frames than will be displayed.
    // You'll need to use -forceProcessingAtSize: with a zero size to re-enable full frame processing of video.
    [filter1 forceProcessingAtSize:view2.sizeInPixels];
    [filter2 forceProcessingAtSize:view3.sizeInPixels];
    [filter3 forceProcessingAtSize:view4.sizeInPixels];
    [filterGaussian forceProcessingAtSize:view2.sizeInPixels];
    //[filterPolka forceProcessingAtSize:view2.sizeInPixels];
    //[filterBrightness forceProcessingAtSize:view2.sizeInPixels];

    [videoCamera addTarget:view1];
    [videoCamera addTarget:filter1];
    //[filter1 addTarget:view2];
    [videoCamera addTarget:filter2];
    [filter2 addTarget:view3];
    [videoCamera addTarget:filter3];
    [filter3 addTarget:view4];
    [videoCamera addTarget:filterGaussian];
    [filterGaussian addTarget:view2];
    //[videoCamera addTarget:filterPolka];
    //[filterPolka addTarget:view2];
    //[videoCamera addTarget:filterBrightness];
    //[filterBrightness addTarget:view2];
    
    [videoCamera startCameraCapture];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
