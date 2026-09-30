# 豆包输入法美化器 · DoubaoIME Beautifier

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%2010%20%2F%2011-0078D6?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-3DA639?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/Release-v1.0.0-FF6A00?style=flat-square" alt="Release">
</p>

<p align="center">
  <img src="before.png" width="260" alt="改前：豆包小头像">
  &nbsp;&nbsp;➡&nbsp;&nbsp;
  <img src="after.png" width="260" alt="改后：系统键盘图标">
</p>

<p align="center"><sub>改前：豆包小头像　·　改后：系统键盘图标</sub></p>

让 Windows 任务栏上的豆包输入法更顺眼 —— 把「中 / 英 / A」输入状态字由黑改白，并把旁边那颗圆圆的「豆包大头」换成简洁的系统键盘图标。

三个独立脚本，双击即用，随时一键还原。

---

## 📖 这是什么

Windows 任务栏的语言栏，会为当前输入法绘制两样东西：

1. **输入法头像** —— 字形旁边那个小图标（豆包给的就是那颗圆脑袋）；
2. **输入状态字形** —— `中` / `英` / `A` 三个小字。

豆包输入法（PC 版）这两样默认都不太配合你的桌面：头像是一颗自带品牌色的圆脑袋，和系统风格格格不入；字形是**黑色**的，深色任务栏下几乎看不清。

本项目用两套互不干扰的方案分别解决，并拆成三个各自独立、可单独运行的脚本：

| 脚本 | 作用 | 改动对象 |
| --- | --- | --- |
| **`doubao-ime-replace-icon.bat`** ⭐ | **把豆包大头换成系统键盘图标** | 注册表 CTF 图标项（64 / 32 位两个视图） |
| `doubao-ime-whiten-indicator.bat` | 指示器字形改白（中/英/A） | `tsf-oime-core.dll`（x64 + x86）各打 3 字节补丁 |
| `doubao-ime-restore-all.bat` | 一键还原原厂外观 | 回写 DLL 备份 + 恢复原厂头像 |

三个脚本**互不包含**：只想换头像就跑第一个，只想改白就跑第二个，互不影响。

---

## 🤔 为什么需要它

- **更清爽**：任务栏不再有那颗圆脑袋，换成低调的键盘图标；
- **看得清**：深色任务栏下，黑色「中/英/A」对比度太低，改成白色一眼可辨；
- **官方没有入口**：豆包输入法未提供自定义头像 / 颜色的选项；
- **可回退**：随时一键还原，改错了也不怕。

---

## 🧩 原理：任务栏那两样东西分别是谁画的

任务栏状态指示由**两条互不干扰的渲染管线**产生：

- **头像**：由系统从注册表登记的文件读取 —— 改注册表即可；
- **字形（中/英/A）**：由输入法自己的动态库 `tsf-oime-core.dll` 绘制，颜色分支直接写在指令里 —— 只能靠给 DLL 打补丁来改。

因此本项目用「注册表改写」与「二进制补丁」两种手段，各自独立完成。

---

## ⭐ 主菜：替换任务栏头像 — `doubao-ime-replace-icon.bat`

**改什么**：任务栏上那个头像所对应的注册表图标项。

**怎么实现**：

- 头像由该输入法 TSF 语言配置的图标位决定：

  `````
  HKLM\SOFTWARE\Microsoft\CTF\TIP\<输入法CLSID>\LanguageProfile\0x00000804\<ProfileGUID>
      IconFile   (REG_SZ)     图标来源（.ico / .dll / .exe）
      IconIndex  (REG_DWORD)  图标序号
  `````

  豆包实测值：`CLSID {9D2B2E2B-…}`，语言 `0x00000804`，原厂指向 `C:\Windows\System32\tsf-oime.dll`，`index 0`。

- 脚本把**内嵌的多尺寸 ICO**（16 / 20 / 24 / 32 / 48 px，覆盖不同 DPI 缩放）释放到本地目录，再把 `IconFile` / `IconIndex` 指向这把键盘图标。

- **两个视图都要改**：`SOFTWARE\…` 与 `SOFTWARE\WOW6432Node\…` 各有一份，只改一处可能读回旧值。

- 改完需重启 `explorer` 才会重新取图；脚本默认自动重启。

- 原厂值会先导出备份，随时可以换回。

---

## 🎨 小菜：指示器字形改白 — `doubao-ime-whiten-indicator.bat`

**改什么**：`tsf-oime-core.dll` 里绘制字形的颜色分支。

**怎么实现**：

