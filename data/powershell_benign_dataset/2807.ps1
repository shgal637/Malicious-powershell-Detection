


if (Get-Command logparser.exe) {
    $lpquery = @"
    SELECT
        COUNT(Value) as ct,
        Value
    FROM
        *LogUserAssist.tsv
    GROUP BY
        Value
    ORDER BY
        ct ASC
"@

    & logparser -stats:off -i:csv -dtlines:0 -fixedsep:on -rtp:-1 "$lpquery"

} else {
    $ScriptName = [System.IO.Path]::GetFileName($MyInvocation.ScriptName)
    "${ScriptName} requires logparser.exe in the path."
}
