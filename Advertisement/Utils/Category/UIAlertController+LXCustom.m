//
//  UIAlertController+LXCustom.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/9.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "UIAlertController+LXCustom.h"

@implementation UIAlertController (LXCustom)

//actions = "<YYClassPropertyInfo: 0x17009e410>";
//attributedMessage = "<YYClassPropertyInfo: 0x17009e500>";
//attributedTitle = "<YYClassPropertyInfo: 0x17009e4b0>";
//contentViewController = "<YYClassPropertyInfo: 0x17009e550>";
//coordinatedActionPerformingDelegate = "<YYClassPropertyInfo: 0x17009e280>";
//debugDescription = "<YYClassPropertyInfo: 0x174098100>";
//description = "<YYClassPropertyInfo: 0x174093740>";
//effectAlpha = "<YYClassPropertyInfo: 0x17009df10>";
//hasPreservedInputViews = "<YYClassPropertyInfo: 0x17009e0a0>";
//hash = "<YYClassPropertyInfo: 0x17009e8c0>";
//indexesOfActionSectionSeparators = "<YYClassPropertyInfo: 0x17009dbf0>";
//message = "<YYClassPropertyInfo: 0x17009e870>";
//preferredAction = "<YYClassPropertyInfo: 0x17009e780>";
//preferredStyle = "<YYClassPropertyInfo: 0x17009e460>";
//previewInteractionController = "<YYClassPropertyInfo: 0x17009db00>";
//styleProvider = "<YYClassPropertyInfo: 0x17009e5a0>";
//superclass = "<YYClassPropertyInfo: 0x174096b70>";
//systemProvidedGestureRecognizer = "<YYClassPropertyInfo: 0x17009e230>";
//temporaryAnimationCoordinator = "<YYClassPropertyInfo: 0x17009dab0>";
//textFields = "<YYClassPropertyInfo: 0x17009e7d0>";
//title = "<YYClassPropertyInfo: 0x17009e820>";

//{
//    "__alertController" = "<YYClassIvarInfo: 0x17005dd60>";
//    "__descriptiveText" = "<YYClassIvarInfo: 0x17005db50>";
//    "__interfaceActionRepresentation" = "<YYClassIvarInfo: 0x17005dd30>";
//    "__representer" = "<YYClassIvarInfo: 0x17005dd00>";
//    "_checked" = "<YYClassIvarInfo: 0x17005d940>";
//    "_contentViewController" = "<YYClassIvarInfo: 0x17005dbb0>";
//    "_enabled" = "<YYClassIvarInfo: 0x17005d910>";
//    "_handler" = "<YYClassIvarInfo: 0x17005da60>";
//    "_image" = "<YYClassIvarInfo: 0x17005dac0>";
//    "_imageTintColor" = "<YYClassIvarInfo: 0x17005d970>";
//    "_isPreferred" = "<YYClassIvarInfo: 0x17005d8b0>";
//    "_keyCommandInput" = "<YYClassIvarInfo: 0x17005dc40>";
//    "_keyCommandModifierFlags" = "<YYClassIvarInfo: 0x17005dca0>";
//    "_shouldDismissHandler" = "<YYClassIvarInfo: 0x17005daf0>";
//    "_simpleHandler" = "<YYClassIvarInfo: 0x17005da90>";
//    "_style" = "<YYClassIvarInfo: 0x17005da30>";
//    "_title" = "<YYClassIvarInfo: 0x17005d790>";
//    "_titleTextAlignment" = "<YYClassIvarInfo: 0x17005d880>";
//    "_titleTextColor" = "<YYClassIvarInfo: 0x17005d9d0>";
//}

- (void)lx_setTitleWithAttributes:(NSMutableDictionary *)attributeDictionary {
    id myMessage = [self valueForKey:@"title"];
    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithString:myMessage attributes:attributeDictionary];
    [self setValue:myString forKey:@"attributedTitle"];
}

- (void)lx_setMessageWithAttributes:(NSMutableDictionary *)attributeDictionary {
    id myMessage = [self valueForKey:@"message"];
    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithString:myMessage attributes:attributeDictionary];
    [self setValue:myString forKey:@"attributedMessage"];
}

- (void)lx_setActionTitleWithChangeString:(NSString *)string color:(UIColor *)color {
    id myMessage = [self valueForKey:@"actions"];
    
    for (UIAlertAction *aciton in myMessage) {
        if ([string isEqualToString:aciton.title]) {
            [aciton setValue:color forKey:@"_titleTextColor"];
        }
    }
}

@end
