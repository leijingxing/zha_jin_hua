# 操作留痕

- 日期：2026-01-06
  操作：调整依赖为 GetX，移除 Riverpod 与 go_router。
  影响文件：pubspec.yaml
- 日期：2026-01-06
  操作：新增 Font Awesome 图标依赖。
  影响文件：pubspec.yaml
- 日期：2026-01-06
  操作：更新视觉规范，允许使用静态图片资源。
  影响文件：README.md
- 日期：2026-01-06
  操作：创建资源目录结构（images/audio/fonts）。
  影响文件：assets/ 目录
- 日期：2026-01-06
  操作：生成 PNG 商业风格项目 Logo。
  影响文件：assets/images/logo.png
- 日期：2026-01-06
  操作：配置资源目录到 Flutter 资源清单。
  影响文件：pubspec.yaml
- 日期：2026-01-06
  操作：生成 52 张标准牌面 PNG。
  影响文件：assets/images/cards/ 目录
- 日期：2026-01-06
  操作：补充牌面图片命名规范说明。
  影响文件：README.md
- 日期：2026-01-06
  操作：补充大小王牌面 PNG 与命名说明。
  影响文件：assets/images/cards/BJ.png、assets/images/cards/RJ.png、README.md
- 日期：2026-01-06
  操作：搭建 GetX 项目基础架构与入口文件。
  影响文件：lib/core/*、lib/router/*、lib/modules/lobby/*、lib/main_dev.dart、lib/main_prod.dart、lib/data/data_placeholder.dart
- 日期：2026-01-06
  操作：新增登录/注册页面与本地存储服务，接入 GetX 路由与初始化流程。
  影响文件：lib/modules/auth/*、lib/data/storage/local_storage_service.dart、lib/router/*、lib/core/app.dart、lib/main_dev.dart、lib/main_prod.dart
- 日期：2026-01-06
  操作：新增游戏主页与玩法选择，登录后跳转主页并进入牌桌。
  影响文件：lib/modules/home/*、lib/modules/game/game_view.dart、lib/router/*、lib/modules/auth/login_view.dart、lib/main_dev.dart、lib/main_prod.dart
- 日期：2026-01-06
  操作：封装应用初始化流程，统一入口启动逻辑。
  影响文件：lib/core/bootstrap.dart、lib/main_dev.dart、lib/main_prod.dart
- 日期：2026-01-06
  操作：新增 Flutter 运行配置（开发/生产）。
  影响文件：.run/flutter_dev.run.xml、.run/flutter_prod.run.xml
- 日期：2026-01-06
  操作：优化登录与注册页面视觉样式，调整为商务风格。
  影响文件：lib/modules/auth/login_view.dart、lib/modules/auth/register_view.dart
- 日期：2026-01-06
  操作：登录流程取消账号密码校验，直接写入登录状态。
  影响文件：lib/modules/auth/auth_controller.dart、lib/modules/auth/login_view.dart
- 日期：2026-01-06
  操作：优化游戏主页 UI 为商务风格并加入图标与渐变按钮。
  影响文件：lib/modules/home/home_view.dart
- 日期：2026-01-06
  操作：修正玩法列表的 Obx 使用方式，避免延迟读取导致的 GetX 报错。
  影响文件：lib/modules/home/home_view.dart
- 日期：2026-01-06
  操作：新增横屏商务风格牌桌 UI 骨架。
  影响文件：lib/modules/game/game_view.dart
- 日期：2026-01-06
  操作：进入牌桌页面时锁定横屏，退出恢复竖屏。
  影响文件：lib/modules/game/game_view.dart
- 日期：2026-01-06
  操作：主页改为横屏布局并简化结构，右侧面板集中操作区；登录/注册锁定竖屏。
  影响文件：lib/modules/home/home_view.dart、lib/modules/auth/login_view.dart、lib/modules/auth/register_view.dart
- 日期：2026-01-06
  操作：非登录页面启用沉浸模式隐藏系统状态栏，登录/注册恢复常规显示。
  影响文件：lib/modules/home/home_view.dart、lib/modules/game/game_view.dart、lib/modules/auth/login_view.dart、lib/modules/auth/register_view.dart
- 日期：2026-01-06
  操作：牌桌页面改为静态横屏布局（移除横竖屏切换逻辑），并简化结构提升清晰度。
  影响文件：lib/modules/game/game_view.dart
- 日期：2026-01-06
  操作：压缩牌桌 UI 间距与尺寸，侧栏支持滚动，避免溢出。
  影响文件：lib/modules/game/game_view.dart
- 日期：2026-01-06
  操作：进一步缩小侧栏与控件尺寸，扩大中间牌桌视觉占比。
  影响文件：lib/modules/game/game_view.dart
- 日期：2026-01-06
  操作：压缩牌桌内部布局与手牌区域高度，避免手牌与玩家位置信息重叠。
  影响文件：lib/modules/game/game_view.dart
- 日期：2026-01-06
  操作：放大手牌显示并缩小玩家列表与侧栏尺寸。
  影响文件：lib/modules/game/game_view.dart
- 日期：2026-01-06
  操作：将“你”的座位移出牌桌中心并缩小为紧凑样式。
  影响文件：lib/modules/game/game_view.dart
