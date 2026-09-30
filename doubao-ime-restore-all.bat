@echo off
rem ===========================================================================
rem  doubao-ime-restore-all.bat
rem  Task 3/3 : Doubao IME - restore indicator DLL and taskbar icon
rem  Author   : CHRIScheng233                 Version : v2.0-final
rem ---------------------------------------------------------------------------
rem  NOTICE (this header zone is intentionally ASCII-only; the full Chinese
rem  notice, watermark and disclaimer live in the payload below)
rem   * PROHIBITED: modifying or redistributing this script in any form.
rem   * If you modify it, YOU bear ALL consequences alone. (gai zhe si ma)
rem   * The author gives NO warranty for any modified copy of this script.
rem   * It only restores what 1/3 and 2/3 changed; nothing else.
rem  SAFETY
rem   * Embedded SHA-256 self-seal is verified on every start. On mismatch the
rem     script prints a RED warning and asks for confirmation.
rem   * Author only: re-seal after editing with   --reseal
rem   * Binary restore is byte exact and anchor verified; a mismatch aborts and
rem     rolls back instead of writing a broken DLL.
rem   * Keeps a  <name>.pretool-<timestamp>.bak  copy next to every file touched.
rem  USAGE
rem   double click ............ restore + verify + restart explorer (3s countdown)
rem   --check ................. read only preview: zero writes, no restart
rem   --no-restart ............ restore, but never restart explorer
rem   /dll .................... restore the indicator DLL only
rem   /icon ................... restore the taskbar icon only
rem   --reseal ................ recompute the embedded SHA-256 seal (author only)
rem ===========================================================================

chcp 936 >nul
setlocal EnableExtensions
set "DOUBAO_SELF=%~f0"
set "DOUBAO_ARGV=%*"
set "PSC=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PSC%" set "PSC=powershell.exe"
set "CHK="
set "NORESTART="
set "RESEAL="
set "ONLY="
set "DOUBAO_DIR="
set "DIRSEEN="
for %%A in (%*) do (
  if defined DIRSEEN (
    set "DOUBAO_DIR=%%~A"
    set "DIRSEEN="
  ) else (
    if /i "%%A"=="--dir" set "DIRSEEN=1"
    if /i "%%A"=="/dir" set "DIRSEEN=1"
  )
  if /i "%%A"=="--check" set "CHK=1"
  if /i "%%A"=="/check" set "CHK=1"
  if /i "%%A"=="-c" set "CHK=1"
  if /i "%%A"=="--no-restart" set "NORESTART=1"
  if /i "%%A"=="/no-restart" set "NORESTART=1"
  if /i "%%A"=="--norestart" set "NORESTART=1"
  if /i "%%A"=="--reseal" set "RESEAL=1"
  if /i "%%A"=="/reseal" set "RESEAL=1"
  if /i "%%A"=="/dll" set "ONLY=dll"
  if /i "%%A"=="--dll" set "ONLY=dll"
  if /i "%%A"=="/icon" set "ONLY=icon"
  if /i "%%A"=="--icon" set "ONLY=icon"
)
set "DOUBAO_CHECK=%CHK%"
set "DOUBAO_NORESTART=%NORESTART%"
set "DOUBAO_RESEAL=%RESEAL%"
set "DOUBAO_ONLY=%ONLY%"

net session >nul 2>&1
if not errorlevel 1 goto doubao_elev_ok
if defined CHK goto doubao_elev_ok
if defined RESEAL goto doubao_elev_ok
echo.
"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwAsZ+Vdd1EAl4GJoXsGdFhUQ2dQlgz/Y2soVzlf+lEgAFUAQQBDACAA0GNDZ5d641MM//eLKFc5X5d6LU65cPtRDDAvZg0wAjAnACAALQBGAG8AcgBlAGcAcgBvAHUAbgBkAEMAbwBsAG8AcgAgAFkAZQBsAGwAbwB3AA==
"%PSC%" -NoProfile -ExecutionPolicy Bypass -Command "if ([string]::IsNullOrEmpty($env:DOUBAO_ARGV)) { Start-Process -FilePath $env:DOUBAO_SELF -Verb RunAs } else { Start-Process -FilePath $env:DOUBAO_SELF -ArgumentList $env:DOUBAO_ARGV -Verb RunAs }"
exit /b 0
:doubao_elev_ok

