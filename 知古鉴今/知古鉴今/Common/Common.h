//
//  Common.h
//  知古鉴今
//
//  Created by qingyun on 16/6/19.
//  Copyright © 2016年 张小东. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define ScreenW [UIScreen mainScreen].bounds.size.width

//请求数据的基础URL
#define BASEURL @"http://zkapi.adline.com.cn:8086/public/v1/zake/list.json"
//参数一览
/*cid
 *7     新闻
 *8     奇趣发现
 *10    财经
 *11    科技
 *14    娱乐
 *15    时尚
 *17    生活精选
 */
#define oneNews 7
#define Find 8
#define Money 10
#define Science 11
#define Funny 14
#define Fashion 15
#define Life 17

#endif /* Common_h */
