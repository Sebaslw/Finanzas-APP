# Servidor local para la app Finanzas (sin instalar nada: usa PowerShell de Windows)
$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath((Split-Path -Parent $MyInvocation.MyCommand.Path))
if (-not $root.EndsWith('\')) { $root += '\' }

# Busca un puerto libre empezando por 8080
$listener = $null; $port = 0
for ($p = 8080; $p -lt 8100; $p++) {
  try {
    $l = New-Object System.Net.HttpListener
    $l.Prefixes.Add("http://localhost:$p/")
    $l.Start(); $listener = $l; $port = $p; break
  } catch { }
}
if (-not $listener) { Write-Host ' No hay un puerto libre entre 8080 y 8099.' -ForegroundColor Red; exit 1 }

$url = "http://localhost:$port/"
Write-Host ''
Write-Host '  ==========================================' -ForegroundColor DarkYellow
Write-Host '   Finanzas esta corriendo en:' -ForegroundColor White
Write-Host "   $url" -ForegroundColor Green
Write-Host '   Para detenerlo: Ctrl+C o cierra esta ventana' -ForegroundColor Gray
Write-Host '  ==========================================' -ForegroundColor DarkYellow
Write-Host ''
if ($port -ne 8080) { Write-Host '  Aviso: el puerto 8080 estaba ocupado. Tus datos se guardan por puerto,' -ForegroundColor Yellow; Write-Host '  asi que en otro puerto veras la app vacia.' -ForegroundColor Yellow; Write-Host '' }
Start-Process $url

$mime = @{
  '.html'='text/html; charset=utf-8'; '.htm'='text/html; charset=utf-8'
  '.js'='application/javascript; charset=utf-8'; '.css'='text/css; charset=utf-8'
  '.json'='application/json; charset=utf-8'; '.md'='text/plain; charset=utf-8'; '.txt'='text/plain; charset=utf-8'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.svg'='image/svg+xml'; '.ico'='image/x-icon'; '.webp'='image/webp'
}

try {
  while ($listener.IsListening) {
    $task = $listener.GetContextAsync()
    while (-not $task.AsyncWaitHandle.WaitOne(250)) { }   # permite Ctrl+C
    $ctx = $task.GetAwaiter().GetResult()
    $req = $ctx.Request; $res = $ctx.Response
    try {
      $path = [Uri]::UnescapeDataString($req.Url.AbsolutePath).TrimStart('/')
      if ([string]::IsNullOrEmpty($path) -or $path.EndsWith('/')) { $path = $path + 'index.html' }
      $full = [IO.Path]::GetFullPath((Join-Path $root $path))
      if ($full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $full -PathType Leaf)) {
        $ext = [IO.Path]::GetExtension($full).ToLower()
        if ($mime.ContainsKey($ext)) { $res.ContentType = $mime[$ext] } else { $res.ContentType = 'application/octet-stream' }
        $bytes = [IO.File]::ReadAllBytes($full)
      } else {
        $res.StatusCode = 404
        $res.ContentType = 'text/plain; charset=utf-8'
        $bytes = [Text.Encoding]::UTF8.GetBytes('No encontrado')
      }
      $res.Headers.Add('Cache-Control', 'no-cache')
      $res.ContentLength64 = $bytes.Length
      $res.OutputStream.Write($bytes, 0, $bytes.Length)
      Write-Host ('  {0}  {1}  {2}' -f (Get-Date -Format 'HH:mm:ss'), $res.StatusCode, $req.Url.AbsolutePath)
    } catch {
      Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
      try { $res.OutputStream.Close() } catch { }
    }
  }
} finally {
  $listener.Stop(); $listener.Close()
}
