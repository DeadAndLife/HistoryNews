//
//  DataBaseFile.h
//  01-数据持久化作业
//
//  Created by qingyun on 16/6/20.
//  Copyright © 2016年 QingYun. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef DataBaseFile_h
#define DataBaseFile_h

//数据库名称
#define BaseFileName @"News.db"
//创建表
#define createTabel @"create table if not exists News(date text,thumbnail_pic text,id integer,source text,title text, url text,category text);create table if not exists Find(date text,thumbnail_pic text,id integer,source text,title text, url text,category text);create table if not exists Money(date text,thumbnail_pic text,id integer,source text,title text, url text,category text);create table if not exists Science(date text,thumbnail_pic text,id integer,source text,title text, url text,category text);create table if not exists Funny(date text,thumbnail_pic text,id integer,source text,title text, url text,category text);create table if not exists Fashion(date text,thumbnail_pic text,id integer,source text,title text, url text,category text);create table if not exists Life(date text,thumbnail_pic text,id integer,source text,title text, url text,category text);"

//插入数据
#define INSERT_HOMELIST_SQL(name) [NSString stringWithFormat:@"insert into %@ values(:date,:thumbnail_pic,:id,:source,:title,:url,:category)",name]

//查询所有的数据
#define SELECT_HOMELIST_ALL(name) [NSString stringWithFormat:@"select * from %@",name]

//删除数据
#define Delete_HOMELIST(name) [NSString stringWithFormat:@"delete from %@",name]

#endif /* DataBaseFile_h */
