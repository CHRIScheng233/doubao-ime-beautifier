@echo off
rem ===========================================================================
rem  doubao-ime-2-replace-icon.bat
rem  Task 2/3 : Doubao IME - replace the taskbar IME icon with a system icon
rem  Author   : CHRIScheng233                 Version : v2.0-final
rem ---------------------------------------------------------------------------
rem  NOTICE (this header zone is intentionally ASCII-only; the full Chinese
rem  notice, watermark and disclaimer live in the payload below)
rem   * PROHIBITED: modifying or redistributing this script in any form.
rem   * If you modify it, YOU bear ALL consequences alone. (gai zhe si ma)
rem   * The author gives NO warranty for any modified copy of this script.
rem   * It only rewrites the Doubao IME taskbar icon registry values; nothing else.
rem  SAFETY
rem   * Embedded SHA-256 self-seal is verified on every start. On mismatch the
rem     script prints a RED warning and asks for confirmation.
rem   * Author only: re-seal after editing with   --reseal
rem   * Only the CTF TIP entries of Doubao IME are touched. Every value is
rem     exported first to  %LOCALAPPDATA%\DoubaoIME-StatusIcon\backup .
rem   * The released icon is content verified (SHA-256): a stale or tampered
rem     icon file is re-released instead of being trusted.
rem   * Fully idempotent: an already applied state is skipped, never rewritten.
rem  USAGE
rem   double click ............ apply + verify + restart explorer (3s countdown)
rem   --check ................. read only preview: zero writes, no restart
rem   --no-restart ............ apply, but never restart explorer
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

"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwBGjAVTk49lUdVsjn8WUyAAMgAvADMAGv9GjAVTk49lUdVsIAC3ACAA+06hUg9oB2M6eWhW/lYHaP9mYmMgACAAfAAgACAAXE8FgCAAQwBIAFIASQBTAGMAaABlAG4AZwAyADMAMwAgACAAfAAgACAAgXlia4xOIWvuTzllLwAGUtFTJwAgAC0ARgBvAHIAZQBnAHIAbwB1AG4AZABDAG8AbABvAHIAIABDAHkAYQBuAA==
set "DOUBAO_PAY=%TEMP%\doubao_ime_2_payload_%RANDOM%%RANDOM%.ps1"
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
"%PSC%" -NoProfile -EncodedCommand dAByAHkAIAB7ACAAWwBDAG8AbgBzAG8AbABlAF0AOgA6AE8AdQB0AHAAdQB0AEUAbgBjAG8AZABpAG4AZwAgAD0AIABbAFMAeQBzAHQAZQBtAC4AVABlAHgAdAAuAEUAbgBjAG8AZABpAG4AZwBdADoAOgBHAGUAdABFAG4AYwBvAGQAaQBuAGcAKAA5ADMANgApACAAfQAgAGMAYQB0AGMAaAAgAHsAIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwBnYkyI035fZwz/CWP7Tg9hLpVzUe2VLGeXeuNTAjAgACAAfAAgACAAQwBIAFIASQBTAGMAaABlAG4AZwAyADMAMwAgALcAIABGjAVTk49lUdVsjn8WUyAAMgAvADMAJwAgAC0ARgBvAHIAZQBnAHIAbwB1AG4AZABDAG8AbABvAHIAIABHAHIAYQB5AA==
pause >nul
exit /b %RC%
#@@B1@@
# ===========================================================================
#  豆包输入法美化 2/3 · 任务栏指示器图标替换   (doubao-ime-2-replace-icon)
#  作者 (Author): CHRIScheng233        版本 (Version): v2.0-final
# ---------------------------------------------------------------------------
#  【禁止二次修改、禁止二次分发】
#    本脚本只做一件事：把豆包输入法的任务栏输入法图标换成系统键盘图标。
#    修改者自行承担全部后果 —— 改者死妈。
#    作者对任何被改动过的副本不作任何担保，也不承担任何责任。
#    脚本内嵌自身 SHA256 签名，每次启动自动校验；不一致会红字警告并要求确认。
#    作者本人改完脚本后，执行 --reseal 重新签名即可消除误报。
#  本脚本只写 CTF TIP 的 IconFile / IconIndex 注册表值（改前自动导出备份），
#  不碰系统文件、不改全局输入法设置、不动其它任何注册表项。
# ===========================================================================
#@@SIG@@ 481A2003A9032A1E76ED40287E3CA49E866579CB75CE62F5D3528DF13DDE51A2
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(936) } catch { }
try { [Console]::Title = '豆包输入法美化 2/3 - 指示器图标替换  |  CHRIScheng233' } catch { }
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
  Say '  doubao-ime-2-replace-icon  |  豆包输入法 · 任务栏指示器图标替换' 'Cyan'
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