"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwBGjAVTk49lUdVsjn8WUyAAMwAvADMAGv9GjAVTk49lUdVsIAC3ACAAAE4uldiPn1MI/wdjOnloViAAKwAgAPtOoVIPaP5WB2gJ/yAAIAB8ACAAIABcTwWAIABDAEgAUgBJAFMAYwBoAGUAbgBnADIAMwAzACAAIAB8ACAAIACBeWJrjE4ha+5POWUvAAZS0VMnACAALQBGAG8AcgBlAGcAcgBvAHUAbgBkAEMAbwBsAG8AcgAgAEMAeQBhAG4A
set "DOUBAO_PAY=%TEMP%\doubao_ime_3_payload_%RANDOM%%RANDOM%.ps1"
"%PSC%" -NoProfile -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllLines('%DOUBAO_SELF%',[Text.Encoding]::UTF8);$n=-1;$e=-1;for($i=0;$i -lt $s.Count;$i++){if($s[$i] -eq '#@@B1@@'){$n=$i;break}};if($n -ge 0){for($i=$s.Count-1;$i -gt $n;$i--){if($s[$i] -eq '#@@E1@@'){$e=$i;break}}};if($n -lt 0 -or $e -lt 0 -or ($e-$n) -lt 100){exit 72};$o='%DOUBAO_PAY%';[IO.File]::WriteAllLines($o,$s[($n+1)..($e-1)],(New-Object Text.UTF8Encoding($true)));exit 0"
if errorlevel 1 (
  echo.
  "%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwDgZdVszk4sZ4dl9k6FUdBj1lNnYkyIfY93gxr/h2X2Tu9T/YAqZ4xbdGULTn2PFmKriO5POWUM//eLzZGwZQtOfY+MW3RlhHYgAEIAQQBUACAADlSNUdWLAjAnACAALQBGAG8AcgBlAGcAcgBvAHUAbgBkAEMAbwBsAG8AcgAgAFIAZQBkAA==
  echo.
  pause
  exit /b 3
)

"%PSC%" -NoProfile -ExecutionPolicy Bypass -File "%DOUBAO_PAY%"
set "RC=%ERRORLEVEL%"
"%PSC%" -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -LiteralPath $env:DOUBAO_PAY -Force -ErrorAction SilentlyContinue"
echo.
"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwBnYkyI035fZwz/CWP7Tg9hLpVzUe2VLGeXeuNTAjAgACAAfAAgACAAQwBIAFIASQBTAGMAaABlAG4AZwAyADMAMwAgALcAIABGjAVTk49lUdVsjn8WUyAAMwAvADMAJwAgAC0ARgBvAHIAZQBnAHIAbwB1AG4AZABDAG8AbABvAHIAIABHAHIAYQB5AA==
pause >nul
exit /b %RC%
#@@B1@@
# ===========================================================================
#  豆包输入法美化 3/3 · 一键还原（指示器 + 任务栏图标）   (doubao-ime-restore-all)
#  作者 (Author): CHRIScheng233        版本 (Version): v2.0-final
# ---------------------------------------------------------------------------
#  【禁止二次修改、禁止二次分发】
#    本脚本只做一件事：把 1/3 与 2/3 做过的改动还原成原厂状态。
#    修改者自行承担全部后果 —— 改者死妈。
#    作者对任何被改动过的副本不作任何担保，也不承担任何责任。
#    脚本内嵌自身 SHA256 签名，每次启动自动校验；不一致会红字警告并要求确认。
#    作者本人改完脚本后，执行 --reseal 重新签名即可消除误报。
#  还原为字节级/注册表级精确回退，改前留 .pretool-<时间戳>.bak，校验不符自动回滚。
# ===========================================================================
#@@SIG@@ 578254A5C66BDF6A26ABBED3DDC3DF8181208A73FBD968D7536D7B98A12FB8F2
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(936) } catch { }
try { [Console]::Title = '豆包输入法美化 3/3 - 还原  |  CHRIScheng233' } catch { }
$AUTHOR = 'CHRIScheng233'
$SELF = "$env:DOUBAO_SELF"
$IsCheck = ($env:DOUBAO_CHECK -eq '1')
$NoRestart = ($env:DOUBAO_NORESTART -eq '1')
$IsReseal = ($env:DOUBAO_RESEAL -eq '1')
$OnlyDir = "$env:DOUBAO_DIR"

