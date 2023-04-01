function split-pdf {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $true)][string]$inputFolder,
        [parameter(Mandatory = $true)][string]$outputFolder
    )

    <#
        .SYNOPSIS
            PDF Dateien teilen
        .DESCRIPTION
            Erstellt für jede Seite eines PDF Dokumentes eine serparte PDF Datei
        .PARAMETER  inputFolder
            Dateipfad mit den aufzuteilenden PDF Dateien (auch mehrere)
        .PARAMETER  outputFolder
            Dateipfad für die Ergebnisseiten
        .EXAMPLE
            split-pdf -inputFolder (Join-Path $PSScriptRoot "pdf_in") -outputFolder (Join-Path $PSScriptRoot "pdf_out") -Verbose
    #>

    # Load iTextSharp
    Add-Type -Path (Join-Path $PSScriptRoot "BouncyCastle.Crypto.dll") ## https://www.nuget.org/packages/BouncyCastle
    Add-Type -Path (Join-Path $PSScriptRoot "itextsharp.dll") ## https://www.nuget.org/packages/iTextSharp/

    Get-ChildItem $inputFolder -Filter *.pdf |
    Foreach-Object {

        Write-Verbose ("PDF-Datei aufteilen: {0}" -f $_.FullName)

        # Create reader and get number of pages
        $reader = New-Object iTextSharp.text.pdf.PdfReader($_.FullName)
        $numPages = $reader.NumberOfPages

        # Loop through pages and create new PDF for each page 
        for ($i = 1; $i -le $numPages; $i++) {
            $outputFile = Join-Path $outputFolder ("{0}_{1}.pdf" -f $_.BaseName, $i)

            Write-Verbose ("  Seite {0}/{1}: {2}" -f $i, $numPages, $outputFile)

            $document = New-Object iTextSharp.text.Document
            $copy = New-Object iTextSharp.text.pdf.PdfCopy($document, [System.IO.File]::Create($outputFile))
            $document.Open()
            $copy.AddPage($copy.GetImportedPage($reader, $i))
            $document.Close()
        }

        # Close reader
        $reader.Close()
    }
}

split-pdf -inputFolder (Join-Path $PSScriptRoot "pdf_in") -outputFolder (Join-Path $PSScriptRoot "pdf_out") -Verbose