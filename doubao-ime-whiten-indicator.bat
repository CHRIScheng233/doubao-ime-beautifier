@echo off
rem ===========================================================================
rem  doubao-ime-1-whiten-indicator.bat
rem  Task 1/3 : Doubao IME - whiten the CN/EN taskbar indicator glyph
rem  Author   : CHRIScheng233                 Version : v2.0-final
rem ---------------------------------------------------------------------------
rem  NOTICE (this header zone is intentionally ASCII-only; the full Chinese
rem  notice, watermark and disclaimer live in the payload below)
rem   * PROHIBITED: modifying or redistributing this script in any form.
rem   * If you modify it, YOU bear ALL consequences alone. (gai zhe si ma)
rem   * The author gives NO warranty for any modified copy of this script.
rem   * It only makes the Doubao IME indicator glyph white; nothing else.
rem  SAFETY
rem   * Embedded SHA-256 self-seal is verified on every start. On mismatch the
rem     script prints a RED warning and asks for confirmation.
rem   * Author only: re-seal after editing with   --reseal
rem   * Patches are anchor based. If the anchor bytes or the dispatch offset do
rem     NOT match the expected values (e.g. Doubao was upgraded), the script
rem     exits safely and writes ZERO bytes.
rem   * Every patched file is backed up first as  <name>.bak-<timestamp>.
rem   * Fully idempotent: an already whitened file is skipped, never rewritten.
rem  USAGE
rem   double click ............ patch + verify + restart explorer (3s countdown)
rem   --check ................. read only preview: zero writes, no restart
rem   --no-restart ............ patch, but never restart explorer
rem   --reseal ................ recompute the embedded SHA-256 seal (author only)
rem   --dir <folder> .......... override the DoubaoIME install root (advanced)
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
)
set "DOUBAO_CHECK=%CHK%"
set "DOUBAO_NORESTART=%NORESTART%"
set "DOUBAO_RESEAL=%RESEAL%"

net session >nul 2>&1
if not errorlevel 1 goto doubao_elev_ok
if defined CHK goto doubao_elev_ok
if defined RESEAL goto doubao_elev_ok
echo.
"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwAsZ+Vdd1EAl4GJoXsGdFhUQ2dQlgz/Y2soVzlf+lEgAFUAQQBDACAA0GNDZ5d641MM//eLKFc5X5d6LU65cPtRDDAvZg0wAjAnACAALQBGAG8AcgBlAGcAcgBvAHUAbgBkAEMAbwBsAG8AcgAgAFkAZQBsAGwAbwB3AA==
"%PSC%" -NoProfile -ExecutionPolicy Bypass -Command "if ([string]::IsNullOrEmpty($env:DOUBAO_ARGV)) { Start-Process -FilePath $env:DOUBAO_SELF -Verb RunAs } else { Start-Process -FilePath $env:DOUBAO_SELF -ArgumentList $env:DOUBAO_ARGV -Verb RunAs }"
exit /b 0
:doubao_elev_ok

"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwBGjAVTk49lUdVsjn8WUyAAMQAvADMAGv/7TqFSD2iTj2VRB2M6eWhWOWV9dgj/LU4vAPGCLwBBACAAV1tiXwn/IAAgAHwAIAAgAFxPBYAgAEMASABSAEkAUwBjAGgAZQBuAGcAMgAzADMAIAAgAHwAIAAgAIF5YmuMTiFr7k85ZS8ABlLRUycAIAAtAEYAbwByAGUAZwByAG8AdQBuAGQAQwBvAGwAbwByACAAQwB5AGEAbgA=
set "DOUBAO_PAY=%TEMP%\doubao_ime_1_payload_%RANDOM%%RANDOM%.ps1"
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
"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwBnYkyI035fZwz/CWP7Tg9hLpVzUe2VLGeXeuNTAjAgACAAfAAgACAAQwBIAFIASQBTAGMAaABlAG4AZwAyADMAMwAgALcAIABGjAVTk49lUdVsjn8WUyAAMQAvADMAJwAgAC0ARgBvAHIAZQBnAHIAbwB1AG4AZABDAG8AbABvAHIAIABHAHIAYQB5AA==
pause >nul
exit /b %RC%
#@@B1@@
# ===========================================================================
#  豆包输入法美化 1/3 · 任务栏中英指示器改白   (doubao-ime-1-whiten-indicator)
#  作者 (Author): CHRIScheng233        版本 (Version): v2.0-final
# ---------------------------------------------------------------------------
#  【禁止二次修改、禁止二次分发】
#    本脚本只做一件事：把豆包输入法的中/英/A 指示器字形改白。
#    修改者自行承担全部后果 —— 改者死妈。
#    作者对任何被改动过的副本不作任何担保，也不承担任何责任。
#    脚本内嵌自身 SHA256 签名，每次启动自动校验；不一致会红字警告并要求确认。
#    作者本人改完脚本后，执行 --reseal 重新签名即可消除误报。
#  补丁为锚点式：锚点字节或分发点偏移与预期不符时（通常是豆包输入法升级了），
#  脚本会安全退出，不写入任何字节，避免把新版文件改坏。
# ===========================================================================
#@@SIG@@ D2CE678EBD1E6286F68B31670481CE83C578B603109F3FDCA9F85E6AAEE7B400
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(936) } catch { }
try { [Console]::Title = '豆包输入法美化 1/3 - 指示器改白  |  CHRIScheng233' } catch { }
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
  Say '  doubao-ime-1-whiten-indicator  |  豆包输入法 · 任务栏中英指示器改白' 'Cyan'
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