function Say([string]$t, [string]$c = 'Gray') { Write-Host $t -ForegroundColor $c }
function Bar { Say ('-' * 68) 'DarkGray' }
function Banner {
  Say ''
  Say '  doubao-ime-restore-all  |  豆包输入法 · 一键还原（指示器 + 任务栏图标）' 'Cyan'
  Say '  作者: CHRIScheng233   |   禁止二次修改 / 禁止二次分发   |   改者死妈' 'DarkGray'
  Bar
}

# ---------------------------- 自身签名 (防篡改) -----------------------------
function Get-Raw { return [IO.File]::ReadAllBytes($SELF) }
function Find-Seal([byte[]]$raw) {
  $s = [Text.Encoding]::GetEncoding(28591).GetString($raw)
  $m = [regex]::Match($s, '#@@SIG@@ ([0-9A-Fa-f]{64})')
  if (-not $m.Success) { return $null }
  return @{ Index = $m.Groups[1].Index; Value = $m.Groups[1].Value.ToUpperInvariant() }
}
function Get-SealHash([byte[]]$raw, [int]$index) {
  $buf = [byte[]]$raw.Clone()
  for ($i = 0; $i -lt 64; $i++) { $buf[$index + $i] = 0x30 }
  $sha = [Security.Cryptography.SHA256]::Create()
  try { return ([BitConverter]::ToString($sha.ComputeHash($buf)) -replace '-', '') } finally { $sha.Dispose() }
}
function Put-Seal([int]$index, [string]$hex) {
  $bytes = [Text.Encoding]::ASCII.GetBytes($hex)
  $fs = [IO.File]::Open($SELF, [IO.FileMode]::Open, [IO.FileAccess]::ReadWrite, [IO.FileShare]::ReadWrite)
  try { $fs.Position = $index; $fs.Write($bytes, 0, $bytes.Length); $fs.Flush() } finally { $fs.Dispose() }
}

if ($IsReseal) {
  Banner
  Say '  模式: 重新签名 (--reseal)   仅作者本人自用' 'Yellow'
  Say ''
  $raw = Get-Raw
  $info = Find-Seal $raw
  if (-not $info) { Say '  [失败] 脚本中找不到签名行，无法重新签名。' 'Red'; Say ''; exit 5 }
  $new = Get-SealHash $raw $info.Index
  Put-Seal $info.Index $new
  $raw2 = Get-Raw
  $info2 = Find-Seal $raw2
  if (-not $info2) { Say '  [失败] 重签名后无法读回签名行。' 'Red'; Say ''; exit 6 }
  $now = Get-SealHash $raw2 $info2.Index
  if ($now -ne $new) { Say '  [失败] 重签名自校验未通过。' 'Red'; Say ''; exit 6 }
  Say ('  旧签名: ' + $info.Value) 'DarkGray'
  Say ('  新签名: ' + $new) 'Green'
  Say '  [完成] 自身签名已更新，现在可以正常使用/分发。' 'Green'
  Say ('  ' + $AUTHOR + '  |  禁止二次修改 / 禁止二次分发') 'DarkGray'
  Say ''
  exit 0
}
Banner
if ($IsCheck) { Say '  模式: 只读预览 (--check)   不会修改任何文件，也不会重启资源管理器' 'Yellow' }
elseif ($NoRestart) { Say '  模式: 实际执行 (改前自动备份、改后校验；--no-restart 不重启资源管理器)' 'Yellow' }
else { Say '  模式: 实际执行 (改前自动备份、改后校验；完成后自动重启资源管理器)' 'Yellow' }
Say ''

