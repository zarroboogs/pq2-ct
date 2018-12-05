
$in = if ($args[0]) { $args[0] } else { return }
$out = if ($args[1]) { $args[1] } else { "out.CT" }

$ct = [xml](gc $in)

$ct.SelectNodes("//LastState") | % { 
    [void]$_.ParentNode.RemoveChild($_)
}

$ct.SelectNodes("//CheatEntries[not(@*) and not(*)]") | % {
    [void]$_.ParentNode.RemoveChild($_)
}

$ct.SelectNodes("//Color[text()='000000']") | % {
    [void]$_.ParentNode.RemoveChild($_)
}

$ct.SelectNodes("//*[starts-with(local-name(),'ShowAs') and text()='0']") | % {
    [void]$_.ParentNode.RemoveChild($_)
}

$i = 0
$ct.SelectNodes("//ID") | % {
    $_.'#text' = [string]$i++
}

$utf8 = [System.Text.UTF8Encoding]::new($false)
$sw = [System.IO.StreamWriter]::new("$PSScriptRoot\$out", $false, $utf8)

$ct.Save($sw)
$sw.Close()