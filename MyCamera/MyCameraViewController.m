//
//  MyCameraViewController.m
//  MyCamera
//
//  Created by changhu on 13-8-1.
//  Copyright (c) 2013年 com.riambsoft. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "MyCameraViewController.h"

@interface MyCameraViewController ()

@end

@implementation MyCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    pickController = [[UIImagePickerController alloc] init];
    pickController.allowsEditing = NO;
    pickController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_pickButton release];
    [_imageView release];
    [super dealloc];
}
- (IBAction)pickImage:(id)sender {
    
    NSLog(@"click button");
    
    // 通过菜单打开照相机并开始拍照
//        UIActionSheet *popuQuery = [[UIActionSheet alloc] initWithTitle:@"Goooooo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo",@"Video",nil];
//    
//        popuQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [popuQuery showInView:self.view];
//        [popuQuery release];
    
//    //直接打开照相机并开始拍照
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        [pickController setSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *mediaType = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [pickController setMediaTypes:mediaType];
    }else {
        [pickController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
    }
    [self presentViewController:pickController animated:YES completion:nil];
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"click action sheet");
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@" ok ");
        
        [pickController setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        NSLog(@"not ok");
        
        [pickController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    if(buttonIndex == 0){
        [pickController setMediaTypes:[NSArray arrayWithObject:kUTTypeImage]];
    }else if(buttonIndex == 1){
        [pickController setMediaTypes:[NSArray arrayWithObject:kUTTypeMovie]];
    }
    [self presentModalViewController:pickController animated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"type is %@ ", [info objectForKey:@"UIImagePickerControllerMediaType"]);
    
    //判断是照片还是视频
    if([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]){
        NSLog(@" movie");
        CGSize pickerSize = CGSizeMake(picker.view.bounds.size.width, picker.view.bounds.size.height - 100);
        
        UIGraphicsBeginImageContext(pickerSize);
        
        [picker.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        _imageView.image = thumbnail;
        
    }else if([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]){
        
        //保存照片
        NSLog(@"image");
        
        UIImage *image  = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
        NSLog(@"save to photo album");
        
        //将照片在界面上显示
        _imageView.image = image;
        
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *)contextInfo{
    
    NSString *title;
    NSString *message;
    if(!error){
        title = @"Photo Saved!";
        message = @"The Photo has bean saved to your Photo Album";
    }else {
        title = NSLocalizedString(@"Error Saving Phtot", @"");
        message = [error description];
    }
    
    //弹出提醒框
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}


@end