$raw = Get-Raw
$seal = Find-Seal $raw
$sealOk = $false
$calc = ''
if ($seal) {
  $calc = Get-SealHash $raw $seal.Index
  if ($calc -eq $seal.Value) { $sealOk = $true }
}
if (-not $sealOk) {
  Say '  [安全警告] 本脚本已被第三方修改，非原作者版本，风险自担。' 'Red'
  if ($seal) {
    Say ('             内嵌签名: ' + $seal.Value) 'Red'
    Say ('             实际签名: ' + $calc) 'Red'
  }
  else { Say '             内嵌签名行缺失或已损坏。' 'Red' }
  Say ('             原作者 ' + $AUTHOR + ' 未对当前副本作任何担保，也不承担任何责任。') 'Red'
  Say '             禁止二次修改、禁止二次分发；修改者自行承担全部后果。' 'Red'
  if ($IsCheck) {
    Say '  当前是只读预览 (--check)，不会写入任何内容，继续检查。' 'Yellow'
  }
  else {
    Say ''
    Say '  是否仍要继续执行? 输入 y 继续，其它任意输入或直接回车则退出。' 'Yellow'
    $ans = ''
    try { $ans = [string](Read-Host '  继续执行? [y/N]') } catch { $ans = '' }
    if ($ans -notmatch '^\s*[Yy]\s*$') {
      Say '  已取消，未对系统和文件做任何改动。' 'Yellow'
      Say ''
      exit 4
    }
  }
  Say ''
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ((-not $isAdmin) -and (-not $IsCheck)) {
  Say '  [错误] 需要管理员权限。' 'Red'
  Say '  请右键选择「以管理员身份运行」，或直接双击本 BAT（会自动提权）。' 'Red'
  Say ''
  exit 2
}
if (-not $isAdmin) { Say '  [提示] 当前为非管理员会话，只读预览无需提权。' 'DarkGray'; Say '' }

# ---------------------------- 还原范围与路径 -------------------------------
$Only = "$env:DOUBAO_ONLY"
$DoDll = ($Only -ne 'icon')
$DoIcon = ($Only -ne 'dll')
$FactoryIcon = 'C:\Windows\System32\tsf-oime.dll'
$nFail = 0
$scope = '指示器 + 任务栏图标'
if ($Only -eq 'dll') { $scope = '仅还原指示器 DLL' }
if ($Only -eq 'icon') { $scope = '仅任务栏图标' }
Say ('  范围: ' + $scope) 'DarkGray'



function Get-Roots {
  $list = New-Object System.Collections.ArrayList
  if ($OnlyDir) {
    if (Test-Path -LiteralPath $OnlyDir) { [void]$list.Add((Resolve-Path -LiteralPath $OnlyDir).Path) }
    return ,$list
  }
  foreach ($p in @("$env:ProgramFiles\DoubaoIME", "${env:ProgramFiles(x86)}\DoubaoIME", "$env:LOCALAPPDATA\Programs\DoubaoIME")) {
    if ($p -and (Test-Path -LiteralPath $p)) { [void]$list.Add((Resolve-Path -LiteralPath $p).Path) }
  }
  return ,$list
}

function Find-All([byte[]]$hay, [byte[]]$needle) {
  $res = New-Object System.Collections.ArrayList
  $enc = [Text.Encoding]::GetEncoding(28591)
  $s = $enc.GetString($hay)
  $p = $enc.GetString($needle)
  $i = $s.IndexOf($p)
  while ($i -ge 0) {
    [void]$res.Add($i)
    if (($i + 1) -ge $s.Length) { break }
    $i = $s.IndexOf($p, $i + 1)
  }
  return ,$res
}

function Get-Arch([byte[]]$d) {
  if ($d.Length -lt 0x100) { return 'unknown' }
  $pe = [BitConverter]::ToInt32($d, 0x3C)
  if ($pe -lt 0 -or ($pe + 6) -gt $d.Length) { return 'unknown' }
  if ($d[$pe] -ne 0x50 -or $d[$pe + 1] -ne 0x45) { return 'unknown' }
  $m = [BitConverter]::ToUInt16($d, $pe + 4)
  if ($m -eq 0x8664) { return 'x64' }
  if ($m -eq 0x014C) { return 'x86' }
  return ('other(0x{0:X})' -f $m)
}

$ANCHOR = [byte[]]@(0xB9,0x65,0x00,0x00,0x00,0xBA,0x6A,0x00,0x00,0x00)

function Analyze([byte[]]$d) {
  $r = @{ State = 'noanchor'; Anchors = 0; Anchor = -1; Offset = -1; Cur = ''; Half = $false }
  $pos = Find-All $d $ANCHOR
  $r.Anchors = [int]$pos.Count
  if ($pos.Count -eq 0) { return $r }
  $a = [int]$pos[0]
  $r.Anchor = $a
  $disp = -1
  $stop = [Math]::Min($a + 64, $d.Length - 3)
  for ($i = $a + $ANCHOR.Length; $i -le $stop; $i++) {
    if ($d[$i] -eq 0x0F -and $d[$i + 1] -eq 0x45 -and $d[$i + 2] -eq 0xCA) { $disp = $i; break }
    if ($d[$i] -eq 0x8B -and $d[$i + 1] -eq 0xCA -and $d[$i + 2] -eq 0x90) { $disp = $i; break }
  }
  if ($disp -lt 0) { $r.State = 'anchor-only'; return $r }
  $r.Offset = $disp
  $r.Cur = ('{0:X2} {1:X2} {2:X2}' -f $d[$disp], $d[$disp + 1], $d[$disp + 2])
  for ($i = [Math]::Max(0, $disp - 12); $i -lt ($disp - 1); $i++) {
    if ($d[$i] -eq 0xB0 -and $d[$i + 1] -eq 0x01) { $r.Half = $true }
  }
  if ($d[$disp] -eq 0x8B) { $r.State = 'patched' } else { $r.State = 'factory' }
  return $r
}

function Get-Sha16([string]$p) { return (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash.Substring(0, 16) }

function Get-TipState {
  $out = New-Object System.Collections.ArrayList
  $views = @(
    @{ Name = '64'; Rel = 'SOFTWARE\Microsoft\CTF\TIP'; View = [Microsoft.Win32.RegistryView]::Registry64 },
    @{ Name = '32'; Rel = 'SOFTWARE\WOW6432Node\Microsoft\CTF\TIP'; View = [Microsoft.Win32.RegistryView]::Registry32 }
  )
  foreach ($v in $views) {
    $hive = $null
    try { $hive = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $v.View) } catch { continue }
    $tip = $hive.OpenSubKey($v.Rel)
    if (-not $tip) { continue }
    foreach ($cls in $tip.GetSubKeyNames()) {
      $lp = $tip.OpenSubKey($cls + '\LanguageProfile')
      if (-not $lp) { continue }
      foreach ($lang in $lp.GetSubKeyNames()) {
        $lk = $lp.OpenSubKey($lang)
        if (-not $lk) { continue }
        foreach ($prof in $lk.GetSubKeyNames()) {
          $pk = $lk.OpenSubKey($prof)
          if (-not $pk) { continue }
          $desc = "$($pk.GetValue('Description'))"
          $icon = "$($pk.GetValue('IconFile'))"
          if (($desc -like '*豆包*') -or ($icon -match 'tsf-oime\.dll') -or ($icon -like '*DoubaoIME-StatusIcon*')) {
            $sub = $v.Rel + '\' + $cls + '\LanguageProfile\' + $lang + '\' + $prof
            $idx = $pk.GetValue('IconIndex')
            if ($null -eq $idx) { $idx = -1 }
            [void]$out.Add([pscustomobject]@{
              View = $v.Name; Sub = $sub; KeyPath = 'HKLM\' + $sub
              Desc = $desc; IconFile = $icon; IconIndex = [int]$idx
            })
          }
        }
      }
    }
  }
  return ,$out
}

function Set-TipValues([object]$m, [string]$icon, [int]$idx) {
  $view = [Microsoft.Win32.RegistryView]::Registry64
  if ($m.View -eq '32') { $view = [Microsoft.Win32.RegistryView]::Registry32 }
  $hive = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $view)
  $k = $hive.OpenSubKey($m.Sub, $true)
  if (-not $k) { throw ('无法以写权限打开注册表键: ' + $m.KeyPath) }
  $k.SetValue('IconFile', $icon, [Microsoft.Win32.RegistryValueKind]::String)
  $k.SetValue('IconIndex', $idx, [Microsoft.Win32.RegistryValueKind]::DWord)
  $k.Close()
}

