#!powershell
# This file is part of Ansible

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

#Requires -Module Ansible.ModuleUtils.Legacy.psm1

# The clause below will require Ansible >= 2.5
#AnsibleRequires -Become

$ErrorActionPreference = 'Stop'

$params = Parse-Args -arguments $args -supports_check_mode $true
$check_mode = Get-AnsibleParam -obj $params -name "_ansible_check_mode" -type "bool" -default $false
$diff_mode = Get-AnsibleParam -obj $params -name "_ansible_diff" -type "bool" -default $false

# Modules parameters
$state = Get-AnsibleParam -obj $params -Name "State" -type "string" -failifempty $true
$applicationid = Get-AnsibleParam -obj $params -name "ApplicationID" -type "string" -failifempty $false
$rearmscope = Get-AnsibleParam -obj $params -name "ReArmScope" -type "string" -ValidateSet "Windows","Application","SKU"  -failifempty $false
$mingraceperiod = Get-AnsibleParam -obj $params -name "MinimumGracePeriod" -type "int" -failifempty $false


# Import PSSlmgr module if available
$Module = 'PSSlmgr'

if (-not (Get-Module -Name $Module -ErrorAction SilentlyContinue)) {
    if (Get-Module -Name $Module -ListAvailable -ErrorAction SilentlyContinue) {
        Import-Module $Module
    } else {
        Fail-Json -obj $result -message "Cannot find module: $Module"
    }
}

#  'ParamaterSet' verification
if ( @('Application','SKU') -contains $rearmscope -and [String]::IsNullOrEmpty($applicationid) ) {
    Fail-Json -obj $result -message "To rearm $rearmscope you have to provide ApplicationID"
}

$result = @{
    changed = $false
}

if ( $check_mode ) {
    $RearmResult = Invoke-ReArm -AnsibleMode -RearScope $rearmscope -WhatIf

}
else {
    $RearmResult = Invoke-ReArm -AnsibleMode -ReArmScope $rearmscope -Confirm:$false
}

if ($diff_mode) {
    $result.diff = @{}
}

Set-Attr $result, "restartrequired" $RearmResult.restartrequired

if ( $RearmResult.RestartRequired ) {
    Set-Attr $result "changed" $true
}

Exit-Json -obj $result