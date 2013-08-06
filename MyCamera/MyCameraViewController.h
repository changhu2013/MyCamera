//
//  MyCameraViewController.h
//  MyCamera
//
//  Created by changhu on 13-8-1.
//  Copyright (c) 2013年 com.riambsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    
    UIImagePickerController *pickController;
    
}

@property (retain, nonatomic) IBOutlet UIButton *pickButton;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)pickImage:(id)sender;

@end
