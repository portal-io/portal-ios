//
//  Jockey.h
//  JockeyJS
//
//  Copyright (c) 2013, Tim Coulter
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ JockeyHandler)(NSDictionary *payload);
typedef void (^ JockeyAsyncHandler)(UIWebView *webView, NSDictionary *payload, void (^complete)(NSString *json));

@interface Jockey : NSObject

/**
 注册一个监听事件

 @param eventName 命令名称
 @param handler   接收到命令响应事件
 */
- (void)on:(NSString *)eventName perform:(JockeyHandler)handler;

/**
 注册一个监听事件
 
 @param eventName 命令名称
 @param handler   接收到命令响应事件 完毕后可回调
 */
- (void)on:(NSString *)eventName performAsync:(JockeyAsyncHandler)handler;

/**
 销毁监听事件
 
 @param eventName 所要销毁的命令名称
 */
- (void)off:(NSString *)eventName;

/**
 销毁所有监听事件
 */
- (void)offAllEvent;

/**
 向js发送一个无回调的命令

 @param eventName 命令名称
 @param payload   所传递参数 JSON对象 NSDictionary NSArray NSString
 @param webView   self.webView
 */
- (void)send:(NSString *)eventName withPayload:(id)payload toWebView:(UIWebView *)webView;

/**
 向js发送一个无回调的命令
 
 @param eventName 命令名称
 @param payload   所传递参数 JSON对象 NSDictionary NSArray NSString
 @param webView   self.webView
 @param complete  命令执行完毕回调
 */
- (void)send:(NSString *)eventName withPayload:(id)payload toWebView:(UIWebView *)webView perform:(void(^)(void))complete;

/**
 向js发送一个无回调的命令
 
 @param eventName 命令名称
 @param payload   所传递参数 JSON对象 NSDictionary NSArray NSString
 @param webView   self.webView
 @param complete  命令执行完毕回调并附带参数
 */
- (void)send:(NSString *)eventName withPayload:(id)payload toWebView:(UIWebView *)webView performWithPayload:(void (^)(NSDictionary *))complete;

- (BOOL)webView:(UIWebView *)webView withUrl:(NSURL *)url;

@end
