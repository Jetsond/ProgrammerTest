//
//  ViewController.m
//  SCNtext_测试
//
//  Created by iOS on 2018/10/17.
//  Copyright © 2018 Jerry. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "ZHPickView/ZHPickView.h"
#import "MBProgressHUD+JDragon/MBProgressHUD+JDragon.h"
#import "ARViewController.h"


#define createWeakSelf        __weak typeof(self) weakSelf = self

@interface ViewController ()<ARSCNViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFild;
@property (nonatomic, strong) SCNNode *node;
@property (nonatomic, strong) SCNText *text3d;
@property (nonatomic, strong) NSMutableDictionary *dic;

@property (nonatomic, strong) SCNView *scnView;
@property (nonatomic, strong) SCNMaterial *textMaterial;

@property (nonatomic, strong) NSMutableArray *fontArray;
@property (nonatomic, strong) NSString *customFontName;

@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@end

@implementation ViewController

- (IBAction)arCustomAction:(id)sender {
    ARViewController *arVC = [[ARViewController alloc] init];
    arVC.textNodeddddd = _node;
    [self.navigationController pushViewController:arVC animated:YES];
    
    
}

-(SCNView *)scnView {
    if (!_scnView) {
        self.scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        [self.view addSubview:_scnView];
//        self.scnView.scene = scene;
        self.scnView.backgroundColor = [UIColor blackColor];
        self.scnView.allowsCameraControl = YES;//打开相机控制
        self.scnView.autoenablesDefaultLighting = YES;//自动启动默认光源
        self.scnView.showsStatistics = NO;//不显示统计数据
    }
    return _scnView;
}

-(SCNText *)text3d {
    if (!_text3d) {
        _text3d = [[SCNText alloc] init];
        _text3d.wrapped = YES;
        _text3d.materials = @[self.textMaterial];
        _text3d.alignmentMode = kCAAlignmentLeft;
        _text3d.truncationMode = kCATruncationEnd;
        _text3d.extrusionDepth = 2;//文字深度
        // _text3d.chamferRadius = 0.1;//添加倒角
        _text3d.flatness = 0.1;//一个数字，用于确定文本几何的准确性或平滑度。
        [self.text3d setContainerFrame:CGRectMake(0, 0, 500, 300)];
        
    }
    return _text3d;
}

-(SCNNode *)node {
    if (!_node) {
        _node = [SCNNode node];
        self.node.geometry = self.text3d;
    
    }
    
    return _node;
}
-(SCNMaterial *)textMaterial {
    if (!_textMaterial) {
        self.textMaterial = [SCNMaterial material];
        self.textMaterial.name = @"test";
        self.textMaterial.reflective.contents = [UIImage imageNamed:@"30_antwerp_station_tracks_.bmp"];
        self.textMaterial.diffuse.contents = [UIImage imageNamed:@"nfhgf"];
        
    }
    return _textMaterial;
}
- (IBAction)choseFont:(id)sender {
    
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:_fontArray title:@"FontTitle"];
    [pickView showPickView:self];
    createWeakSelf;
    pickView.block = ^(NSString *selectedStr)
    {
        weakSelf.customFontName = selectedStr;
        if ([weakSelf.textFild.text isEqualToString:@""]) {
            [MBProgressHUD showErrorMessage:@"请先输入文字"];
            return;
        }
        [weakSelf.choseBtn setTitle:[NSString stringWithFormat:@"选择字体：%@",selectedStr] forState:UIControlStateNormal];
        [weakSelf drowWithText:weakSelf.textFild.text FontName:weakSelf.customFontName];
    };
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"超仔的测试AR项链Demo";
    _dic = [NSMutableDictionary dictionary];
    _fontArray = [NSMutableArray array];
    _customFontName = @"";
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isDownloadFont"]) {
        _dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Fonts"];
        _fontArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"FontNames"];
    }else {
        for (NSString *fontfamilyname in [UIFont familyNames])
        {
            [_fontArray addObject:fontfamilyname];
            [[NSUserDefaults standardUserDefaults] setValue:_fontArray forKey:@"FontNames"];
            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
                {
                    [_dic setObject:fontName forKey:fontfamilyname];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDownloadFont"];
                    [[NSUserDefaults standardUserDefaults] setValue:_dic forKey:@"Fonts"];
            }
        }
    }
    

}
- (IBAction)chifmAction:(id)sender {
    [_textFild resignFirstResponder];
    [self drowWithText:self.textFild.text FontName:_customFontName];
}

- (void)drowWithText:(NSString *)text FontName:(NSString *)fontName {
    
    SCNScene *scene = [SCNScene scene];
  //  NSString *text = @"Soufeel";
    self.text3d.string = text;
    ///[self getPriceAttribute:@"¥4000/月"]; //HoboStd //Hobo Std //Dry Brush //Advertising Scrip //Angelica
    self.text3d.font = [fontName isEqualToString:@""]?[UIFont fontWithName:_dic[@"Angelica"] size:20]:[UIFont fontWithName:_dic[fontName] size:20];
    [scene.rootNode addChildNode:self.node];
    self.scnView.scene = scene;
    
     self.textFild.delegate = self;
    
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_textFild resignFirstResponder];
    [self drowWithText:self.textFild.text FontName:_customFontName];
    
    return YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    
}

@end
