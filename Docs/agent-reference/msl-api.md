# QoLEnhanced 按需参考

以下内容从原项目入口迁入；代码、命令及普通文本路径仍相对 QoLEnhanced 根。仅查当前任务相关章节，历史数值与文件身份须以当前源码核对。

### MSL API 参考与开发文档

**不熟悉 MSL API 用法时，优先去 `D:\Downloads\StoneShard_Lib\ModShardLauncher-Enhanced\Guides\` 目录阅读 HTML 开发文档。** 该目录包含以下指南：

| 指南文件 | 内容 |
|---------|------|
| **MSL_Modding_Survival_Guide.html** | 🔴 最重要：MSL 安全/不安全 API、GML 预处理系统、变量命名规范、崩溃原因、测试策略、Proven Patterns |
| **MSLE_New_Texture_Loader_Guide.html** | 精灵贴图系统：`NewTextureLoader.LoadTextures(ModFiles)` 批量导入、替换原版精灵、创建新精灵。PNG 放入 `Textures/` 目录 |
| **MSLE_Audio_Integration_Guide.html** | 音频系统：`AudioLoader.LoadAudio(ModFiles)` 自动导入 `Sounds/` 目录下 .ogg/.wav |
| **MSLE_FontLoader_Guide.html** | 字体系统：`FontLoader.LoadFonts(ModFiles)` 提取 .ttf/.otf 到 AppData |
| **MSLE_Shader_Guide.html** | 着色器系统：`shaders/` 目录结构、GLSL 模板、uniform 设置 |
| **MSLE_v1.08+_Features_Guide.html** | `[ModDependency]` 声明模组依赖 |

**关键 MSL API 速查：**

```
// 精灵导入 (推荐: NewTextureLoader, 替代逐条 Msl.GetSprite)
NewTextureLoader.LoadTextures(ModFiles);  // 批量处理 Textures/ 下所有 PNG

// Msl.GetSprite 是查找/注册函数，逐个调用仅注册单个精灵
Msl.GetSprite("s_my_sprite");  // 确保精灵被导入 (旧方式)

// 资产加载顺序: Textures → Audio → Fonts
NewTextureLoader.LoadTextures(ModFiles);
AudioLoader.LoadAudio(ModFiles);
FontLoader.LoadFonts(ModFiles);

// ⚠️ AddFunction 必须在所有被引用对象/资产创建之前调用
// ⚠️ 一个 GML 文件只能包含一个函数 (MSL 解析器限制)
// ⚠️ 避免 Msl.AddCode() — 不可靠
```
