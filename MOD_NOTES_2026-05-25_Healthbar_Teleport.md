# 2026-05-25 生命条迁移与传送扩展归档

## 本次结果

- 敌人生命条功能已从独立 healbar 模组迁入 QoLEnhanced。
- 生命条配置已改为使用 MSL `AddMenu(...)`，不再维护自建 settings tab / checkbox / combobox / slider 对象链。
- 传送功能在原有“马车点 / 地牢门口”之外，新增了“大篷车扎营处”目的地开关。

## 最终实现模式

### 1. 生命条配置

- 配置入口在 `QoLEnhanced.cs` 的 `Msl.AddMenu("敌人生命条", ...)`。
- 运行时直接读取以下全局变量：
  - `global.enemyhealthbars_enabled`
  - `global.enemyhealthbars_color`
  - `global.enemyhealthbars_alpha`
  - `global.enemyhealthbars_offset_x`
  - `global.enemyhealthbars_offset_y`
  - `global.enemyhealthbars_bar_height`
  - `global.enemyhealthbars_bar_width`
  - `global.enemyhealthbars_border_width`
- `alpha` 采用 `0-100` 的整数 slider，在血条对象内部换算为 `0-1` 使用。

### 2. 血条对象生命周期

- 敌人 `Create` 注入负责首次生成 `o_enemy_healthbar`。
- 通过敌人实例上的 `__qol_ehb_initialized` 做幂等保护，避免重复生成。
- 血条 `Destroy` 事件会把目标敌人的 `__qol_ehb_initialized` 复位。
- 玩家 `Step` 只在 `enemyhealthbars_enabled` 开关状态变化时，补建或清理现存敌人的血条。

### 3. 传送目的地扩展

- 传送配置入口在 `Msl.AddMenu("传送", ...)`。
- 新增配置项：
  - `global.tp_caravan_msl`
- 大篷车扎营处不属于普通 `Location` 名称表。
- 正确判定方式是读取：
  - `ds_map_find_value_ext(global.caravanDataMap, "gridX", -1)`
  - `ds_map_find_value_ext(global.caravanDataMap, "gridY", -1)`
- 当用户标记坐标与 caravan `gridX/gridY` 相同，且 `tp_caravan_msl` 为真时，允许传送。
- 传送落点时，`global.position_tag` 需要设为原版已有的 `"caravan"`，不能继续沿用 `"fasttravel"`。

## 这次确认下来的规律

### A. 能用 `AddMenu` 的配置，不要再自建 settings tab

- 如果功能只是“若干全局配置项 + 运行时读取”，优先用 `Msl.AddMenu(...)`。
- 这样会天然和现有传送/自动寻路配置保持同一路径，避免额外的对象注册、UI 维护和独立 ini。
- 只有当设置页确实需要复杂的自定义布局或交互时，才值得保留自建 tab。

### B. `UIComponentType.Slider` 适合整数配置，浮点值优先转整数百分比

- 本地 DLL 反射确认：`UIComponentType` 包含 `ComboBox`、`CheckBox`、`Slider`。
- `Slider` 构造函数直接暴露整数范围，因此像 alpha 这种小数项，优先转成整数百分比存储。
- 这种做法比依赖自定义 slider GML 更稳，更贴合 MSL 菜单体系。

### C. 全局地图特殊点先查原版专用数据源，不要先猜 `Location` 名称

- 城镇/据点这类普通快速旅行点可以走 `scr_globaltile_get("Location", ...)`。
- 但先确认它是不是“普通 `Location` 点漏了白名单”，不要一上来就按特殊点处理。
- 这次奥村磨坊对应的真实 key 是 `Osbrookmill`，本质上仍是普通 `fasttravel` 点，只是 TP 白名单漏了它。
- 但 caravan 这类特殊点可能根本不在 `Location` 表，而是在独立的数据结构里。
- 这次 caravan 的真实坐标源是 `global.caravanDataMap.gridX/gridY`，并且原版有 `o_globalmapInteractiveCaravan` 专门处理它。
- 因此，扩展地图相关功能时应优先搜索：
  - `global.*DataMap`
  - `o_globalmapInteractive*`
  - `position_tag`

### D. 传送扩展不只看“是否允许选点”，还要看“落点标签”

- 只允许选择目标坐标还不够。
- 如果原版对该目的地使用特殊 `position_tag`，必须同步写入正确标签，否则落点行为可能偏到普通快速旅行入口。
- caravan 目的地对应 `"caravan"`，地牢门口对应 `"dungeonExit"`，普通城镇类对应 `"fasttravel"`。

### E. 自建功能转入主项目后，要清理死文件而不是长期保留

- 生命条改成 `AddMenu` 之后，原来的 `o_settings_enemyhealthbars` / `o_ehb_slider*` / checkbox / combobox 脚本链都变成死文件。
- 这类文件如果继续保留，会增加后续搜索噪音，并干扰对“当前真实运行链”的判断。
- 迁移收口完成后，应及时删除未注册、未引用的旧脚本。

## 下次遇到类似需求时的快速检查顺序

1. 先判断配置项能否用 `Msl.AddMenu(...)` 承载。
2. 如果菜单项涉及小数，优先改成整数百分比或整数步进。
3. 如果是地图目的地扩展，先搜原版：
   - `o_globalmapInteractive*`
   - `global.*DataMap`
   - `position_tag`
4. 如果新增的是实例型显示对象，优先补：
   - 生成幂等标记
   - 销毁时复位
   - 开关切换时的一次性同步逻辑
