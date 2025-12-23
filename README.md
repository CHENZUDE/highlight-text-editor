# highlight-text-editor

基于原生鸿蒙原生RichEditor实现的关键字高亮文本编辑器

## 项目介绍

highlight-text-editor是一个基于鸿蒙操作系统（HarmonyOS）原生RichEditor组件开发的文本编辑器，支持关键词高亮显示功能。该组件提供了丰富的配置选项和便捷的控制器，方便开发者在鸿蒙应用中集成高亮关键字文本编辑功能。

## 功能特性

- 🔍 支持关键词实时高亮显示
- 🎨 可自定义默认字体颜色和大小
- 🔴 可自定义高亮文本颜色
- 💬 支持占位符文本设置
- ⌨️ 支持默认自动打开输入法
- 📏 支持自定义内边距和约束尺寸
- 📞 提供文本变化回调接口

## 技术栈

- 鸿蒙操作系统（HarmonyOS）
- ArkTS语言
- 原生RichEditor组件

## 安装方法

## API文档

### HighlightTextEditor组件

| 参数 | 类型 | 必填 | 默认值 | 描述 |
|------|------|------|--------|------|
| hteController | HighlightTextEditorController | 是 | - | 编辑器控制器 |
| config | HighlightTextEditorConfig | 否 | - | 编辑器配置 |
| onTextChange | (text: string) => void | 是 | - | 文本变化回调 |

### HighlightTextEditorConfig配置类

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| defaultOpenInputMethod | boolean | false | 是否默认打开输入法 |
| defaultText | string | '' | 首次加载的默认文本 |
| defaultFontColor | ResourceColor | Color.Black | 默认字体颜色 |
| defaultFontSize | number | 14 | 默认字体大小 |
| highlightTextColor | ResourceColor | Color.Red | 高亮文本颜色 |
| placeholder | string | '请输入' | 占位符文本 |
| placeholderStyle | PlaceholderStyle | - | 占位符样式 |
| padding | Padding | - | 内边距设置 |
| constraintSize | ConstraintSizeOptions | - | 约束尺寸设置 |

### HighlightTextEditorController控制器

#### 属性

| 属性 | 类型 | 描述 |
|------|------|------|
| keywords | string[] | 需要高亮的关键词列表 |
| defaultFontColor | ResourceColor | 默认字体颜色 |
| defaultFontSize | number | 默认字体大小 |
| highlightTextColor | ResourceColor | 高亮文本颜色 |

#### 方法

| 方法 | 参数 | 描述 |
|------|------|------|
| addText | text: string, offset: number, isOnChange: boolean = true | 添加文本 |
| deleteText | length: number, offset: number | 删除文本 |
| clearText | 无 | 清除所有文本 |
| updateTextStyle | 无 | 更新文本样式 |
| showKeyboard | context: UIContext | 显示键盘 |
