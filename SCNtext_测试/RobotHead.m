//
//  RobotHead.m
//  ARkitFaceExample
//
//  Created by Wence on 2018/3/19.
//  Copyright © 2018年 ZOOM. All rights reserved.
//

#import "RobotHead.h"

@implementation RobotHead

- (instancetype)initWithURL:(NSURL *)referenceURL
{
    self = [super initWithURL:referenceURL];
    if (self) {
        [self load];
        _jawNode = [self childNodeWithName:@"jaw" recursively:YES];
        _eyeLeftNode = [self childNodeWithName:@"eyeLeft" recursively:YES];
        _eyeRightNode = [self childNodeWithName:@"eyeRight" recursively:YES];
        _originalJawY = _jawNode.position.y;
        _textNode = [self childNodeWithName:@"haha" recursively:YES];
        
        _rightRing = [self childNodeWithName:@"right" recursively:YES];
        _leftRing = [self childNodeWithName:@"left" recursively:YES];
        
        
      //  SCNPlane *plan = (SCNPlane *)_leftRing.geometry;
        
      //  plan.firstMaterial.diffuse = ;
        
        
    }
    return self;
}
-(void)setTextNodeddddd:(SCNNode *)textNodeddddd {
    _textNodeddddd = textNodeddddd;
}

- (void)update:(ARFaceAnchor *)withFaceAnchor
{
    NSDictionary *blendShapes= withFaceAnchor.blendShapes;
    CGFloat eyeBlinkLeft = [blendShapes[ARBlendShapeLocationEyeBlinkLeft] floatValue];
    CGFloat eyeBlinkRight = [blendShapes[ARBlendShapeLocationEyeBlinkRight] floatValue];
    CGFloat jawOpen = [blendShapes[ARBlendShapeLocationJawOpen] floatValue];
    _eyeLeftNode.scale = SCNVector3Make(_eyeLeftNode.scale.x, _eyeLeftNode.scale.y, 1 - eyeBlinkLeft);
    _eyeRightNode.scale = SCNVector3Make(_eyeRightNode.scale.x, _eyeRightNode.scale.y, 1 -eyeBlinkRight);
    SCNVector3 v1; SCNVector3 v2;
    [_jawNode getBoundingBoxMin:&v1 max:&v2];
    _jawNode.position =  SCNVector3Make(_jawNode.position.x, _originalJawY - (v2.y - v1.y) * jawOpen, _jawNode.position.z);
    
    SCNText *before = (SCNText *)_textNodeddddd.geometry;
    SCNText *after = (SCNText *)_textNode.geometry;
    after.string = before.string;
    after.materials = before.materials;
    after.font = before.font;
    
//      CGSize size = [after.string boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil].size;

    //_textNode.position = SCNVector3Make(_textNode.position.x - size.width/2, _textNode.position.y, _textNode.position.z);
   // _rightRing.position = SCNVector3Make(_textNode.position.x,-0.099, _textNode.position.z);


 
    

    
}

@end
