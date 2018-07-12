//
//  Jockey.m
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

#import "Jockey.h"

@interface Jockey ()

@property (strong, atomic) NSNumber *messageCount;
@property (strong, nonatomic) NSMutableDictionary *listeners;
@property (strong, nonatomic) NSMutableDictionary *callbacks;

- (void)triggerEventFromWebView:(UIWebView *)webView withData:(NSDictionary *)envelope;
- (void)triggerCallbackOnWebView:(UIWebView *)webView forMessage:(NSString *)messageId payload:(NSString *)payload;
- (void)triggerCallbackForMessage:(NSNumber*)messageId;

@end


@implementation Jockey

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.messageCount = @0;
        self.listeners = [NSMutableDictionary dictionary];
        self.callbacks = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - on

- (void)on:(NSString *)eventName perform:(JockeyHandler)handler
{
    void (^ extended)(UIWebView *webView, NSDictionary *payload, void (^ complete)()) = ^(UIWebView *webView, NSDictionary *payload, void(^ complete)(NSString *payload)) {
        handler(payload);
        complete(@"");
    };
    
    [self on:eventName performAsync:extended];
}

- (void)on:(NSString *)eventName performAsync:(JockeyAsyncHandler)handler
{
    NSDictionary *listeners = self.listeners;
    
    NSString *listener = [listeners objectForKey:eventName];
    
    if (listener) { NSLog(@"___Hibrid___ %@ 重复监听", eventName); }
    
    [self.listeners setValue:handler forKey:eventName];
}

#pragma mark - off

- (void)off:(NSString *)eventName {
    
    [self.listeners removeObjectForKey:eventName];
}

- (void)offAllEvent {
    
    [self.listeners removeAllObjects];
    [self.callbacks removeAllObjects];
}

#pragma mark - send

- (void)send:(NSString *)eventName withPayload:(NSDictionary *)payload toWebView:(UIWebView *)webView
{
    [self send:eventName withPayload:payload toWebView:webView perform:nil];
}

- (void)send:(NSString *)eventName withPayload:(NSDictionary *)payload toWebView:(UIWebView *)webView performWithPayload:(void (^)(NSDictionary *))complete
{
    NSNumber *messageId = self.messageCount;
    
    if (complete != nil) {
        [self.callbacks setValue:complete forKey:[messageId stringValue]];
    }
    
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *javascript = [NSString stringWithFormat:@"javascript:jsBridge.trigger(\"%@\", %ld, %@);", eventName, (long)[messageId integerValue], jsonString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [webView stringByEvaluatingJavaScriptFromString:javascript];
        
        self.messageCount = @([self.messageCount integerValue] + 1);
    });
    
//    NSLog(@"___Hibrid___ send: \"%@\" payload: %@", eventName, payload);
}

- (void)send:(NSString *)eventName withPayload:(NSDictionary *)payload toWebView:(UIWebView *)webView perform:(void (^)())complete {
    
    NSNumber *messageId = self.messageCount;
    
    if (complete != nil) {
        [self.callbacks setValue:complete forKey:[messageId stringValue]];
    }
    
    NSError *err;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *javascript = [NSString stringWithFormat:@"javascript:jsBridge.trigger(\"%@\", %ld, %@);", eventName, (long)[messageId integerValue], jsonString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [webView stringByEvaluatingJavaScriptFromString:javascript];
        
        self.messageCount = @([self.messageCount integerValue] + 1);
    });
    
//    NSLog(@"___Hibrid___ send: \"%@\" payload: %@", eventName, payload);
}

#pragma mark - 拦截代理

- (BOOL)webView:(UIWebView *)webView withUrl:(NSURL *)url
{
    if ([[url scheme] isEqualToString:@"jsbridge"] ) // jsbridge jockey
    {
        NSString *eventName = [url host];
        NSString *messageId = [[url path] substringFromIndex:1];
        NSString *query = [url query];
        NSString *jsonString = [query stringByRemovingPercentEncoding];
        
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
        
        if ([eventName isEqualToString:@"event"]) {
            
            [self triggerEventFromWebView:webView withData:dict];
            
        } else if ([eventName isEqualToString:@"callback"]) {
            
            [self triggerCallbackForMessage:@([messageId integerValue]) withData:dict];
        }
        
        return NO;
    }
    return YES;
}

#pragma mark - 私有方法

- (void)triggerEventFromWebView:(UIWebView *)webView withData:(NSDictionary *)envelope
{
    NSDictionary *listeners = self.listeners;
    
    NSString *messageId = [envelope objectForKey:@"id"];
    NSString *eventName = [envelope objectForKey:@"eventName"];
    
    NSDictionary *payload = [envelope objectForKey:@"payload"];
    
    NSLog(@"___Hibrid___ \"%@\" received, payload = %@", eventName, payload);
    
    JockeyAsyncHandler handler = [listeners objectForKey:eventName];
    
    if (handler) {
        __weak typeof(self)weakself = self;
        void (^complete)(NSString *json) = ^(NSString *json) {
            
            [weakself triggerCallbackOnWebView:webView forMessage:messageId payload:json];
        };
        
        handler(webView, payload, complete);
    } else {
        NSLog(@"___Hibrid___ event: %@, 未注册", eventName);
    }
}

- (void)triggerCallbackOnWebView:(UIWebView *)webView forMessage:(NSString *)messageId payload:(NSString *)json
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *javascript = @"";
        if (json.length==0) {
            javascript = [NSString stringWithFormat:@"javascript:jsBridge.triggerCallback(\"%@\");", messageId];
        }else{
            javascript = [NSString stringWithFormat:@"javascript:jsBridge.triggerCallback(\"%@\", %@);", messageId, json];
        }
        NSLog(@"______%@", javascript);
        [webView stringByEvaluatingJavaScriptFromString:javascript];
    });
}

- (void)triggerCallbackForMessage:(NSNumber *)messageId {
    NSString *messageIdString = [messageId stringValue];
    
    void (^ callback)() = [_callbacks objectForKey:messageIdString];
    
    if (callback != nil) {
        callback();
    }
    
    [_callbacks removeObjectForKey:messageIdString];
}

- (void)triggerCallbackForMessage:(NSNumber *)messageId withData:(NSDictionary *)envelope
{
    NSString *messageIdString = [messageId stringValue];
    
    void (^ callback)() = [_callbacks objectForKey:messageIdString];
    
    if (callback != nil) {
        callback(envelope);
    }
    
    [_callbacks removeObjectForKey:messageIdString];
}

@end
