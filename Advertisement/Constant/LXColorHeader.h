//
//  LXColorHeader.h
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#ifndef LXColorHeader_h
#define LXColorHeader_h

// RGB
#define LXRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LXGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

// 随机色生成
#define LXRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)

// Hex颜色
#define LXColorHex(value) [UIColor colorWithRed:((value&0xFF0000)>>16)/255.0 green:((value&0xFF00)>>8)/255.0 blue:(value&0xFF)/255.0 alpha:1.0]

// 具体颜色
#define LXTabbarBackgroundColor      LXColorHex(0xf8f8f8)
#define LXMainColor                  LXColorHex(0x2CB3AC)
#define LXNavigaitonBarTitleColor    LXColorHex(0xFFFFFF)
#define LXVCBackgroundColor          LXColorHex(0xF5F5F5)
#define LXCellBorderColor            LXColorHex(0xE5E5E5)

#endif /* LXColorHeader_h */
