# Generate dot-matrix LED heart icon (1024x1024)
Add-Type -AssemblyName System.Drawing

$size = 1024
$bmp = New-Object System.Drawing.Bitmap($size, $size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

$bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 7, 9, 12))
$g.FillRectangle($bg, 0, 0, $size, $size)

$grid = 16
$cell = $size / $grid
$dotR = $cell * 0.36

$dimBrush  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(12, 255, 255, 255))
$glowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, 47, 230, 166))
$onBrush   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 47, 230, 166))

function Test-Heart([double]$px, [double]$py) {
    # heart curve: (x^2 + y^2 - 1)^3 - x^2 * y^3 <= 0
    $x = ($px - 7.5) / 5.2
    $y = -(($py - 8.2) / 5.2)
    $v = [math]::Pow(($x*$x + $y*$y - 1), 3) - ($x*$x) * [math]::Pow($y, 3)
    return ($v -le 0)
}

for ($r = 0; $r -lt $grid; $r++) {
    for ($c = 0; $c -lt $grid; $c++) {
        $cx = $c * $cell + $cell / 2
        $cy = $r * $cell + $cell / 2
        if (Test-Heart $c $r) {
            $gr = $dotR * 1.65
            $g.FillEllipse($glowBrush, $cx - $gr, $cy - $gr, $gr * 2, $gr * 2)
            $g.FillEllipse($onBrush, $cx - $dotR, $cy - $dotR, $dotR * 2, $dotR * 2)
        } else {
            $g.FillEllipse($dimBrush, $cx - $dotR, $cy - $dotR, $dotR * 2, $dotR * 2)
        }
    }
}

New-Item -ItemType Directory -Force assets | Out-Null
$bmp.Save("$PWD\assets\icon.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()

# Splash (2732x2732, icon centered)
$sp = New-Object System.Drawing.Bitmap(2732, 2732)
$sg = [System.Drawing.Graphics]::FromImage($sp)
$sg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$sbg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 7, 9, 12))
$sg.FillRectangle($sbg, 0, 0, 2732, 2732)
$icon = [System.Drawing.Image]::FromFile("$PWD\assets\icon.png")
$iw = 700
$sg.DrawImage($icon, (2732 - $iw) / 2, (2732 - $iw) / 2, $iw, $iw)
$sp.Save("$PWD\assets\splash.png", [System.Drawing.Imaging.ImageFormat]::Png)
$sp.Save("$PWD\assets\splash-dark.png", [System.Drawing.Imaging.ImageFormat]::Png)
$icon.Dispose(); $sg.Dispose(); $sp.Dispose()

Write-Output "Icon and splash generated"
ls assets