$nFail = 0
# ---------------- ① 指示器（DLL） ----------------
if ($DoDll) {
  Say '  ── ① 还原：还原 tsf-oime-core.dll ──' 'Cyan'
  $roots = Get-Roots
  $files = New-Object System.Collections.ArrayList
  foreach ($r in $roots) {
    Get-ChildItem -LiteralPath $r -Recurse -Filter 'tsf-oime-core.dll' -File -ErrorAction SilentlyContinue |
      Sort-Object FullName | ForEach-Object { [void]$files.Add($_) }
  }
  if ($files.Count -eq 0) {
    Say '  [跳过] 没有找到 tsf-oime-core.dll（豆包输入法未安装或未找到）。' 'Yellow'
  }
  else {
    $nRestore = 0; $nAlready = 0; $nNoWay = 0
    foreach ($f in $files) {
      $path = $f.FullName
      $bytes = [IO.File]::ReadAllBytes($path)
      $info = Analyze $bytes
      $arch = Get-Arch $bytes
      Say ('  ■ ' + $path + '   [' + $arch + ']') 'White'
      if ($info.State -eq 'factory' -and (-not $info.Half)) {
        Say '    状态: 已是原厂字节（0F 45 CA），无需还原' 'Green'
        $nAlready++
        continue
      }
      if ($info.State -eq 'noanchor' -or $info.State -eq 'anchor-only') {
        Say '    状态: 未找到补丁特征，无法自动还原（可能已被手动替换）' 'Yellow'
        $nNoWay++
        continue
      }
      $dir = Split-Path -Parent $path
      $name = [IO.Path]::GetFileName($path)
      $src = ''
      $baks = @(Get-ChildItem -LiteralPath $dir -Filter ($name + '.bak-*') -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
      foreach ($bk in $baks) {
        try {
          $bi = Analyze ([IO.File]::ReadAllBytes($bk.FullName))
          if ($bi.State -eq 'factory' -and (-not $bi.Half)) { $src = $bk.FullName; break }
        }
        catch { }
      }
      if ($src) { Say ('    来源: 备份文件 ' + $src) 'DarkGray' }
      else { Say '    来源: 无可用备份，按已知补丁逆向还原（8B CA 90 → 0F 45 CA）' 'DarkGray' }
      Say ('    动作: ' + $info.Cur + ('  →  0F 45 CA   @0x{0:X}' -f $info.Offset)) 'DarkGray'

      if ($IsCheck) { $nRestore++; continue }

      $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
      $keep = Join-Path $dir ($name + '.pretool-' + $stamp + '.bak')
      $tmp = Join-Path $dir ($name + '.restore-' + $stamp + '.tmp')
      $oldSha = Get-Sha16 $path
      try {
        if ($src) { Copy-Item -LiteralPath $src -Destination $tmp -Force }
        else {
          $d = [byte[]]$bytes.Clone()
          if ($info.Half) {
            for ($i = [Math]::Max(0, $info.Offset - 12); $i -lt ($info.Offset - 1); $i++) {
              if ($d[$i] -eq 0xB0 -and $d[$i + 1] -eq 0x01) { $d[$i] = 0x84; $d[$i + 1] = 0xC0 }
            }
          }
          $d[$info.Offset] = 0x0F; $d[$info.Offset + 1] = 0x45; $d[$info.Offset + 2] = 0xCA
          [IO.File]::WriteAllBytes($tmp, $d)
        }
        Move-Item -LiteralPath $path -Destination $keep -Force
        try { Move-Item -LiteralPath $tmp -Destination $path -Force }
        catch { Move-Item -LiteralPath $keep -Destination $path -Force; throw }
        $chk = Analyze ([IO.File]::ReadAllBytes($path))
        if ($chk.State -eq 'factory' -and (-not $chk.Half)) {
          Say ('    [成功] 已还原原厂字节，分发点 = ' + $chk.Cur) 'Green'
          Say ('           SHA256: ' + $oldSha + ' → ' + (Get-Sha16 $path)) 'DarkGray'
          Say ('           还原前副本: ' + $keep) 'DarkGray'
          $nRestore++
        }
        else {
          Say '    [校验失败] 还原后字节不符合预期，已回滚' 'Red'
          Move-Item -LiteralPath $path -Destination ($path + '.bad') -Force
          Move-Item -LiteralPath $keep -Destination $path -Force
          $nFail++
        }
      }
      catch {
        Say ('    [失败] ' + $_.Exception.Message) 'Red'
        try { if (Test-Path -LiteralPath $keep) { Move-Item -LiteralPath $keep -Destination $path -Force } } catch { }
        try { if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force } } catch { }
        $nFail++
      }
    }
    Say ''
    if ($IsCheck) { Say ('    [预览] 需要还原: {0} 个   已是原厂: {1} 个   无法自动还原: {2} 个' -f $nRestore, $nAlready, $nNoWay) 'Cyan' }
    else { Say ('    结果: 已还原 {0} 个 / 原厂无需处理 {1} 个 / 无法自动还原 {2} 个' -f $nRestore, $nAlready, $nNoWay) 'Cyan' }
    Say ''
  }
}
# ---------------- ② 任务栏图标（注册表） ----------------
if ($DoIcon) {
  Say '  ── ② 任务栏图标：恢复原厂 IconFile ──' 'Cyan'
  Say ('    原厂目标: IconFile = ' + $FactoryIcon + ' , IconIndex = 0') 'DarkGray'
  $ms = Get-TipState
  if ($ms.Count -eq 0) {
    Say '  [跳过] 注册表里没有找到豆包输入法的输入法配置项。' 'Yellow'
  }
  else {
    $nNeed = 0; $nOk = 0; $nBad = 0
    foreach ($m in $ms) {
      $isFactory = ($m.IconFile -ieq $FactoryIcon) -and ($m.IconIndex -eq 0)
      Say ('  ■ [' + $m.View + ' 位视图] ' + $m.KeyPath) 'White'
      Say ('      当前 IconFile  = ' + $m.IconFile) 'Gray'
      Say ('      当前 IconIndex = ' + $m.IconIndex) 'Gray'
      if ($isFactory) {
        Say '      状态: 已是原厂设置，无需还原' 'Green'
        $nOk++
        continue
      }
      $nNeed++
      if ($IsCheck) { Say '      动作: 将回写为原厂 IconFile / IconIndex 0' 'Cyan'; continue }
      try {
        Set-TipValues $m $FactoryIcon 0
        $ck = (Get-TipState | Where-Object { $_.KeyPath -eq $m.KeyPath })
        if ($ck -and ($ck.IconFile -ieq $FactoryIcon) -and ($ck.IconIndex -eq 0)) {
          Say '      [成功] 已恢复原厂 IconFile / IconIndex 0' 'Green'
        }
        else { Say '      [校验失败] 回读值不符合预期' 'Red'; $nBad++ }
      }
      catch {
        Say ('      [失败] ' + $_.Exception.Message) 'Red'
        $nBad++
      }
    }
    $nFail = $nFail + $nBad
    Say ''
    if ($IsCheck) { Say ('    [预览] 需要还原: {0} 处   已是原厂: {1} 处' -f $nNeed, $nOk) 'Cyan' }
    else { Say ('    结果: 已还原 {0} 处 / 已是原厂 {1} 处 / 失败 {2} 处' -f ($nNeed - $nBad), $nOk, $nBad) 'Cyan' }
    Say ''
  }
}


