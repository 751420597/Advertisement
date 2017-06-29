//
//  LXSandBoxTool.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXSandBox.h"

@implementation LXSandBox

#pragma mark - Get Path

// 获取Home目录路径,可见子目录(3个):Documents、Library、tmp
+ (NSString *)getHomePath {
    return NSHomeDirectory();
}

// 获取程序目录
+ (NSString *)getAppPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

// 获取Documents目录路径，应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
+ (NSString *)getHomeDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

// 获取Library文件夹路径，存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
+ (NSString *)getHomeLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

// 获取Library/Caches文件夹路径
+ (NSString *)getHomeLibraryCachesPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

// 获取Library/Preferences文件夹路径
+ (NSString *)getHomeLibraryPreferencesPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

// 获取tmp文件夹路径，存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除或者iPhone在重启时会丢弃所有的tmp文件
+ (NSString *)getHomeTmpPath {
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

#pragma mark - About Directory And File

// 判断创建文件夹是否成功
+ (BOOL)createDirectoryAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (!(isDirectory && isExist)) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else {
        return (isDirectory && isExist);
    }
    
    return NO;
}

// 判断是否存在文件夹
+ (BOOL)isExistsDirectoryAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return (isDirectory && isExist);
}

// 删除文件
+ (BOOL)deleteFielWithFileURL:(NSURL *)url; {
    BOOL isSuccess = NO;
    
    isSuccess = [[NSFileManager defaultManager] removeItemAtURL:url error:nil];

    return isSuccess;
}

// 判断文件是否存在
+ (BOOL)isExistsFileAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

// 获取文件夹下所有文件名
+ (NSArray *)fileNamesAtDirectoryPath:(NSString *)directoryPath {
    if (![[self class] isExistsDirectoryAtPath:directoryPath]) {
        return nil;
    }
    
    NSError * error;
    NSArray * fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        return nil;
    }
    
    return fileNames;
}

// 获取指定路径下文件的大小
+ (unsigned long long)getFileSizeAtPath:(NSString *)filePath {
    if (![[self class] isExistsFileAtPath:filePath]) {
        return 0;
    }
    unsigned long long fileSize = 0;
    fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    
    return fileSize;
}

// 创建下载文件夹
+ (BOOL)createDownloadDirectoryAtPath:(NSString *)downloadPath {
    BOOL isDirectory = NO;
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory];
    if (!(isDirectory && isExist)) {
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:downloadPath]];
        return [[NSFileManager defaultManager] createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else {
        return (isDirectory && isExist);
    }
    
    return NO;
}

// 防止iCloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}

@end
