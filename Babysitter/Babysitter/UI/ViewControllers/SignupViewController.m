    //
//  SignupViewController.m
//  Babysitter
//
//  Created by Torrent on 10/13/15.
//  Copyright © 2015 Donka. All rights reserved.
//

#import "SignupViewController.h"
#import "SignupViewController2.h"
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self setupUI];
    [self setupNavBar];
}

#pragma mark - UI methods
- (void)setupUI{
    // Make add image button as circle shape
    self.addImageButton.layer.cornerRadius = self.addImageButton.frame.size.height/2;
    self.addImageButton.layer.masksToBounds = YES;
    self.addImageButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.addImageButton.layer.shouldRasterize = YES;
    self.addImageButton.clipsToBounds = YES;
    
    self.containerView.layer.borderWidth = 0.7;
    self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.masksToBounds = YES;
}

- (void)setupNavBar {
    // Navbar color
    self.navigationController.navigationBar.tintColor = [UIColor offWhite];
    [self.navigationController setNavigationBarHidden:NO];

    // Adjust nav bar title based on current view identifier
    self.navigationController.navigationBar.topItem.title = SIGNUP_TITLE;
    // Set title
    self.title = SIGNUP_TITLE;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(goNext)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
}

/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Navigation
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goNext{

    if ([_passTxtField.text isEqualToString:_confPassTxtField.text]) {
        SignupViewController2 *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController2"];
        
        dest.email = _emailTxtField.text;
        dest.pass = _confPassTxtField.text;
        dest.imagePath = _filePath;
        
        [self.navigationController pushViewController:dest animated:YES];
    }else{
        [[AppDelegate sharedInstance] showAlertMessage:@"Warning" message:@"Please confirm the password again." buttonTitle:@"Ok"];
    }
}

#pragma mark - IBAction methods
- (IBAction)AddPhoto:(id)sender{
    self.cameraActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                       destructiveButtonTitle:@"Camera"
                                            otherButtonTitles:@"Photo Album", nil];
    
    // Show the actionsheet
    [self.cameraActionSheet showInView:self.view];
}

# pragma mark - getPicture
-(void)getPicture {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)getCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)checkForCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[AppDelegate sharedInstance] showAlertMessage:@"Error" message:@"Device has no camera" buttonTitle:@"OK"] ;        
    }else{
        [self getCamera];
    }
}

# pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imgToUpload = info[UIImagePickerControllerEditedImage];
    [self.addImageButton setBackgroundImage:_imgToUpload forState:UIControlStateNormal];
    
    // saving image as file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.filePath = [documentsDirectory stringByAppendingPathComponent:@"profile.png" ];
    NSData* data = UIImagePNGRepresentation(_imgToUpload);
    [data writeToFile:self.filePath atomically:YES];

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

# pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == _cameraActionSheet){
        switch (buttonIndex) {
            case 0:
                // launch camera
                [self checkForCamera];
                break;
            case 1:
                // load photo album
                [self getPicture];
                break;
            default:
                break;
        }
    }
}

#pragma mark - UITextField & Keyboard Delegates
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_emailTxtField resignFirstResponder];
    [_passTxtField resignFirstResponder];
    [_confPassTxtField resignFirstResponder];
    
    [self keyboardWillHide];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self keyboardWillShow];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self keyboardWillHide];
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self keyboardWillHide];
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0){
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0){
        //        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0){
        //        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0){
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp){
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= 100;
        
    }
    else{
        // revert back to the normal state.
        rect.origin.y += 100;
        
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

@end