# ---------------------------- 内嵌图标与路径 -------------------------------
$IcoB64 = @'
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
'@
$IcoBytes = [Convert]::FromBase64String(($IcoB64 -replace '\s', ''))
$EmbedIcoSha = ([BitConverter]::ToString(([Security.Cryptography.SHA256]::Create()).ComputeHash($IcoBytes))).Replace('-', '')
$Base = Join-Path $env:LOCALAPPDATA 'DoubaoIME-StatusIcon'
$TargetIco = Join-Path $Base 'status.ico'
$BackupDir = Join-Path $Base 'backup'
$Script:IcoTemp = $null

# 惰性释放：--check 只在 %TEMP% 落一个临时帧文件；实际执行才使用。
function Get-IcoPath {
  $p = "$env:DOUBAO_ICO"
  if ($p -and (Test-Path -LiteralPath $p)) { return $p }
  $tag = Join-Path $env:TEMP ('doubao_ime_status_icon_' + $PID + '_' + (Get-Random) + '.ico')
  [IO.File]::WriteAllBytes($tag, $IcoBytes)
  $Script:IcoTemp = $tag
  return $tag
}
function Clear-IcoTemp {
  if ($Script:IcoTemp -and (Test-Path -LiteralPath $Script:IcoTemp)) {
    Remove-Item -LiteralPath $Script:IcoTemp -Force -ErrorAction SilentlyContinue
  }
}


function Get-IcoInfoBytes([byte[]]$d) {
  if ($null -eq $d -or $d.Length -lt 22) { return $null }
  if ($d[0] -ne 0 -or $d[1] -ne 0 -or $d[2] -ne 1 -or $d[3] -ne 0) { return $null }
  $n = [BitConverter]::ToUInt16($d, 4)
  $sizes = New-Object System.Collections.ArrayList
  for ($i = 0; $i -lt $n; $i++) {
    $o = 6 + $i * 16
    if (($o + 1) -ge $d.Length) { break }
    $w = [int]$d[$o]; $h = [int]$d[$o + 1]
    if ($w -eq 0) { $w = 256 }
    if ($h -eq 0) { $h = 256 }
    [void]$sizes.Add(($w.ToString() + 'x' + $h.ToString()))
  }
  return @{ Count = $n; Sizes = ($sizes -join ', ') }
}
function Get-IcoInfo([string]$p) {
  if (-not (Test-Path -LiteralPath $p)) { return $null }
  return (Get-IcoInfoBytes ([IO.File]::ReadAllBytes($p)))
}

