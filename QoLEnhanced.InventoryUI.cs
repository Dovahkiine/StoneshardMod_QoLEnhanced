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
        }
    }
}
