import { Message } from 'umi';

# 调试

除了使用浏览器的调试工具来完成开发中的调试外，Umi 还推荐以下调试方式来协助项目的调试。

## 调试 dev 产物

如果你需要在 dev 阶段调试项目的构建产物，以 `umi.js` 举例。先将原来的 `umi.js` 下载到当前项目根目录下。根据调试需要进行编辑后，刷新浏览器，项目使用的 `umi.js` 就替换成了根目录下的 `umi.js` 文件。调试完毕需要恢复就直接删除根目录的 `umi.js` 即可。

举例：
```bash
# 下载当前项目的 umi.js
$curl http://127.0.0.1:8000/umi.js -O

# 增加想调试的内容，举例增加 "debug!!!" 弹窗
$ echo -e  '\n;alert("debug!!!");\n' >> umi.js
# 打开浏览器就能看到 alert 弹窗

# 退出调试，恢复到正常状态
$rm umi.js
```

以此类推即可调试其他的 JavaScript 文件。

## 调试临时文件

`.umi` 目录下临时文件的内容是 `umi` 生成的，如果需要修改调试临时文件需要修改 Umi 相关包的代码，非常不方便，要恢复到调试前的状态也很麻烦。这样的调试需求 Umi 也有方便的解决方案。

举例：我们要在 `src/.umi/core/route.ts` 打印调试信息，只需要在该文件的第一行输入 `// debug`，这样禁止 `umi` 再修改这个临时文件，这样你能随意的修改这个文件，即使项目重启也不会有影响。

```ts
// debug
// @ts-nocheck
// This file is generated by Umi automatically
// DO NOT CHANGE IT MANUALLY!
import React from 'react';

export async function getRoutes() {
    console.log('debuging route.ts');
    // ...
}
```
如果要退出调试也很方便，删除 `src/.umi` 目录，然后重新生成临时文件目录即可。

```bash
$ rm -rf src/.umi
$ npx umi setup
# 或者直接 dev 启动
$ npx umi dev
# src/.umi 恢复到正常模式
```

## XSwitch

如果需要在特定的域名环境调试或者验证当前的修改的代码，推荐使用 Chrome 插件 [XSwitch](https://chrome.google.com/webstore/detail/xswitch/idkjhjggpffolpidfkikidcokdkdaogg)。


![xswitch-logo](https://gw.alipayobjects.com/mdn/rms_ffea06/afts/img/A*fp9yRINN6aMAAAAAAAAAAAAAARQnAQ)


假设我们想在线上项目地址 `https://www.myproject.com` 上调试本地代码。项目使用 `https://www.myproject.com/umi.hash.js`，为了验证本地的项目，需要将它替换成本地开发环境的 `http://127.0.0.1:000/umi.js`

首先使用环境变量 `SOCKET_SERVER` 启动本地环境（防止因为连接不上 socket server 导致页面不断刷新）。
```bash
$SOCKET_SERVER=http://127.0.0.1:8000/ npx umi dev
```

然后，在 XSwitch 中配置资源转发规则。
```json
{
  "proxy": [
    // 数组的第 0 项的资源会被第 1 项目替换
    [
      "https://www.myproject.com/umi.2c8a01df.js",
      "http://127.0.0.1:8000/umi.js"
    ],
    // 使用正则可以方便处理分包情况下 js 资源的加载
    [
      "https://www.myproject.com/(.*\.js)",
      "http://127.0.0.1:8000/$1",
    ],
    // 如果需要验证视觉表现，不要忘记替换 css 资源
    [
      "https://www.myproject.com/umi.ae8b10e0.css",
      "http://127.0.0.1:8000/umi.css"
    ]
  ]
}
```

刷新页面，正式域名下的内容就被替换了，这个时候就能方便的指定环境下调试了。

如果要退出调试，关闭 XSwitch 插件功能即可。

![turn-off-xswitch](https://gw.alipayobjects.com/mdn/rms_ffea06/afts/img/A*qXbNQJvz8-QAAAAAAAAAAAAAARQnAQ)

<Message type='success' emoji="💡">
经常使用 XSwitch 的话，可新建一个规则保存。
</Message>

![rule](https://gw.alipayobjects.com/mdn/rms_ffea06/afts/img/A*oWfiT6R0SJkAAAAAAAAAAAAAARQnAQ)