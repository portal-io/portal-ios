
# 微鲸VR-iOS App技术文档

### 相关文档传送门

[微鲸VR产品PRD](http://172.29.200.30:9999/app/#g=1&p=whaleyvr_prd)

[微鲸VR Teambition](https://www.teambition.com/project/5754eb7d58901fe9311700ed/tasks/scrum/5a55f9c9276d1441f95f30c5)

[微鲸后台cms测试服管理地址](http://vrtest-cms.aginomoto.com/newVR-portal/login)

[微鲸后台接口文档地址](https://git.moretv.cn/vr-service/doc/tree/master/%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3/%E6%8E%A5%E5%8F%A3)

[微鲸VR 测试 禅道地址](http://172.29.1.74/snailvr/www/bug-browse-2-0-bySearch-128.html)

### 项目采用分层架构，融合RAC的MVVM开发模式。

总体分为三层（不建议分更多的层级），层级关系从上到下依次为：业务层、封装层、功能库。（之后再有变动，可即时补充或修改）

- 业务层（与业务结合紧密，变动较为频繁）：WVRAccount、WVRDanmu、WVRProgram、WVRPay、WVRPlayer、WVRPlayerUI、WVRLauncher、WVRCurrency、WVRGift、WVRSetting

- 封装层（对功能库的进一步封装，利于维护，不频繁变动）：WVRBI、WVRNet、WVRMediator、WVRHybrid（Web）、WVRShare、WVRUIFrame、WVRCache、WVRContext、WVRParser、WVRUtil（工具类）、WVRWidght（UI组件和UIFrame有些重叠）、WVRPlayerFramework

- 功能库（基本为第三方库）：ReactNative、AFNetworking、SDWebImage、YYModel、Masonry、FMDB、Toast、JPush、UmengShare、SAMKeychain、CocoaHTTPServer、ReactiveObjC、WVRNetModel

[分层架构](https://github.com/a1049145827/Resources/raw/master/WhaleyVR_iOS_%20Architecture.png)

### 功能介绍

1. 业务层

- AppDelegateExtend：AppDelegate的类扩展，存在于主工程中，防止AppDelegate类过于庞大，且分工明确，利于维护。主要包含了App启动流程、推送等逻辑。
- WVRAccount：微鲸账户，与用户状态相关，包含登录、注册、忘记密码等操作。
- WVRDanmu：弹幕功能模块，与播放页面相关，目前只存在于直播，集成长链接。
- WVRProgram：节目，主要负责与蓝精灵CMS对接，各种节目、列表展示页面，半屏、全屏播放页面，目前承载的业务逻辑较重。
- WVRPay：支付，集成微信支付宝（由于苹果限制，暂时下线该功能），苹果内购，未来将支持鲸币购买，与鲸币打通。
- WVRPlayer：播放器封装模块，提供播放器与播放页面、用户交互的API，结合设备、App、页面的状态做出响应。
- WVRLauncher：App启动流程控制，广告、海报、版本更新提醒等，window的根视图控制器TabBarController也在此处。
- WVRBridge：存在于与Launcher合并后的工程中，与launcher进行消息互通、数据交互。
- WVRCurrency：鲸币，微鲸虚拟币，可通过微信、支付宝、内购等渠道获得，可用来直播打赏、购买节目观看券。
- WVRGift：礼物，用于直播打赏，需要消耗鲸币。
- WVRSetting：设置页面及其相关功能实现。

2. 封装层

- WVRBI：根据业务需要对数据进行拆分组合，json化后存入数据库。
- WVRNet：网络层封装，提供网络请求积累，使用的时候将其子类化。
- WVRMediator：中介者，由于业务层中的模块需要互不引用，所以引入中介者，提供API暴露出来，每个模块做一个分类。
- WVRHybrid（Web）：实现App内部H5页面与原生交互，获取信息及调用API。
- WVRShare：分享功能实现，对UMShare封装。
- WVRUIFrame：UI组件。
- WVRCache：缓存功能实现。
- WVRContext：App上下文环境、设备信息、用户信息存储。
- WVRParser：电视猫片源链接解析库。
- WVRUtil（工具类）：MD5等工具类。
- WVRWidght（UI组件和UIFrame有些重叠）：基础UI组件。
- WVRPlayerFramework：江龙开发的集成播放和渲染的播放器SDK。

3. 功能库

- ReactNative：RN，大前端混合开发库。
- AFNetworking：网络请求库，上层有其封装。
- SDWebImage：图片下载库，上层有其封装。
- YYModel：JSON、字典、Model互相转化的工具库。
- Masonry：Layout工具库。
- FMDB：SQLite工具库。
- Toast：Toast工具库，上层有对其封装。
- JPush：推送库。
- UmengShare：社会化分享库。
- SAMKeychain：利用苹果的“钥匙串”存储一些私密的，应用删除后还要保留的数据。
- CocoaHTTPServer：本地代理网络库，用于播放缓存的视频，将TS片封装成m3u8视频流。
- ReactiveObjC：RAC，响应式开发库。
- WVRNetModel：网络层数据转换Model，由于用到的地方比较多，所以下沉到最底层。


-------------------- 分割线 以下为庆波整理 -------------------------


## 拆分出字符串资源文件，尺寸宏文件

## UI模块，像直播view封装成一个类型的view


## 工程模块话，按照功能划分，目前想到的是用model来联系两个模块；这样模块之后方便后面把每个模块都拆分成一个工程，然后使用frameWork依赖。

* one step：现在目前的工程中用大文件夹区分出模块，并逐渐创建model来作为模块之间的通信


## playerHelper 代理中添加暂停，start等UI代理供外部更新UI使用

## 工程中的所有弹框统一到一个模块下，使用统一接口调用（不使用工具类，使用全局对象对象（eg：单例），在appDelegate中初始化）,，这样做可以保证全局样式统一，并且可以设配不同的横竖屏界面.


---------------------分割线-------------------------
分工程模块在review之后再进行


模块之间依赖：通过protolo作为中价 eg：支付模块增加一个protocol层，支付模块去实现，外部调用protocol层

业务逻辑的一些状态量，不要散落在相关类中，可以做一个策略protocol封装起来



上报：
支付：
socket：



