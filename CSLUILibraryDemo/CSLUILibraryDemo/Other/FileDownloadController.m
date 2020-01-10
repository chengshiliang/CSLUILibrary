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
        [[SLDownloadManager sharedManager]download:[NSURL URLWithString:url]
                                             state:^(SLDownloadState state) {
            NSLog(@"state %ld index %d", state, j);
        }
                                          progress:^(int64_t receivedSize, int64_t expectedSize, CGFloat progress) {
            StrongSelf;
            NSLog(@"progress %.2lf index %d", receivedSize*1.0/expectedSize, j);
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
    return @[@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"];
}

@end
