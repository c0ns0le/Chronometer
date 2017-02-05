$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf


Describe "Help tests for $moduleName" -Tags Build {
    
    Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

    $functions = Get-Command -Module $moduleName
    $help = $functions | %{Get-Help $_.name}
    foreach($node in $help)
    {
        Context $node.name {

            it "has a description" {
                $node.description | Should Not BeNullOrEmpty
            }
            it "has an example" {
                 $node.examples | Should Not BeNullOrEmpty
            }
            foreach($parameter in $node.parameters.parameter)
            {
                it "parameter $($parameter.name) has a description" {
                    $parameter.Description.text | Should Not BeNullOrEmpty
                }
            }
        }
    }
}
