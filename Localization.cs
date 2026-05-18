// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;
using System.Windows;
using System.Diagnostics;
using System.IO;

namespace QoLEnhanced
{
    public class Localization
    {
        public static void ActionLogsPatching()
        {
            List<string> list = new List<string>();
            string value = "planTravelTo";
            string text = "~w~$~/~ plans to go to ~lg~$~/~.";
            string value2 = "~w~$~/~计划前往~lg~$~/~。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "planTravelToUnknown";
            text = "~w~$~/~ plans to travel to an unknown area located at map coordinates ~lg~($, $)~/~.";
            value2 = "~w~$~/~计划前往一个位于地图坐标~lg~（$，$）~/~的未知区域。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "whereToGo";
            text = "~w~$~/~ doesn't know where to go.";
            value2 = "~w~$~/~不知道要往哪去。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "whereToGoMultiMarkers";
            text = "~w~$~/~ doesn't know ~lg~which~/~ of the ~r~$~/~ marked locations to travel to?";
            value2 = "~w~$~/~不知道应该前往这~r~$~/~个标记地点的~lg~哪一个~/~？";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "doorInaccessible";
            text = "~w~$~/~ noticed that the far side was blocked by an obstacle and needed to change position to re-plan the journey.";
            value2 = "~w~$~/~发现远处被障碍物挡住了，需要换个位置重新规划行程。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            value = "doorNotExist";
            text = "~w~$~/~ couldn't find any exit or roads.";
            value2 = "~w~$~/~找不到任何出口或道路。";
            list.Add(string.Concat($"{value};{text};{text};{value2};", string.Concat(Enumerable.Repeat(text + ";", 9))));
            string item = string.Concat(";", string.Concat(Enumerable.Repeat("text_end;", 12)));
            List<string> table = ModLoader.GetTable("gml_GlobalScript_table_log");
            table.InsertRange(table.IndexOf(item), list);
            ModLoader.SetTable(table, "gml_GlobalScript_table_log");
        }
    }
}
