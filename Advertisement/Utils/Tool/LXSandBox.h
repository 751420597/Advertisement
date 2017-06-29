//
//  LXSandBoxTool.h
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXSandBox : NSObject

#pragma mark - Get Path

// 获取Home目录路径,可见子目录(3个):Documents、Library、tmp
+ (NSString *)getHomePath;

// 获取程序目录
+ (NSString *)getAppPath;

// 获取Documents目录路径，应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
+ (NSString *)getHomeDocumentsPath;

// 获取Library文件夹路径，存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
+ (NSString *)getHomeLibraryPath;

// 获取Library/Caches文件夹路径
+ (NSString *)getHomeLibraryCachesPath;

// 获取Library/Preferences文件夹路径
+ (NSString *)getHomeLibraryPreferencesPath;

// 获取tmp文件夹路径，存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除或者iPhone在重启时会丢弃所有的tmp文件
+ (NSString *)getHomeTmpPath;


#pragma mark - About Directory And File

// 判断创建文件夹是否成功
+ (BOOL)createDirectoryAtPath:(NSString *)path;

// 判断是否存在文件夹
+ (BOOL)isExistsDirectoryAtPath:(NSString *)path;

// 删除文件
+ (BOOL)deleteFielWithFileURL:(NSURL *)url;

// 判断文件是否存在
+ (BOOL)isExistsFileAtPath:(NSString *)path;

// 获取文件夹下所有文件名
+ (NSArray *)fileNamesAtDirectoryPath:(NSString *)directoryPath;

// 获取指定路径下文件的大小
+ (unsigned long long)getFileSizeAtPath:(NSString *)filePath;

// 创建下载文件夹
+ (BOOL)createDownloadDirectoryAtPath:(NSString *)downloadPath;

// 防止iCloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;


@end
