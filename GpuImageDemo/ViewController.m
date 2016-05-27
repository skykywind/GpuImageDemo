//
//  ViewController.m
//  GpuImageDemo
//
//  Created by AtronJia on 16/5/27.
//  Copyright © 2016年 Artron. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
@interface ViewController ()<UIImagePickerControllerDelegate>
{
    UIImage *originalImage;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)saveImage:(id)sender;
- (IBAction)filterButton:(id)sender;
- (IBAction)selectFromAlbum:(id)sender;
- (IBAction)selectFromCamera:(id)sender;

@end

@implementation ViewController
/**
    引入GPUImage时 1,把项目添加到工程里，
        2,设置5个系统库，
        3,TargetDependence和LinkBinaryWithLibraries引入GPUImage.a库
        4,otherlinkFlags:-ObjC,
        5,headersearchPaths: framework路径
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//保存图片到相册
- (IBAction)saveImage:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *alertTitle;
    NSString *alertMessage;
    
    if(!error) {
        alertTitle   = @"Image Saved";
        alertMessage = @"Image saved to photo album successfully.";
    }else{
        alertTitle   = @"Error";
        alertMessage = @"Unable to save to photo album.";
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",alertTitle);
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

//选择滤镜
- (IBAction)filterButton:(id)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"SelectFilter" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *buttonTitles = @[@"Grayscale", @"Sepia", @"Sketch", @"Pixellate", @"Color Invert", @"Toon", @"Pinch Distort", @"None"];
    for (int i = 0; i<buttonTitles.count; i++) {
        UIAlertAction *action= [UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",action.title);
            //添加滤镜
            GPUImageFilter *selectedFilter;
            
            switch (i) {
                case 0:
                    selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
                    break;
                case 1:
                    selectedFilter = [[GPUImageSepiaFilter alloc] init];
                    break;
                case 2:
                    selectedFilter = [[GPUImageSketchFilter alloc] init];
                    break;
                case 3:
                    selectedFilter = [[GPUImagePixellateFilter alloc] init];
                    break;
                case 4:
                    selectedFilter = [[GPUImageColorInvertFilter alloc] init];
                    break;
                case 5:
                    selectedFilter = [[GPUImageToonFilter alloc] init];
                    break;
                case 6:
                    selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
                    break;
                case 7:
                    selectedFilter = [[GPUImageFilter alloc] init];
                    break;
                default:
                    break;
            }
            
            UIImage *filteredImage = [selectedFilter imageByFilteringImage:originalImage];
            [self.imageView setImage:filteredImage];
            
            
        }];
        [alert addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)selectFromAlbum:(id)sender {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

- (IBAction)selectFromCamera:(id)sender {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
}
#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.saveButton.enabled = YES;
    self.filterButton.enabled = YES;
    
    originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.imageView setImage:originalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}



@end
