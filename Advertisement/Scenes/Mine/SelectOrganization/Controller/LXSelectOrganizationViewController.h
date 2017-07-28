//
//  LXSelectOrganizationViewController.h
//  Advertisement
//
//  Created by zuolixin on 2017/6/15.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXRootTableViewController.h"

#import "LXOrganizaitonModel.h"

typedef void(^SelectOrganization)(LXOrganizaitonModel *);

@interface LXSelectOrganizationViewController : LXRootTableViewController

@property (nonatomic, copy) SelectOrganization selectOrganizationBlock;
@property (nonatomic)BOOL enbleEidts;
@property (nonatomic,strong)NSDictionary *params;
@property (nonatomic,strong)NSString *objID;
@end
