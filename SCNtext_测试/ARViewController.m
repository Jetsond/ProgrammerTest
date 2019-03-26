//
//  ARViewController.m
//  SCNtext_测试
//
//  Created by iOS on 2018/10/24.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import "ARViewController.h"
#import "RobotHead.h"

@interface ARViewController ()<ARSCNViewDelegate, ARSessionDelegate,SCNNodeRendererDelegate>
@property (weak, nonatomic) IBOutlet ARSCNView *sceneView;

@property(nonatomic, strong) RobotHead *robotHead;
@property(nonatomic, strong) dispatch_queue_t serialQueue;

@property (assign, nonatomic) CGFloat scale;//记录上次手势结束的放大倍数
@property (assign, nonatomic) CGFloat realScale;//当前手势应该放大的倍数
@property (assign, nonatomic) CGFloat eulerX;//记录上次手势结束的滑动的距离
@property (assign, nonatomic) CGFloat realeulerX;//当前手势应该滑动的距离
@end

@implementation ARViewController

- (void)setupFaceNodeContent:(SCNNode *)node
{
    [node.childNodes enumerateObjectsUsingBlock:^(SCNNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParentNode];
    }];
    [node addChildNode:_robotHead];
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    dispatch_async(_serialQueue, ^{
        [self setupFaceNodeContent:node];
    });
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARFaceAnchor *)anchor
{
    [_robotHead update:anchor];
}

#pragma mark - SCNNodeRendererDelegate

- (void)renderNode:(SCNNode *)node renderer:(SCNRenderer *)renderer arguments:(NSDictionary<NSString *, id> *)arguments
{
    NSLog(@"%d",(int)renderer.renderingAPI);
    
}
-(void)setTextNodeddddd:(SCNNode *)textNodeddddd {
    _textNodeddddd = textNodeddddd;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scale = _robotHead.textNode.scale.x;
    self.eulerX = 1;
    _serialQueue = dispatch_queue_create("com.example.apple-samplecode.ARKitFaceExample.serialSceneKitQueue", 0);
    NSString *url = [[NSBundle mainBundle] pathForResource:@"robotHead" ofType:@"scn" inDirectory:nil];
    NSURL *url1 = [NSURL fileURLWithPath:url];
    _robotHead =  [RobotHead referenceNodeWithURL:url1];
    _robotHead.rendererDelegate = self;
    _robotHead.textNodeddddd = _textNodeddddd;
    
    
    _sceneView.delegate = self;
    _sceneView.session.delegate = self;
    _sceneView.automaticallyUpdatesLighting = true;
  //  _sceneView.debugOptions = SCNDebugOptionShowWireframe ; //网格
  //  scnView.debugOptions = SCNDebugOptionShowLightInfluences  光源位置
    [self.view addSubview:_sceneView];
    
    
    UIPinchGestureRecognizer *tap = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest:)];
    [_sceneView addGestureRecognizer:tap];
    
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [_sceneView addGestureRecognizer:pan];
    
}

//增加手势可以放大缩小模型
- (void)tapTest:(UIPinchGestureRecognizer *)tap {
    
    self.realScale = self.scale + (tap.scale - 1);
    
//    if (self.realScale > 3.6) {//设置最大放大倍数
//        self.realScale = 3.6;
//    }else if (self.realScale <2.4){//最小放大倍数
//        self.realScale = 2.4;
//    }
    _robotHead.textNode.scale = SCNVector3Make(_realScale, _realScale, _realScale);
    
    if (tap.state == UIGestureRecognizerStateEnded){//当结束捏合手势时记录当前图片放大倍数
        
        self.scale = self.realScale;
        
    }
    
}

- (ARSession *)session
{
    return _sceneView.session;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ARFaceTrackingConfiguration *configuration = [[ARFaceTrackingConfiguration alloc] init];
    configuration.lightEstimationEnabled = YES;
    [[self session] runWithConfiguration:configuration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.sceneView.session pause];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _sceneView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
