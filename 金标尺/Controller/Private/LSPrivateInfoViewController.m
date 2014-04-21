//
//  LSPrivateInfoViewController.m
//  金标尺
//
//  Created by Jiao Liu on 14-4-20.
//  Copyright (c) 2014年 Jiao Liu. All rights reserved.
//

#import "LSPrivateInfoViewController.h"

@interface LSPrivateInfoViewController ()

@end

@implementation LSPrivateInfoViewController

@synthesize table;
@synthesize imgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的资料管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // backBtn
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 280)];
    table.dataSource = self;
    table.delegate = self;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    if (IOS_VERSION >= 7.0) {
        table.separatorInset = UIEdgeInsetsZero;
    }
    
    // logoutBtn
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, table.frame.origin.y + table.frame.size.height + 20, SCREEN_WIDTH - 20, 41)];
    UIImage *img = [UIImage imageNamed:@"my_logout"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [logoutBtn setBackgroundImage:img forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - handleBtnClicked
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logoutBtnClicked
{
    
}

- (void)imgLoadBtnClicked
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - pick img
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
            pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            [self presentViewController:pickController animated:YES completion:^{
                
            }];
        }
            break;
        case 1:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
            pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            [self presentViewController:pickController animated:YES completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!originImage) {
            originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UIGraphicsBeginImageContext(CGSizeMake(60, 60));
        [originImage drawInRect:CGRectMake(0, 0, 60, 60)];
        imgView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 75;
    }
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        switch (indexPath.row) {
            case 0:
            {
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 60, 60)];
                imgView.image = [UIImage imageNamed:@"default_header@2x.jpg"];
                imgView.layer.borderWidth = 1;
                imgView.layer.borderColor = [UIColor whiteColor].CGColor;
                imgView.clipsToBounds = YES;
                [Cell.contentView addSubview:imgView];
                
                UIButton *loadImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(Cell.frame.size.width - 100, 26.5, 62.5, 22)];
                [loadImgBtn setBackgroundImage:[UIImage imageNamed:@"my_img_upload"] forState:UIControlStateNormal];
                [loadImgBtn setTitle:@"重新上传" forState:UIControlStateNormal];
                [loadImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [loadImgBtn addTarget:self action:@selector(imgLoadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                loadImgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [Cell.contentView addSubview:loadImgBtn];
            }
                break;
            case 1:
            {
                Cell.textLabel.text = @"用户名";
                Cell.textLabel.textColor = [UIColor lightGrayColor];
                
                Cell.detailTextLabel.text = @"Formin";
                Cell.detailTextLabel.textColor = RGB(69, 111, 158);
            }
                break;
            case 2:
            {
                Cell.textLabel.text = @"手机号码";
                Cell.textLabel.textColor = [UIColor lightGrayColor];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"12647811251(未验证)"];
                [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(69, 111, 158) range:NSMakeRange(0, 11)];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11, 5)];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 11)];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:11] range:NSMakeRange(11, 5)];
                Cell.detailTextLabel.attributedText = attrStr;
            }
                break;
            case 3:
            {
                Cell.textLabel.text = @"电子邮箱";
                Cell.textLabel.textColor = [UIColor lightGrayColor];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"6976543219@QQ.COM(未验证)"];
                [attrStr addAttribute:NSForegroundColorAttributeName value:RGB(69, 111, 158) range:NSMakeRange(0, 17)];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(17, 5)];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 17)];
                [attrStr addAttribute:NSFontAttributeName value:[UIFont italicSystemFontOfSize:11] range:NSMakeRange(17, 5)];
                Cell.detailTextLabel.attributedText = attrStr;
            }
                break;
            case 4:
            {
                Cell.textLabel.text = @"QQ号";
                Cell.textLabel.textColor = [UIColor lightGrayColor];
                
                Cell.detailTextLabel.text = @"34143143";
                Cell.detailTextLabel.textColor = RGB(69, 111, 158);
            }
                break;
            case 5:
            {
                Cell.textLabel.text = @"登陆密码修改";
                Cell.textLabel.textColor = [UIColor lightGrayColor];
                Cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                
                UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, SCREEN_WIDTH - 20, 0.5)];
                separator.backgroundColor = [UIColor lightGrayColor];
                [Cell.contentView addSubview:separator];
            }
                break;
                
            default:
                break;
        }
    }
    
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 20)];
    label.text = @"  我的资料管理";
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH - 20, 0.5)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [label addSubview:separator];
    
    return label;
}

@end
