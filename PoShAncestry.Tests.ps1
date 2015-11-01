##
## Unit tests for PoShAncestry module.
## URL: https://github.com/DuFace/PoShAncestry
## Copyright (c) 2015 Kier Dugan
##

## Prerequisite Modules --------------------------------------------------------
Import-Module .\PoShAncestry.psm1 -Force


## Environment Setup -----------------------------------------------------------
$TestRoot    = "PoShAncestryTesting"
$TestPath    = "company\src\projects\products\src\main"
$TestRootDir = Join-Path ($env:TEMP) $TestRoot

New-Item -Type Directory -Path (Join-Path $TestRootDir $TestPath) `
    -ErrorAction Ignore | Out-Null
Push-Location $TestRootDir


## Utility functions
function TestSetup {
    Push-Location $TestPath
}

function TestTeardown {
    $location = Get-Location

    Pop-Location

    return Resolve-Path -Relative $location
}


## Unit Tests ------------------------------------------------------------------
Describe "Select-Ancestor" {
    Context "when single choice exists" {
        TestSetup

        Select-Ancestor company -ErrorVariable result `
            -ErrorAction SilentlyContinue

        $location = TestTeardown

        It "should change directory correctly" {
            $location | Should Be ".\company"
        }
        It "should produce no error" {
            $result | Should BeNullOrEmpty
        }
    }

    Context "when no choice is given" {
        TestSetup

        Select-Ancestor -ErrorVariable result -ErrorAction SilentlyContinue

        $location = TestTeardown

        It "should move to parent directory" {
            $location | Should Be ".\company\src\projects\products\src"
        }
        It "should produce no error" {
            $result | Should BeNullOrEmpty
        }
    }

    Context "when first occurrence is requested" {
        TestSetup

        Select-Ancestor src -First -ErrorVariable result `
            -ErrorAction SilentlyContinue

        $location = TestTeardown

        It "should change to first occurrence" {
            $location | Should Be ".\company\src"
        }
        It "should produce no error" {
            $result | Should BeNullOrEmpty
        }
    }

    Context "when last occurrence is requested" {
        TestSetup

        Select-Ancestor src -ErrorVariable result `
            -ErrorAction SilentlyContinue

        $location = TestTeardown

        It "should change to last occurrence" {
            $location | Should Be ".\company\src\projects\products\src"
        }
        It "should produce no error" {
            $result | Should BeNullOrEmpty
        }
    }

    Context "when first occurrence of incomplete name requested" {
        TestSetup

        Select-Ancestor pro -First -ErrorVariable result `
            -ErrorAction SilentlyContinue

        $location = TestTeardown

        It "should change to last occurrence" {
            $location | Should Be ".\company\src\projects"
        }
        It "should produce no error" {
            $result | Should BeNullOrEmpty
        }
    }

    Context "when last occurrence of incomplete name requested" {
        TestSetup

        Select-Ancestor pro -ErrorVariable result `
            -ErrorAction SilentlyContinue

        $location = TestTeardown

        It "should change to last occurrence" {
            $location | Should Be ".\company\src\projects\products"
        }
        It "should produce no error" {
            $result | Should BeNullOrEmpty
        }
    }

    Context "when requested ancestor does not exist" {
        TestSetup

        Select-Ancestor doesntexist -ErrorVariable result `
            -ErrorAction SilentlyContinue

        $location = TestTeardown

        It "should not change directory" {
            $location | Should Be ".\$TestPath"
        }
        It "should fail with error message" {
            $result | Should Not BeNullOrEmpty
        }
    }
}


## Environment Teardown --------------------------------------------------------
Pop-Location
Remove-Item $TestRootDir -Recurse