# ---------------------------- 重启资源管理器 --------------------------------
function Invoke-RestartExplorer {
  if ($IsCheck) { return }
  if ($NoRestart) {
    Say ''
    Say '  [已跳过重启] 检测到 --no-restart，资源管理器保持原状。' 'Yellow'
    Say '                改动将在注销/重启系统或手动重启资源管理器后生效。' 'DarkGray'
    return
  }
  Say ''
  Say '  3 秒后自动重启资源管理器（跳过请使用 --no-restart）。' 'Yellow'
  foreach ($n in @(3, 2, 1)) { Say ('    ' + $n + ' ...') 'DarkGray'; Start-Sleep -Seconds 1 }
  $rsErr = $null
  try {
    $null = & cmd /c 'taskkill /f /im explorer.exe >nul 2>&1'
    Start-Sleep -Milliseconds 1200
    $null = & cmd /c 'start "" explorer.exe'
    Start-Sleep -Milliseconds 1500
  } catch { $rsErr = $_.Exception.Message }
  if (-not $rsErr -and (Get-Process -Name 'explorer' -ErrorAction SilentlyContinue)) {
    Say '  [成功] 资源管理器已重启，任务栏与桌面已恢复。' 'Green'
  } else {
    Say '  [提示] 暂未检测到 explorer 进程，请手动重启资源管理器或注销系统。' 'Yellow'
  }
}

Say '  [提示] 还原后需重启资源管理器让任务栏刷新。' 'Yellow'
Say ''
if ($IsCheck) {
  Say '  [预览结束] 只读检查完成，未做任何改动。去掉 --check 即可实际还原。' 'Cyan'
  Say ''
  exit 0
}
if ($nFail -gt 0) {
  Say ('  [提示] 存在失败项（{0} 处），已保留现场，本次不重启资源管理器。' -f $nFail) 'Yellow'
  Say ''
  exit 3
}
Invoke-RestartExplorer
Say ''
exit 0

#@@E1@@
