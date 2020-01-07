//
//  FileDownloadController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/7.
//  Copyright © 2020 csl. All rights reserved.
//

#import "FileDownloadController.h"

@interface FileDownloadController ()
@property (weak, nonatomic) IBOutlet SLProgressView *progress1;
@property (weak, nonatomic) IBOutlet SLProgressView *progress2;
@property (weak, nonatomic) IBOutlet SLProgressView *progress3;
@property (weak, nonatomic) IBOutlet SLProgressView *progress4;
@property (weak, nonatomic) IBOutlet SLProgressView *progress5;
@end

@implementation FileDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)down:(id)sender {
    WeakSelf;
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSString *url = self.dataArray[i];
        __block int j = i;
        [[SLDownloadManager sharedManager]download:url
                                             state:^(SLDownloadState state) {
            NSLog(@"state %ld j %d", state, j);
        }
                                          progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            StrongSelf;
            NSLog(@"progress %.2lf j %d", receivedSize*1.0/expectedSize, j);
            switch (j) {
                case 0:
                    [strongSelf.progress1 setProgress:receivedSize*1.0/expectedSize animated:YES];
                    break;
                case 1:
                    [strongSelf.progress2 setProgress:receivedSize*1.0/expectedSize animated:YES];
                    break;
                case 2:
                    [strongSelf.progress3 setProgress:receivedSize*1.0/expectedSize animated:YES];
                    break;
                case 3:
                    [strongSelf.progress4 setProgress:receivedSize*1.0/expectedSize animated:YES];
                    break;
                case 4:
                    [strongSelf.progress5 setProgress:receivedSize*1.0/expectedSize animated:YES];
                    break;
                default:
                    break;
            }
        }
                                        completion:^(BOOL isSuccess, NSString * _Nonnull filePath, NSError * _Nullable error) {
            
        }];
    }
}
- (IBAction)suspend:(id)sender {
    [[SLDownloadManager sharedManager]suspendAllDownloads];
}
- (IBAction)resume:(id)sender {
    [[SLDownloadManager sharedManager]resumeAllDownloads];
}
- (IBAction)cancel:(id)sender {
    [[SLDownloadManager sharedManager]cancelAllDownloads];
}
- (IBAction)delete:(id)sender {
    [[SLDownloadManager sharedManager]deleteAllFiles];
}

- (NSArray *)dataArray {
    return @[@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4",
    @"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4",
    @"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/20985849_722f981a5ce0fc6d2a5a4f40cb0327a5_3.mp4",
    @"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/27089192_abcedcf00b503195b7d09f2c91814ef2_3.mp4",
             @"http://tb-video.bdstatic.com/videocp/16514218_b3883a9f1e041a181bda58804e0a5192.mp4"];
}

@end