# ---------------------------- 定位与版本守卫 -------------------------------
$ANCHOR = [byte[]]@(0xB9,0x65,0x00,0x00,0x00,0xBA,0x6A,0x00,0x00,0x00)
$Expect = @{
  'x64' = @{ Anchor = 0xD2EB; Dispatch = 0xD2FA }
  'x86' = @{ Anchor = 0xB9F6; Dispatch = 0xBA03 }
}

function Get-Roots {
  $list = New-Object System.Collections.ArrayList
  if ($OnlyDir) {
    if (Test-Path -LiteralPath $OnlyDir) { [void]$list.Add((Resolve-Path -LiteralPath $OnlyDir).Path) }
    return ,$list
  }
  foreach ($q in @("$env:ProgramFiles\DoubaoIME", "${env:ProgramFiles(x86)}\DoubaoIME", "$env:LOCALAPPDATA\Programs\DoubaoIME")) {
    if ($q -and (Test-Path -LiteralPath $q)) { [void]$list.Add((Resolve-Path -LiteralPath $q).Path) }
  }
  return ,$list
}

function Find-All([byte[]]$hay, [byte[]]$needle) {
  $res = New-Object System.Collections.ArrayList
  $enc2 = [Text.Encoding]::GetEncoding(28591)
  $s = $enc2.GetString($hay)
  $q = $enc2.GetString($needle)
  $i = $s.IndexOf($q)
  while ($i -ge 0) {
    [void]$res.Add($i)
    if (($i + 1) -ge $s.Length) { break }
    $i = $s.IndexOf($q, $i + 1)
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
function Analyze([byte[]]$d) {
  $r = @{ State = 'noanchor'; Anchors = 0; Anchor = -1; Offset = -1; Cur = ''; Half = $false; Why = '' }
  $pos = Find-All $d $ANCHOR
  $r.Anchors = [int]$pos.Count
  if ($pos.Count -eq 0) { $r.Why = '未找到锚点字节 B9 65 00 00 00 BA 6A 00 00 00'; return $r }
  $a = [int]$pos[0]
  $r.Anchor = $a
  $disp = -1
  $stop = [Math]::Min($a + 64, $d.Length - 3)
  for ($i = $a + $ANCHOR.Length; $i -le $stop; $i++) {
    if ($d[$i] -eq 0x0F -and $d[$i + 1] -eq 0x45 -and $d[$i + 2] -eq 0xCA) { $disp = $i; break }
    if ($d[$i] -eq 0x8B -and $d[$i + 1] -eq 0xCA -and $d[$i + 2] -eq 0x90) { $disp = $i; break }
  }
  if ($disp -lt 0) { $r.State = 'anchor-only'; $r.Why = '找到锚点但未定位到字形分发点'; return $r }
  $r.Offset = $disp
  $r.Cur = ('{0:X2} {1:X2} {2:X2}' -f $d[$disp], $d[$disp + 1], $d[$disp + 2])
  for ($i = [Math]::Max(0, $disp - 12); $i -lt ($disp - 1); $i++) {
    if ($d[$i] -eq 0xB0 -and $d[$i + 1] -eq 0x01) { $r.Half = $true }
  }
  if ($d[$disp] -eq 0x8B) { $r.State = 'patched' } else { $r.State = 'factory' }
  return $r
}

function Get-Sha16([string]$q) { return (Get-FileHash -LiteralPath $q -Algorithm SHA256).Hash.Substring(0, 16) }

$roots = Get-Roots
$files = New-Object System.Collections.ArrayList
foreach ($rt in $roots) {
  Get-ChildItem -LiteralPath $rt -Recurse -Filter 'tsf-oime-core.dll' -File -ErrorAction SilentlyContinue |
    Sort-Object FullName | ForEach-Object { [void]$files.Add($_) }
}

if ($files.Count -eq 0) {
  Say '  [未安装 / 未找到] 没有找到豆包输入法的核心文件 tsf-oime-core.dll。' 'Yellow'
  Say '  本工具只作用于已安装的豆包输入法 PC 版，无需继续。已安全退出，未做任何改动。' 'Yellow'
  Say ''
  exit 1
}

Say ('  安装目录: ' + ($roots -join '  ;  ')) 'DarkGray'
Say ('  核心文件: 共 {0} 个' -f $files.Count) 'DarkGray'
Say ''

$nPatch = 0; $nSkip = 0; $nBad = 0; $nFail = 0
$plan = New-Object System.Collections.ArrayList

foreach ($f in $files) {
  $path = $f.FullName
  $bytes = $null
  try { $bytes = [IO.File]::ReadAllBytes($path) }
  catch {
    Say ('  [读取失败] ' + $path) 'Red'
    Say ('             ' + $_.Exception.Message) 'Red'
    $nFail++
    continue
  }
  $arch = Get-Arch $bytes
  $info = Analyze $bytes
  $sha = ''
  try { $sha = Get-Sha16 $path } catch { }

  Say ('  ■ ' + $path) 'White'
  Say ('    架构=' + $arch + '   大小=' + $bytes.Length + ' 字节   SHA256=' + $sha) 'DarkGray'

  $exp = $null
  if ($Expect.ContainsKey($arch)) { $exp = $Expect[$arch] }

  if (($info.State -eq 'factory') -or ($info.State -eq 'patched')) {
    if (-not $exp) {
      $info.State = 'unsupported'; $info.Why = ('未知架构 ' + $arch + '，无法确认锚点/偏移')
    }
    elseif (($info.Anchor -ne [int]$exp.Anchor) -or ($info.Offset -ne [int]$exp.Dispatch)) {
      $info.Why = ('锚点 0x{0:X}（期望 0x{1:X}）/ 分发点 0x{2:X}（期望 0x{3:X}）' -f $info.Anchor, [int]$exp.Anchor, $info.Offset, [int]$exp.Dispatch)
      $info.State = 'unsupported'
    }
  }
  else { $info.State = 'unsupported' }

  switch ($info.State) {
    'unsupported' {
      Say ('    状态: 版本不匹配 —— ' + $info.Why) 'Yellow'
      Say '          本文件不写入任何字节' 'Yellow'
      $nBad++
    }
    'patched' {
      if ($info.Half) {
        Say '    状态: 已有旧版「半吊子补丁」(B0 01)，本次将补正为完整补丁' 'Yellow'
        $nPatch++
        [void]$plan.Add($path)
      }
      else {
        Say ('    状态: 已改白（分发点 0x{0:X} = {1}），跳过' -f $info.Offset, $info.Cur) 'Green'
        $nSkip++
      }
    }
    'factory' {
      Say ('    状态: 原厂未改（分发点 0x{0:X} = {1}）—— 需要补丁' -f $info.Offset, $info.Cur) 'Yellow'
      $nPatch++
      [void]$plan.Add($path)
    }
  }
  Say ''
}
if ($nBad -gt 0) {
  Say ('  [安全退出] 有 {0} 个核心文件的锚点字节或偏移与本脚本预期不符（通常是豆包输入法升级了）。' -f $nBad) 'Red'
  Say '             为保证安全，本次不写入任何字节，脚本直接退出。' 'Red'
  Say ('             请获取与当前版本匹配的新脚本，或联系作者 ' + $AUTHOR + '。') 'Red'
  Say ''
  exit 3
}

if ($nPatch -gt 0) {
  Say ('  计划: 对 {0} 个文件执行「分发点 0F 45 CA → 8B CA 90」（x64/x86 同构）' -f $nPatch) 'Cyan'
  Say '        改前自动备份为 <文件名>.bak-时间戳，改后回读校验' 'DarkGray'
}
if ($nSkip -gt 0) { Say ('  无需处理: {0} 个文件已改白' -f $nSkip) 'DarkGray' }
Say ''

if ($IsCheck) {
  Say '  [预览结束] 只读检查完成，未写入任何内容，也未重启资源管理器。' 'Cyan'
  Say '  去掉 --check 参数再次运行即可实际执行。' 'Cyan'
  Say ''
  exit 0
}

if ($nPatch -eq 0) {
  Say '  [已完成] 所有核心文件均已是改白状态，无需重复处理（幂等跳过），本次不重启资源管理器。' 'Green'
  Say ''
  Say ('  ' + $AUTHOR + '  |  禁止二次修改 / 禁止二次分发；改者死妈。') 'DarkGray'
  Say ''
  exit 0
}

$ok = 0
foreach ($path in $plan) {
  $bytes = [IO.File]::ReadAllBytes($path)
  $arch = Get-Arch $bytes
  $info = Analyze $bytes
  $exp = $null
  if ($Expect.ContainsKey($arch)) { $exp = $Expect[$arch] }
  $need = $false
  if ($info.State -eq 'factory') { $need = $true }
  if ($info.State -eq 'patched' -and $info.Half) { $need = $true }
  if (-not $need) { continue }
  if ((-not $exp) -or ($info.Offset -ne [int]$exp.Dispatch)) {
    Say ('  [写入前守卫] 分发点偏移与预期不符，已跳过（未写入）: ' + $path) 'Red'
    $nFail++
    continue
  }

  $oldSha = Get-Sha16 $path
  $dir = Split-Path -Parent $path
  $name = [IO.Path]::GetFileName($path)
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $bak = Join-Path $dir ($name + '.bak-' + $stamp)
  $tmp = Join-Path $dir ($name + '.tmp-' + $stamp)

  try {
    $d = [byte[]]$bytes.Clone()
    if ($info.Half) {
      for ($i = [Math]::Max(0, $info.Offset - 12); $i -lt ($info.Offset - 1); $i++) {
        if ($d[$i] -eq 0xB0 -and $d[$i + 1] -eq 0x01) { $d[$i] = 0x84; $d[$i + 1] = 0xC0 }
      }
    }
    $d[$info.Offset] = 0x8B; $d[$info.Offset + 1] = 0xCA; $d[$info.Offset + 2] = 0x90
    [IO.File]::WriteAllBytes($tmp, $d)

    Move-Item -LiteralPath $path -Destination $bak -Force
    try { Move-Item -LiteralPath $tmp -Destination $path -Force }
    catch { Move-Item -LiteralPath $bak -Destination $path -Force; throw }

    $chk = Analyze ([IO.File]::ReadAllBytes($path))
    if ($chk.State -eq 'patched' -and (-not $chk.Half)) {
      Say ('  [成功] ' + $path) 'Green'
      Say ('         分发点 0x{0:X}: {1} → {2}' -f $info.Offset, $info.Cur, $chk.Cur) 'Green'
      Say ('         SHA256: ' + $oldSha + ' → ' + (Get-Sha16 $path)) 'DarkGray'
      Say ('         备份:   ' + $bak) 'DarkGray'
      $ok++
    }
    else {
      Say ('  [校验失败] ' + $path + ' —— 已回滚') 'Red'
      Move-Item -LiteralPath $path -Destination ($tmp + '.bad') -Force
      Move-Item -LiteralPath $bak -Destination $path -Force
      $nFail++
    }
  }
  catch {
    Say ('  [失败] ' + $path) 'Red'
    Say ('         ' + $_.Exception.Message) 'Red'
    $tmpBak = $bak
    try { if (Test-Path -LiteralPath $tmpBak) { Move-Item -LiteralPath $tmpBak -Destination $path -Force } } catch { }
    try { if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force } } catch { }
    $nFail++
  }
  Say ''
}
# ---------------------------- 重启资源管理器 --------------------------------
if ($ok -gt 0) {
  if ($NoRestart) {
    Say '  [已跳过重启] 检测到 --no-restart，资源管理器保持原状。' 'Yellow'
    Say '                新字形由已运行的输入法进程绘制，可稍后注销/重启系统或手动重启资源管理器。' 'DarkGray'
    Say ''
  }
  else {
    Say '  改白完成。桌面将闪一下，未保存内容请先保存！' 'Yellow'
    Say '  3 秒后自动重启资源管理器（跳过请使用 --no-restart）。' 'Yellow'
    for ($s = 3; $s -ge 1; $s--) {
      Say ('    倒计时 {0} ...' -f $s) 'Yellow'
      Start-Sleep -Seconds 1
    }
    Say '  正在重启资源管理器: taskkill /f /im explorer.exe ...' 'Yellow'
    $null = & cmd /c 'taskkill /f /im explorer.exe >nul 2>&1'
    Start-Sleep -Milliseconds 800
    Say '  正在重新启动资源管理器: start "" explorer.exe ...' 'Yellow'
    $null = & cmd /c 'start "" explorer.exe'
    Start-Sleep -Milliseconds 1500
    if (Get-Process -Name 'explorer' -ErrorAction SilentlyContinue) {
      Say '  [成功] 资源管理器已重启，任务栏与桌面已恢复。' 'Green'
    }
    else {
      Say '  [提示] 暂未检测到 explorer 进程，请手动重启资源管理器或注销系统。' 'Yellow'
    }
    Say ''
  }
}

Say ('  结果: 已补丁 {0} 个 / 已跳过 {1} 个 / 失败 {2} 个 / 版本不匹配 {3} 个' -f $ok, $nSkip, $nFail, $nBad) 'Cyan'
Say ''
Say ('  ' + $AUTHOR + '  |  豆包输入法美化 1/3 · 指示器改白') 'DarkGray'
Say '  禁止二次修改、禁止二次分发；修改者自行承担全部后果（改者死妈）。' 'DarkGray'
Say ''

if ($nFail -gt 0) { exit 3 }
exit 0
#@@E1@@
