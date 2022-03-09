$text = Get-Content './test.ps1' -Raw # text is a multiline string, not an array!

$tokens = $null
$errors = $null
[Management.Automation.Language.Parser]::ParseInput($text, [ref]$tokens, [ref]$errors).
    FindAll([Func[Management.Automation.Language.Ast,bool]]{
        param ($ast)
        $ast.CommandElements -and
        $ast.CommandElements[0].Value -eq 'describe'
    }, $true) |
    ForEach-Object {
        $CE = $_.CommandElements
        $secondString = ($CE | Where-Object { $_.StaticType.name -eq 'string' })[1]
        $tagIdx = $CE.IndexOf(($CE | Where-Object ParameterName -eq 'Tag')) + 1
        $tags = if ($tagIdx -and $tagIdx -lt $CE.Count) {
            $CE[$tagIdx].Extent
        }
        New-Object PSCustomObject -Property @{
            Name = $secondString
            Tags = $tags
        }
    }