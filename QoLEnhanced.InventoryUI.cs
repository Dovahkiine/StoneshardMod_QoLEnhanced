using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace QoLEnhanced
{
    public partial class QoLEnhanced : Mod
    {
        private void PatchBlock_09_InventoryUI()
        {
            // ========================================================================
            // 区块 9: 背包与仓库 UI (Inventory & Stash UI)
            // ========================================================================
            // 功能: 扩展背包容量，优化 UI 尺寸参数
            // 范围: 背包、仓库、交易界面、UI 贴图等

            #region 9.1 仓库扩容 (Stash Expansion) && 交易界面尺寸调整 (UI Scaling)

            // [交易界面扩容] 调整交易界面尺寸参数
            // 目的: 增加可视范围，提升交易便利性
            String[] o_trade_inventory_Create_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 278))", "image_yscale = 191", "image_yscale = 218", "areaHeight = 215", "trackHeight = 189", "itemsContainerHeight = 215", "cellsRowHeight = 8" };
            String[] o_trade_inventory_Replace_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 332))", "image_yscale = 245", "image_yscale = 272", "areaHeight = 269", "trackHeight = 243", "itemsContainerHeight = 269", "cellsRowHeight = 40" };

            for (int i = 0; i < o_trade_inventory_Create_0.Length; i++)
            {
                MslExtensions.QuickMatch("gml_Object_o_trade_inventory_Create_0", o_trade_inventory_Create_0[i], o_trade_inventory_Replace_0[i]);
            }

            // [仓库界面扩容] 调整仓库界面尺寸参数
            String[] o_stash_inventory_Create_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 276))", "image_yscale = 218", "image_yscale = 245", "areaHeight = 242", "trackHeight = 216", "itemsContainerHeight = 242", "cellsRowHeight = 20" };
            String[] o_stash_inventory_Replace_0 = { "scrollbarDOWN = scr_guiCreateInteractive(id, o_scrollbarDOWN, (depth - 5), (adaptiveOffsetX + 274), (adaptiveOffsetY + 330))", "image_yscale = 272", "image_yscale = 299", "areaHeight = 296", "trackHeight = 270", "itemsContainerHeight = 296", "cellsRowHeight = 200" };

            for (int i = 0; i < o_stash_inventory_Create_0.Length; i++)
            {
                MslExtensions.QuickMatch("gml_Object_o_stash_inventory_Create_0", o_stash_inventory_Create_0[i], o_stash_inventory_Replace_0[i]);
            }

            #endregion

            #region 9.2 背包扩容与图形优化 (Inventory Expansion & Graphics)

            // [背包扩容] 根据分辨率自适应容器容量
            // 540p (1920x1080): 10列7行 / 720p (2560x1440): 12列11行
            MslExtensions.QuickMatchFromUntil("gml_Object_o_inventory_Create_0",
            "itemsContainer = scr_guiCreateContainer(id,",
            "scr_inventory_container_cells_add(id, cellsContainer, 5)", @"
            var _inv_cols = (global.cameraHeight >= 720) ? 12 : 10
            var _inv_rows = (global.cameraHeight >= 720) ? 11 : 7
            var _offsetX = (global.cameraHeight >= 720) ? (47 - adaptiveOffsetX) : adaptiveOffsetX
            itemsContainer = scr_guiCreateContainer(id, o_guiContainerEmpty, depth, _offsetX, (adaptiveOffsetY + 151))
            cellsContainer = scr_inventory_container_create(itemsContainer, _inv_cols)
            scr_inventory_container_cells_add(id, cellsContainer, _inv_rows)");

            // [UI 贴图] 运行时根据 global.cameraHeight 自动选择对应分辨率的精灵
            // 540p (cameraHeight=540): _540_rusty 系列 | 720p (cameraHeight=720): _720 系列
            Msl.LoadGML("gml_Object_o_inventory_Create_0").MatchFrom("is_start_equipment = false").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_inventory_720_12x11
            else
                sprite_index = s_inventory_540_rusty10x7").Save();

            // [交易界面切换] 打开 o_inventory 时恢复物品栏精灵
            Msl.LoadGML("gml_Object_o_inventory_Other_11").MatchFrom("scr_escapeButtonListAdd()").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_inventory_720_12x11
            else
                sprite_index = s_inventory_540_rusty10x7").Save();

            Msl.LoadGML("gml_Object_o_trade_inventory_Create_0").MatchFrom("event_inherited()").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_trade_inventory_720_10x7
            else
                sprite_index = s_trade_inventory_540_rusty10x7").Save();

            Msl.LoadGML("gml_Object_o_stash_inventory_Create_0").MatchFrom("event_inherited()").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_stash_inventory_720_10x7
            else
                sprite_index = s_stash_inventory_540_rusty10x7").Save();

            Msl.LoadGML("gml_Object_o_stash_inventory_right_Create_0").MatchFrom("closeLeftMenu = true").InsertBelow(@"
            if (global.cameraHeight >= 720)
                sprite_index = s_stash_trade_inventory_720_10x7
            else
                sprite_index = s_stash_trade_540_rusty10x7
            with (mask) { sprite_index = other.sprite_index }").Save();

            #endregion

            #region 9.3 修复扩容后底行格子被 o_bottompanel 屏蔽点击 (Hotbar Bottom Panel Interaction Fix)

            // [问题] 背包扩容到 12x11 后，最底行格子与屏幕底部 o_bottompanel (depth=-12150) 在 bbox 上重叠，
            // can_press_gui -> scr_isNearestInstanceDepth 把更靠前的 o_bottompanel 识别为遮挡者，吞掉点击。
            // [方案] 把 o_bottompanel 加入 global.guiInteractiveExcludedObjectsList，让深度检测忽略它。
            // o_bottompanel 本身是装饰底板，非交互对象，加入排除列表不影响其他逻辑。
            Msl.LoadGML("gml_GlobalScript_scr_guiControllerCreate")
                .MatchFrom("ds_list_add(global.guiInteractiveExcludedObjectsList,")
                .InsertBelow("ds_list_add(global.guiInteractiveExcludedObjectsList, o_bottompanel)")
                .Save();

            // [拖拽放置补漏] 物品被拿起后，放置高亮由 scr_item_select_cell_find_nearest()
            // 每帧计算 select_cell_id。原版实现通过“鼠标中心点下最前方 GUI 实例”查找格子容器，
            // 但扩容后的底行会被底部面板覆盖，拖拽期间还会有选中物品和高亮对象参与 GUI 深度排序，
            // 导致格子容器偶尔被前景对象挡住，表现为放置高亮闪烁或第二次拖拽后无法放置。
            // 这里改为全量替换该 helper：只扫描当前打开的左右库存窗口，并按格子容器自身矩形判定命中。
            // 这样不依赖脆弱的单行 MatchFrom，也不会把底板、技能栏、拖拽物品或高亮层当成放置目标。
            Msl.SetStringGMLInFile(ModFiles.GetCode("gml_GlobalScript_scr_item_select_cell_find_nearest.gml"),
                "gml_GlobalScript_scr_item_select_cell_find_nearest");

            #endregion
        }
    }
}