- 中/英/A 三个字形是 PNG 位图，以 **RCDATA 资源**的形式嵌在 `tsf-oime-core.dll` 内，**黑、白各一套**：

  | 资源 ID | 字形 | 颜色 |
  | --- | --- | --- |
  | 101 / 102 / 103 | 中 / 英 / A | 黑 |
  | 106 / 107 / 108 | 中 / 英 / A | 白 |

  规律：**白色 ID = 黑色 ID + 5**。

- DLL 里有一个**分发函数**：它读取系统主题标志，再用一条条件移动指令 `cmovne ecx, edx` 决定这次取黑组还是白组。

- 补丁只做一件事：把这条**条件选择**改成**无条件取白组**（`cmovne ecx,edx` → `mov ecx,edx` + `nop`，长度不变），**每个架构仅 3 字节**，不涉及重定位。

- **定位用锚点、不写死偏移**：脚本搜索字节序列 `B9 65 00 00 00 BA 6A 00 00 00`（即 `mov ecx,101` + `mov edx,106`），其后 24 字节内的 `0F 45 CA` 就是唯一分发点。豆包升级、偏移变化也能重新定位；**找不到锚点或字节不符时，脚本零写入安全退出**。

- **x64 与 x86 两份都要改**：64 位宿主程序加载 `versions\<版本>\tsf-oime-core.dll`，32 位宿主程序加载 `versions\<版本>\x86\` 下的副本，脚本自动发现并分别处理。

- **让新代码生效**：只有在补丁落盘之后启动的进程才会加载新代码。脚本默认改完重启 `explorer`；若个别前台程序仍显示旧色，重启该程序或重启一次电脑即可。

### 与 TranslucentTB 完美共存

用 [TranslucentTB](https://github.com/TranslucentTB/TranslucentTB) 把任务栏做成透明 / 亚克力效果时，默认那套**黑色**「中/英/A」会更看不清 —— 这正是本脚本的用武之地：

- 改白之后，无论任务栏是纯色、透明还是亚克力，三种字形都清晰可辨；
- 补丁只改了 `tsf-oime-core.dll` 里「取哪套颜色」的 3 个字节，**完全不碰任务栏绘制**，因此不会与 TranslucentTB 的透明 / 模糊 / 颜色效果冲突；
- 两个工具各管各的，可同时使用、互不干扰。

---

## ♻️ 一键还原 — `doubao-ime-restore-all.bat`

- 把改过的 DLL 从备份**逐字节还原**，并恢复原厂头像注册表值；
- 支持**只还原其中一项**：`/dll` 只还原字形，`/icon` 只还原头像；
- 还原前后都会核对字节，确保不会写出损坏的 DLL。

---

## 🚀 使用方法

1. 下载三个 `.bat`（见 [Releases](https://github.com/CHRIScheng233/doubao-ime-beautifier/releases)），放到任意目录；
2. **以管理员身份**双击运行（需要修改 `HKLM` 注册表 / 程序文件）；
3. 想先看要改什么，先跑一次**只读预览**：

   ````bat`
   doubao-ime-replace-icon.bat --check
   doubao-ime-whiten-indicator.bat --check
   `````

4. 想撤销，双击 `doubao-ime-restore-all.bat`。

**可选参数**

| 参数 | 说明 |
| --- | --- |
| `--check` | 只读预览，不做任何写入、不重启 |
| `--no-restart` | 执行改动，但不自动重启 explorer |
| `--dir <目录>` | 手动指定豆包安装目录（通常无需） |

---

## 💻 兼容性

- 豆包输入法 PC 版 **v0.9.0.0** 实测通过（x64 / x86 均已验证）；
- Windows 10 / 11；
- 安装目录默认 `C:\Program Files\DoubaoIME\`，脚本用通配符自动发现实际版本目录。

---

## ❓ 常见问题

**Q：改完后「英」字还是黑的？**
A：多半是有程序在补丁落盘**之前**就已启动，内存里还是旧代码 —— 重启该程序，或重启一次电脑即可。

**Q：豆包升级后又变回去了？**
A：升级会覆盖 DLL 或换掉版本目录，重新运行对应脚本即可。

**Q：会不会影响输入法功能？**
A：不会。脚本只改「取哪套颜色」和「头像指向哪个文件」两处，不触碰输入、候选词与切换逻辑。

**Q：安全吗？能撤销吗？**
A：每次改动前都会自动备份原文件；`doubao-ime-restore-all.bat` 可完整还原。

---

## ⚠️ 免责声明

本项目通过修改注册表与程序文件实现外观定制，请在理解原理后自行决定是否使用；使用前请确保已备份重要数据，因使用本脚本产生的后果由使用者自行承担。

## 📄 License

[MIT](LICENSE)

---

<p align="center"><sub>Made by CHRIScheng233 · 愿你的任务栏清清爽爽</sub></p>
