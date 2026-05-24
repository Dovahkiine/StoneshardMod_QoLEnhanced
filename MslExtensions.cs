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
    // ========================================================================
    // MSL 扩展工具类 (MSL Extension Utility Class)
    // ========================================================================
    // 功能: 提供 MSL 操作的便利方法集，简化重复代码
    // 设计: 按功能分类，便于复用和维护

    public static class MslExtensions
    {
        // ════════════════════════════════════════════════════════════════════
        // 工具类区块 A: 基础替换操作 (Basic Replacement Operations)
        // ════════════════════════════════════════════════════════════════════

        // 快速匹配并替换 GML 脚本中的字符串
        public static void QuickMatch(string gmlName, string original, string replacement)
        {
            Msl.LoadGML(gmlName).MatchFrom(original).ReplaceBy(replacement).Save();
        }

        // 快速在指定位置下方进行替换
        public static void QuickMatchBelow(string gmlName, string original, int linesAfter, string replacement)
        {
            Msl.LoadGML(gmlName).MatchBelow(original, linesAfter).ReplaceBy(replacement).Save();
        }

        // 快速从范围到范围的替换操作
        public static void QuickMatchFromUntil(string gmlName, string originalFrom, string originalUntil, string replacement)
        {
            Msl.LoadGML(gmlName).MatchFromUntil(originalFrom, originalUntil).ReplaceBy(replacement).Save();
        }

        // ════════════════════════════════════════════════════════════════════
        // 工具类区块 B: 文件导入替换操作 (File Import Operations)
        // ════════════════════════════════════════════════════════════════════

        // 从外部文件导入内容进行替换
        public static void QuickMatchFiles(string gmlName, string original, ModFile ModFiles, string replacement)
        {
            Msl.LoadGML(gmlName).MatchFrom(original).ReplaceBy(ModFiles, replacement).Save();
        }

        // 全量替换为外部文件内容
        public static void QuickMatchAll(string gmlName, ModFile ModFiles, string replacement)
        {
            Msl.LoadGML(gmlName).MatchAll().ReplaceBy(ModFiles, replacement).Save();
        }

        // 从范围内替换为外部文件内容
        public static void QuickMatchFromUntilFiles(string gmlName, string originalFrom, string originalUntil, ModFile ModFiles, string replacement)
        {
            Msl.LoadGML(gmlName).MatchFromUntil(originalFrom, originalUntil).ReplaceBy(ModFiles, replacement).Save();
        }

        // ════════════════════════════════════════════════════════════════════
        // 工具类区块 C: 插入操作 (Insertion Operations)
        // ════════════════════════════════════════════════════════════════════

        // 在指定位置下方插入文件内容
        public static void QuickInsertBelowFiles(string gmlName, string original, ModFile modFiles, string replacement)
        {
            Msl.LoadGML(gmlName).MatchFrom(original).InsertBelow(modFiles, replacement).Save();
        }

        // 在指定位置下方插入文本内容
        public static void QuickInsertBelow(string gmlName, string original, string insertion)
        {
            Msl.LoadGML(gmlName).MatchFrom(original).InsertBelow(insertion).Save();
        }

        // ════════════════════════════════════════════════════════════════════
        // 工具类区块 D: 高级操作 (Advanced Operations)
        // ════════════════════════════════════════════════════════════════════

        // 在指定行数后使用文件替换
        public static void QuickMatchBelowFiles(string gmlName, string original, int linesAfter, ModFile ModFiles, string replacement)
        {
            Msl.LoadGML(gmlName).MatchBelow(original, linesAfter).ReplaceBy(ModFiles, replacement).Save();
        }

        // 在程序集级别进行行数后替换
        public static void QuickAssemblyMatchBelowFiles(string gmlName, string original, int linesAfter, ModFile ModFiles, string replacement)
        {
            Msl.LoadAssemblyAsString(gmlName).MatchBelow(original, linesAfter).ReplaceBy(ModFiles, replacement).Save();
        }

        public static IEnumerable<string> InsertCode(IEnumerable<string> input, string target, string codeToInsert)
        {
            foreach (string item in input)
            {
                if (item.Contains(target))
                {
                    yield return codeToInsert;
                }
                yield return item;
            }
        }

        public static void QuickInject(string fileName, string target, string codeAsString)
        {
            ProcessAndSave(fileName, lines => lines.InjectIf(l => l.Contains(target), codeAsString));
        }

        public static void QuickReplace(string fileName, string target, string codeAsString)
        {
            ProcessAndSave(fileName, lines => lines.ReplaceIf(l => l.Contains(target), codeAsString));
        }

        public static void QuickReplaceRange(string fileName, string target, int linesToRemove, string newCode)
        {
            ProcessAndSave(fileName, lines => lines.ReplaceRangeIf(target, linesToRemove, newCode));
        }

        // 提取出的公共文件流处理方法
        private static void ProcessAndSave(string fileName, Func<IEnumerable<string>, IEnumerable<string>> action)
        {
            // 1. 获取原始代码流
            var originalLines = Msl.LoadAssemblyAsString(fileName).ienumerable;

            // 2. 执行动作
            var resultLines = action(originalLines);

            // 3. 【核心修复】深度扁平化清理
            // 先把所有内容拼成一个大字符串，再按行切开，确保每一行都能被 Trim
            string totalContent = string.Join("\n", resultLines);

            var finalLines = totalContent
                .Split(new[] { "\r\n", "\n" }, StringSplitOptions.None) // 切开
                .Select(line => line.Trim())                            // 每一行都 Trim
                .Where(line => !string.IsNullOrWhiteSpace(line))        // 去掉空行
                .ToList();

            // 3. 写回文件注意：由于 IEnumerable 是惰性的，调用 ToList 确保在保存前逻辑已经执行完成
            Msl.SetAssemblyString(string.Join("\n", finalLines), fileName);
        }
    }


    public static class GmlInjectionExtensions
    {


        public static IEnumerable<string> InjectIf(this IEnumerable<string> input, Func<string, bool> matchCondition, string codeToInsert)
        {

            Action<string> safeShow = (msg) =>
                {

                    // 在已加载的程序集中寻找 WPF 库
                    var ass = AppDomain.CurrentDomain.GetAssemblies()
                                .FirstOrDefault(a => a.GetName().Name == "PresentationFramework");
                    var type = ass?.GetType("System.Windows.MessageBox");
                    type?.GetMethod("Show", new[] { typeof(string) })?.Invoke(null, new[] { msg });

                };

            bool isMatched = false;
            foreach (var line in input)
            {
                if (matchCondition(line) && !isMatched)
                {
                    isMatched = true;
                    yield return codeToInsert;
                }
                yield return line;
            }

            if (!isMatched) { safeShow($"InjectIf: 未找到匹配项!"); }
        }

        public static IEnumerable<string> ReplaceIf(this IEnumerable<string> input, Func<string, bool> matchCondition, string codeToReplace)
        {

            Action<string> safeShow = (msg) =>
                {

                    // 在已加载的程序集中寻找 WPF 库
                    var ass = AppDomain.CurrentDomain.GetAssemblies()
                                .FirstOrDefault(a => a.GetName().Name == "PresentationFramework");
                    var type = ass?.GetType("System.Windows.MessageBox");
                    type?.GetMethod("Show", new[] { typeof(string) })?.Invoke(null, new[] { msg });

                };

            bool isMatched = false;
            foreach (var line in input)
            {
                if (matchCondition(line) && !isMatched)
                {
                    isMatched = true;
                    yield return codeToReplace; // 只返回新代码，不返回 line
                }
                else
                {
                    yield return line;
                }

            }

            if (!isMatched) { safeShow($"ReplaceIf: 未找到匹配项!"); }
        }

        public static IEnumerable<string> ReplaceRangeIf(this IEnumerable<string> input, string target, int linesToRemove, string newCode)
        {

            Action<string> safeShow = (msg) =>
                {

                    // 在已加载的程序集中寻找 WPF 库
                    var ass = AppDomain.CurrentDomain.GetAssemblies()
                                .FirstOrDefault(a => a.GetName().Name == "PresentationFramework");
                    var type = ass?.GetType("System.Windows.MessageBox");
                    type?.GetMethod("Show", new[] { typeof(string) })?.Invoke(null, new[] { msg });

                };

            int skipCounter = 0;
            bool isMatched = false;
            foreach (var line in input)
            {
                // 如果计数器还在运作，说明这行是要被"吃掉"的，直接跳过
                if (skipCounter > 0)
                {
                    skipCounter--;
                    continue;
                }

                // 如果匹配到目标
                if (line.Contains(target) && !isMatched)
                {
                    isMatched = true;
                    yield return newCode;              // 返回你的新代码
                    skipCounter = linesToRemove - 1;   // 设定接下来要跳过（删除）几行
                }
                else
                {
                    yield return line;                 // 正常返回原行
                }
            }

            if (!isMatched) { safeShow($"ReplaceRangeIf: 未找到匹配项: {target}"); }
        }
    }
}
