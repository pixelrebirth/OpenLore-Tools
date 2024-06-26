$ExclusionList = @(
        '*.tests.*',
        'RunPester.ps1',
        'DscLocalTest.ps1',
        'GenerateDscPsm.ps1',
        'Install-OpenLoreModule.ps1',
        'Test.ps1'
)

$AllFiles = Get-ChildItem -Path "$PSScriptRoot\*.ps1" -Recurse -Exclude $ExclusionList
$AllFiles | ForEach-Object {. $_}