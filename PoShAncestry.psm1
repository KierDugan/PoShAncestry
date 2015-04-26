##
## PoShAncestry: a PowerShell port of the `bd` zshell script.
## URL: https://github.com/DuFace/PoShAncestry
## Copyright (c) 2015 Kier Dugan
##

## Utility Functions -----------------------------------------------------------
function GetAncestors() {
    return (Get-Location) -split '\\'
}


## Commands --------------------------------------------------------------------
function Select-Ancestor {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String]
        $Ancestor,

        [Parameter(Mandatory=$false)]
        [ValidateSet("First", "Last")]
        [String]
        $Occurrence = 'Last',

        [Parameter(Mandatory=$false)]
        [Switch]
        $PassThru = $false
    )

    process {
        # Split the current path into a list of directories
        $parts = GetAncestors

        # Check that requested ancestor exists
        $potentialAncestors = $parts | where { $_ -like "$Ancestor*" }
        if (-not $potentialAncestors) {
            Write-Error "Ancestor '$Ancestor' does not exist."
            return
        }

        # Enumerate over the path parts until the first one is matched
        $ancestorIndex = if ($Occurrence -eq 'First') {
            # Start from the farthest ancestor
            for ($i = 0; $i -lt $parts.Length; $i++) {
                if ($parts[$i] -like "$Ancestor*") {
                    $i; break
                }
            }
        } else {
            # Start from the closest ancestor
            for ($i = $parts.Length - 1; $i -ge 0; $i--) {
                if ($parts[$i] -like "$Ancestor*") {
                    $i; break
                }
            }
        }

        # Re-assemble the path up until the discovered index and go there
        if ($ancestorIndex -ne $null) {
            $path = $parts[0..$ancestorIndex] -join '\'
            return Set-Location -Path "$path\" -PassThru:$PassThru
        }
    }
}


## Advanced tab expansion for Ancestor -----------------------------------------
if (-not $global:KJDCompleteOptions) {
    $global:KJDCompleteOptions = @{
        CustomArgumentCompleters = @{};
        NativeArgumentCompleters = @{}
    }
}

# Hook into the global completion function
$LookupCode = @'
End
{
    # KJDCompletionLookup
    if ($options -eq $null)
    {
        $options = $global:KJDCompleteOptions
    }
    else
    {
        $options += $global:KJDCompleteOptions
    }

'@

if (-not ($function:TabExpansion2 -match 'KJDCompletionLookup')) {
    $function:TabExpansion2 = $function:TabExpansion2 `
        -replace 'End\r\n{', $LookupCode
}

# Register the actual completion function
$global:KJDCompleteOptions['CustomArgumentCompleters']['Ancestor'] = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameter
    )

    # Correctly resolve the command name
    if ((Get-Command $commandName).CommandType -eq 'Alias') {
        $commandName = (Get-Command $commandName).ResolvedCommandName
    }

    # Make sure it's a PoShWarp command
    if ($commandName -eq "Select-Ancestor") {
        # Split the current path into a list of directories
        $parts = GetAncestors

        # Filter them if required
        if ($wordToComplete) {
            $parts = $parts | where { $_ -like "$wordToComplete*" }
        }

        return $parts | Sort-Object | Get-Unique
     }
}


## Module Exports --------------------------------------------------------------
Set-Alias bd Select-Ancestor

Export-ModuleMember -Function Select-Ancestor
Export-ModuleMember -Alias bd
