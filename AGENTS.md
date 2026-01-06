# Repository Guidelines

## 元信息
- 注释,提示全部使用中文,编码使用 UTF-8

## 项目结构与模块组织
- `lib/` 按 `core/`、`data/`、`modules/`、`router/`、`generated/` 分层，业务逻辑集中在 `modules/`，勿擅自改动 `generated/`。
- `test/` 存放单元与 Widget 测试，命名与被测文件保持一致，例如 `modules/table/table_state_test.dart`。
- `docs/` 保留设计文档与 AI 策略说明，新增资料请按主题创建子文件。
- 平台端目录 `android/`、`ios/`、`web/` 仅在集成与配置变更时修改。

## 构建、测试与开发命令
- `flutter pub get`：拉取或更新依赖，提交前确保依赖文件处于同步状态。
- `flutter run --target lib/main_dev.dart`：以开发配置启动应用。
- `flutter analyze`：运行静态分析，仅需处理终端标记为红色的错误，其余警告可暂缓。
- `flutter test [--name <过滤>]`：按需运行测试用例，可针对新增模块编写或执行必要测试，无需覆盖所有文件。

## 编码风格与命名约定
- 遵循 `analysis_options.yaml` 中的 lint 规则，保持 2 空格缩进与尾随逗号的 Flutter 风格。
- 公开类与方法使用小驼峰或大驼峰中文拼音/英语混合，确保语义明确，如 `ZjhTableController`。
- 状态文件命名采用功能域前缀，例如 `table_state.dart`、`lobby_view.dart`。
- UI 字符串集中在本地化资源，代码注释与日志全部使用简体中文。

## 测试指引
- 使用 `package:test` 与 `flutter_test`，覆盖核心牌局逻辑、AI 决策与关键 Widget。
- 测试文件命名为 `<被测文件>_test.dart`，断言命名说明预期，如 `expectPlayerWinsWhenHigherRank`。
- 新增模块需附带最小测试验证洗牌随机性、下注状态机与异常分支，可根据工作量选择关键场景编写。
