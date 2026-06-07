# Container Reward Notes

- `QuickMatchBelow(...)` 会替换目标行，不会追加。容器奖励扩展必须保留原版首轮 `script_execute(...)`，只在其后补额外逻辑。
- 对 `gml_Object_c_container_Other_13`，安全挂点是 `with (scr_container_create(...))` 里的 `randomize()` 之后；此时原版掉落已完成，`other.id` 和容器 `id` 仍然可用。
- helper 链保持一文件一函数，并按“底层 helper -> 上层 helper -> 原版注入”顺序注册。
- `isQuest` 可作为任务箱早退条件，`is_tomb` 可作为墓地/棺材环境判定。
- 墓地追加奖励里的低价值骨类可按对象名过滤，避免全局改表。
- reroll 仍不达标时，用 `o_inv_ancient_coin` 做兜底，比继续出垃圾更稳。
