//
//  RobotHead.h
//  ARkitFaceExample
//
//  Created by Wence on 2018/3/19.
//  Copyright © 2018年 ZOOM. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface RobotHead : SCNReferenceNode 

@property(nonatomic, assign)CGFloat originalJawY;
@property(nonatomic, strong)SCNNode *jawNode;
@property(nonatomic, strong)SCNNode *eyeLeftNode;
@property(nonatomic, strong)SCNNode *eyeRightNode;
@property(nonatomic, strong)SCNNode *textNode;
@property (nonatomic, strong) SCNNode *textNodeddddd;


@property (nonatomic, strong) SCNNode *leftRing;
@property (nonatomic, strong) SCNNode *rightRing;


- (void)update:(ARFaceAnchor *)withFaceAnchor;

@end
