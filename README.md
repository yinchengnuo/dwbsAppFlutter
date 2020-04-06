# 大卫博士手机APP

使用 Flutter 对大卫博士手机App的一次尝试性重构。没有复杂的动画和炫酷的效果，有的只是对Flutter的各个 Widget 及 API 的熟悉和摸索。

因为公司年前使用的是 uni-app 来开发手机APP，在开发过程中逐渐感觉到混合开发的弊端，年前就在了解 Flutter。过年疫情期间，由于项目时间比较自由。我便在家开始使用 Flutter 对原有的混合 APP 进行重构，重构过程中越来越发觉 Flutter 是个好东西，不仅开发效率极高，虽然有之前混合开发的经验，但是整体开发下来只用了 25 天左右，而且打出的包运行效率极高，远非混合开发能比，同时开发体验也很好。但是在我完成两个版本的手机 APP 开发之后，到公司上班后却被告之手机APP项目搁浅！不过学到了就是自己的，于是决定把重构这个版本开源，希望能遇到各路大神能对此指点一二，万分感谢。

[APK下载](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/dwbs.apk)

## APP 预览图

![APP 预览图](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/0.jpg)

## 变量命名规范

|  变量   | 规范  |
|  ----  | ----  |
| 页面 | Page + 大驼峰 |
| 接口函数 | api + 大驼峰 |
| 状态管理类  | Provider + 大驼峰 |

## 预览图

![0](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/0.jpg)

![1](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/1.jpg)

![2](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/2.jpg)

![3](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/3.jpg)

![4](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/4.jpg)

![5](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/5.jpg)

![6](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/6.jpg)

![7](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/7.jpg)

![8](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/8.jpg)

![9](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/9.jpg)

![10](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/0.jpg)

![11](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/11.jpg)

![12](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/12.jpg)

![13](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/13.jpg)

![14](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/14.jpg)

![15](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/15.jpg)

![16](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/16.jpg)

![17](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/17.jpg)

![18](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/18.jpg)

![19](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/19.jpg)

![20](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/20.jpg)

![21](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/21.jpg)

![22](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/22.jpg)

![23](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/23.jpg)

![24](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/24.jpg)

![25](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/25.jpg)

![26](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/26.jpg)

![27](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/27.jpg)

![28](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/28.jpg)

![29](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/29.jpg)

![30](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/30.jpg)

![31](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/31.jpg)

![32](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/32.jpg)

![33](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/33.jpg)

![34](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/34.jpg)

![35](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/35.jpg)

![36](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/36.jpg)

![37](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/37.jpg)

![38](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/38.jpg)

![39](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/39.jpg)

![40](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/40.jpg)

![41](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/41.jpg)

![42](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/42.jpg)

![43](https://github.com/yinchengnuo/dwbsAppFlutter/blob/master/md/43.jpg)