function Get-TipMatches {
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
              View     = $v.Name
              Sub      = $sub
              KeyPath  = 'HKLM\' + $sub
              Desc     = $desc
              IconFile = $icon
              IconIndex = [int]$idx
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

Say ('  目标图标: ' + $TargetIco) 'DarkGray'
$ico = $null
if ($IsCheck) { $ico = Get-IcoInfoBytes $IcoBytes }
else { $IcoSrc = Get-IcoPath
$ico = Get-IcoInfo $IcoSrc }
if ($null -eq $ico) {
  Say '  [错误] 内嵌图标未能正确释放（内部载荷异常）。' 'Red'
  exit 2
}
Say ('  内嵌图标: {0} 帧  {1}' -f $ico.Count, $ico.Sizes) 'DarkGray'
Say ''

$ms = Get-TipMatches
if ($ms.Count -eq 0) {
  Say '  [未安装 / 未找到] 注册表里没有找到豆包输入法的输入法配置项。' 'Yellow'
  Say '  本工具只作用于已安装的豆包输入法 PC 版，无需继续。已安全退出，未做任何改动。' 'Yellow'
  exit 1
}

Say ('  找到 {0} 处豆包输入法配置项:' -f $ms.Count) 'White'
foreach ($m in $ms) {
  Say ('    [' + $m.View + ' 位视图] ' + $m.KeyPath) 'DarkGray'
  Say ('        Description = ' + $m.Desc) 'DarkGray'
  Say ('        当前 IconFile  = ' + $m.IconFile) 'Gray'
  Say ('        当前 IconIndex = ' + $m.IconIndex) 'Gray'
}

$need = @()
foreach ($m in $ms) {
  if ((-not ($m.IconFile -ieq $TargetIco)) -or ($m.IconIndex -ne 0)) { $need += $m }
}
$icoOk = $false
if (Test-Path -LiteralPath $TargetIco) {
  try { $icoOk = ((Get-FileHash -LiteralPath $TargetIco -Algorithm SHA256).Hash -ieq $EmbedIcoSha) }
  catch { $icoOk = $false }
}
Say ''
Say ('  目标状态: IconFile = ' + $TargetIco + ' , IconIndex = 0') 'Cyan'
Say ('  需要修改: {0} 处   目标图标存在且内容一致: {1}' -f $need.Count, $icoOk) 'Cyan'
Say ''

if ($IsCheck) {
  Say '  [预览结束] 只读检查完成，未写入注册表、未释放图标文件。' 'Cyan'
  Say '  去掉 --check 参数再次运行即可实际执行。' 'Cyan'
  exit 0
}

if ($need.Count -eq 0 -and $icoOk) {
  Say '  [已完成] 注册表已指向目标图标，且图标内容 SHA256 校验一致（幂等跳过）。' 'Green'
  exit 0
}

New-Item -ItemType Directory -Force -Path $Base | Out-Null
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

# 0) 备份旧图标
if (Test-Path -LiteralPath $TargetIco) {
  $oldBak = Join-Path $BackupDir ('status.ico.bak-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
  Copy-Item -LiteralPath $TargetIco -Destination $oldBak -Force
  Say ('  [备份] ' + $oldBak) 'DarkGray'
}

# 1) 释放图标
try {
  Copy-Item -LiteralPath $IcoSrc -Destination $TargetIco -Force
  $chk = Get-IcoInfo $TargetIco
  Say ('  [成功] 图标已释放: ' + $TargetIco + '  (' + $chk.Sizes + ')') 'Green'
}
catch {
  Say ('  [失败] 释放图标失败: ' + $_.Exception.Message) 'Red'
  exit 3
}

# 2) 备份注册表（每个视图一次）
try {
  $reg = Join-Path $env:SystemRoot 'System32\reg.exe'
  $doneView = @{}
  foreach ($m in $ms) {
    if ($doneView.ContainsKey($m.View)) { continue }
    $doneView[$m.View] = $true
    $file = Join-Path $BackupDir ('TIP-view' + $m.View + '-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.reg')
    & $reg export $m.KeyPath $file /y | Out-Null
    if (Test-Path -LiteralPath $file) { Say ('  [备份] ' + $file) 'DarkGray' }
    else { Say ('  [警告] 注册表导出失败(可忽略，稍后仍会写值): ' + $m.KeyPath) 'Yellow' }
  }
}
catch { Say ('  [警告] 注册表备份异常: ' + $_.Exception.Message) 'Yellow' }

# 3) 写值（失败不中断，统一在回读阶段判定）
$ok2 = 0; $bad2 = 0
foreach ($m in $ms) {
  try { Set-TipValues $m $TargetIco 0 }
  catch {
    Say ('  [失败] ' + $m.KeyPath) 'Red'
    Say ('         ' + $_.Exception.Message) 'Red'
    $bad2++
  }
}

# 4) 一次性回读校验：只枚举一次注册表（旧版每项都全量枚举，O(n^2)）
$afterIdx = @{}
try { foreach ($x in (Get-TipMatches)) { $afterIdx[$x.KeyPath] = $x } } catch { }

foreach ($m in $ms) {
  $ck = $afterIdx[$m.KeyPath]
  if ($ck -and ($ck.IconFile -ieq $TargetIco) -and ($ck.IconIndex -eq 0)) {
    Say ('  [成功] ' + $m.KeyPath) 'Green'
    Say ('         IconFile: ' + $m.IconFile) 'DarkGray'
    Say ('             -> ' + $TargetIco + '  (IconIndex 0)') 'DarkGray'
    $ok2++
  }
  else {
    Say ('  [校验失败] ' + $m.KeyPath + ' —— 回读值不符合预期，自动回滚原值') 'Red'
    try { Set-TipValues $m $m.IconFile $m.IconIndex }
    catch { Say '         [回滚失败] 请手动恢复该注册表项。' 'Red' }
    $bad2++
  }
}

Clear-IcoTemp
Say ''
Say ('  结果: 成功 {0} 处 / 失败 {1} 处' -f $ok2, $bad2) 'Cyan'
Say ''
if ($bad2 -gt 0) {
  Say '  [提示] 存在失败项，已保留现场，本次不重启资源管理器。' 'Yellow'
  Say ''
  exit 3
}
Say '  [提示] 若任务栏仍未刷新，可手动重启 explorer.exe 或注销一次。' 'DarkGray'
if ($ok2 -gt 0) {
  Invoke-RestartExplorer
}
Say ''
exit 0



#@@E1@@
