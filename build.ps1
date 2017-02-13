param(
    [string]$target = "CI",
    [string]$verbosity = "minimal",
    [int]$maxCpuCount = 0
)
$env:BuildAssemblyVersion = "1.0.0.0"
$env:BuildSemanticVersion = "1.0.0.0"

$msbuilds = @(get-command msbuild -ea SilentlyContinue)
if ($msbuilds.Count -gt 0) {
    $msbuild = $msbuilds[0].Definition
}
else {
    if (test-path "env:\ProgramFiles(x86)") {
        $path = join-path ${env:ProgramFiles(x86)} "MSBuild\14.0\bin\MSBuild.exe"
        if (test-path $path) {
            $msbuild = $path
        }
    }
    if ($msbuild -eq $null) {
        $path = join-path $env:ProgramFiles "MSBuild\14.0\bin\MSBuild.exe"
        if (test-path $path) {
            $msbuild = $path
        }
    }
    if ($msbuild -eq $null) {
        throw "MSBuild could not be found in the path. Please ensure MSBuild v14 (from Visual Studio 2015) is in the path."
    }
}

if ($maxCpuCount -lt 1) {
    $maxCpuCountText = $Env:MSBuildProcessorCount
} else {
    $maxCpuCountText = ":$maxCpuCount"
}

$allArgs = @("visualstudio.xunit.proj", "/m$maxCpuCountText", "/nologo", "/verbosity:$verbosity", "/t:$target", $args)
& $msbuild $allArgs
