PoShAncestry
============

Quickly go back to a specific directory instead of typing `cd ..\..\..`
redundantly.  Based on [zsh-bd](https://github.com/Tarrasch/zsh-bd) and
[bd](http://vigneshwaranr.github.io/bd/).

## Motivation

Traversing back through deeply nested directory structures is annoying.

``` PowerShell
C:\Dev\Projects\PowerShell\PoShAncestry> bd pro
C:\Dev\Projects>
```

PoShAncestry exports on a single command, [`Select-Ancestor`](#Select-Ancestor),
which will traverse up through the path to find the ancestor with the closest
name.  For convenience, the alias `bd` is also exported.

While `Select-Ancestor` does support tab completion, it will also match based on
leading characters.  As in the example above, `pro` will match the `Projects`
folder.  In the case of multiple potential matches, the closest ancestor will be
used, unless the `-First` switch is specified, in which case the farthest
ancestor will be selected.

## Installation

Manual installation:

1.  Create a `PoShAncestry` directory in your PowerShell modules folder.  You
    can find this be examining `$env:PSModulePath`.
2.  Download `PoShAncestry.psm1` and place it in your `PoShAncestry` directory.
3.  Add `Import-Module PoShAncestry` for your `$profile`.

<a id="Select-Ancestor"></a>
## Select-Ancestor

```
Select-Ancestor [-Ancestor] <String> [-First] [-PassThru] [<CommonParameters>]
```

Searches the current location string for the given ancestor, using this as the
new location.

### Description
Select-Ancestor will break the current location string up into a list of
ancestor locations and change to the one requested.  If multiple ancestors share
the same name, the closest to the current location will be chosen.  This
behaviour can be changed by using `-First`.

Partial matches are *always* attempted, and an ancestor will be selected if it
starts with the specified string; e.g. the ancestor 'Work' will be selected by
the string 'wo'.

### Parameters
| Parameter | Type   | Description                                                                                                               |
| :-------- | :----: | :------------------------------------------------------------------------------------------------------------------------ |
| Ancestor  | String | Ancestor location to search for.  If there are multiple ancestor locations with the same name, the last will be selected. |
| First     | Switch | Select the first occurrence of Ancestor instead of the last.                                                              |
| PassThru  | Switch | Return the new directory object after changing into it.                                                                   |

### Example 1
```
Select-Ancestor Parent
```

Executed in the directory `C:\Folder1\Folder2\Parent\Child` would change the
current location to `C:\Folder1\Folder2\Parent`.

### Example 2
```
Select-Ancestor fol -First
```

Executed in the directory `C:\Folder1\Folder2\Parent\Child` would change the
current location to `C:\Folder1`.

### Example 3
```
Select-Ancestor fol
```

Executed in the directory `C:\Folder1\Folder2\Parent\Child` would change the
current location to `C:\Folder1\Folder2`.


## Testing

A simple suite of [Pester](https://github.com/pester/Pester) tests is included
in `PoShAncestry.Tests.ps1`.  Simply install Pester and execute `Invoke-Pester`
in the PoShAncestry directory to run the tests.

## Licence

The MIT License (MIT)

Copyright (c) 2015 Kier Dugan

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
