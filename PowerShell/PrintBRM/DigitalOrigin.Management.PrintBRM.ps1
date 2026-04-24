# Using module "C:\temp\DigitalOrigin.Management.PrintBRM.psm1"
# $PrintBRM = [PrintBRM]::new("$($env:temp)\printbrm", "C:\temp\printbrm\printers.printerexport")
# $PrintBRM.OpenPrinterMigration();

# $PrintBRM.RemoveDefaultPrinterMigrationItems();
# Remove default printers from the migration

# $PrintBRM.GetPrinterMigrationItem(); 
# List printers in the migration

# $printBRM.RemovePrinterMigrationItem()
# Remove printers (by name) from the migration

# $printBRM.ClosePrinterMigration





class PrintBRM {
    hidden [string]$WorkingDirectory;
    hidden [string]$FilePath;
    hidden [string]$IntuneWin32Directory = "IntuneWin";
    hidden [string]$IntuneDetectionScript;
    hidden [boolean]$AutoCleanup = $true;
    hidden $PSVersionTable = $PSVersionTable;

    PrintBRM ($WorkingDirectory, $FilePath) {
        $this.WorkingDirectory = $WorkingDirectory;
        $this.FilePath = $FilePath;

        if (-not (Test-Path -Path $WorkingDirectory)) {
            New-Item -ItemType Directory -Path ($WorkingDirectory | Split-Path -Parent) -Name ($WorkingDirectory | Split-Path -Leaf) | Out-Null;
        }
    }

    PrintBRM ($WorkingDirectory, $FilePath, $AutoCleanup) {
        $this.WorkingDirectory = $WorkingDirectory;
        $this.FilePath = $FilePath;
        $this.AutoCleanup = $AutoCleanup;

        if (-not (Test-Path -Path $WorkingDirectory)) {
            New-Item -ItemType Directory -Path ($WorkingDirectory | Split-Path -Parent) -Name ($WorkingDirectory | Split-Path -Leaf) | Out-Null;
        }
    }

    [void] OpenPrintMigration () {
        if (-not (Test-Path -Path $this.FilePath)) {throw "Printer Migration file not found.";}

        # Create the working directory if it doesn't exist.
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\expandedArchive")) {
            New-Item -ItemType Directory -Path ("$($this.WorkingDirectory)\expandedArchive" | Split-Path -Parent) -Name ("$($this.WorkingDirectory)\expandedArchive" | Split-Path -Leaf) | Out-Null;
        }

        $ParamFP = "-F '$($This.FilePath)' ";
    
        $ParamWD = "-D '$($This.WorkingDirectory)\expandedArchive' ";
    
        ###########################################################
        
        # Load specified switches into single arugment for process.
        $switchConstruction = "-R $ParamFP$ParamWD"
    
        # Run the process and wait for any child processes to close before continuing.
        Invoke-Expression -Command "C:\Windows\System32\spool\tools\printbrm.exe $($switchConstruction)" | Out-Null;
    }

    [void] ClosePrintMigration () {
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\expandedArchive")) { throw "Could not discover expanded archive in working directory. Call OpenPrinterMigration() before attempting to modify or read it's content." }

        $ParamFP = "-F '$($this.FilePath)' ";

        $ParamWD = "-D '$($this.WorkingDirectory)\expandedArchive' ";

        ###########################################################

        # Removes an existing file if overwriting.
        if (Test-Path -Path $this.FilePath) {
            Remove-Item -Path $this.FilePath;
        }

        # Load specified switches into single arugment for process.
        $switchConstruction = "-B $ParamFP$ParamWD";

        # Write new Printer Migration File with changes applied.
        Invoke-Expression -Command "C:\Windows\System32\spool\tools\printbrm.exe $($switchConstruction)" | Out-Null;

        # Remove the temporary extraction file.
        Remove-Item -Path "$($this.WorkingDirectory)\expandedArchive" -Recurse -Force;
    }

    [void] ClosePrintMigration ([boolean]$Discard) {
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\expandedArchive")) { throw "Could not discover expanded archive in working directory. Call OpenPrinterMigration() before attempting to modify or read it's content." }

        $ParamFP = "-F '$($this.FilePath)' ";

        $ParamWD = "-D '$($this.WorkingDirectory)\expandedArchive' ";

        ###########################################################

        # Removes an existing file if overwriting.
        if ($Discard -eq $false) {
            if (Test-Path -Path $this.FilePath) {
                Remove-Item -Path $this.FilePath;
            }
        }

        # Load specified switches into single arugment for process.
        $switchConstruction = "-B $ParamFP$ParamWD";

        if ($Discard -eq $false) {
            # Write new Printer Migration File with changes applied.
            Invoke-Expression -Command "C:\Windows\System32\spool\tools\printbrm.exe $($switchConstruction)" | Out-Null;
        }

        # Remove the temporary extraction file.
        Remove-Item -Path "$($this.WorkingDirectory)\expandedArchive" -Recurse -Force;
    }

    [void] ExportPrinters () {
            $ParamFP = "-F '$($this.FilePath)' ";
        
            ###########################################################
            
            $switchConstruction = "-B $ParamFP"
        
            if (Test-Path -Path $this.FilePath) {
                Remove-Item -Path $this.FilePath -Force;
            }
        
            Invoke-Expression -Command "C:\Windows\System32\spool\tools\printbrm.exe $($switchConstruction)" | Out-Null;
    }

    [void] ExportPrinters ([OptionExportPrinters]$Properties) {
        # -NOBIN
        $ParamNB = "";
    
        # -S
        $ParamTS = "";
    
        ###########################################################

        $ParamFP = "-F '$($this.FilePath)' ";
    
        if ($Properties.NOBIN -eq $true) { $ParamNB = "-NOBIN "; }
    
        if ($Properties.TargetServer) { $ParamTS = "-S '$($Properties.TargetServer)' " }
    
        ###########################################################
        
        $switchConstruction = "-B $ParamFP$ParamNB$ParamTS"
    
        if (Test-Path -Path $this.FilePath) {
            Remove-Item -Path $this.FilePath -Force;
        }
    
        Invoke-Expression -Command "C:\Windows\System32\spool\tools\printbrm.exe $($switchConstruction)" | Out-Null;
    }

    [void] ImportPrinters () {
        $ParamFP = "-F '$($this.FilePath)' ";
    
        ###########################################################
        
        $switchConstruction = "-R $ParamFP"
        
        Invoke-Expression -Command "C:\Windows\System32\spool\tools\printbrm.exe $($switchConstruction)" | Out-Null;
    }

    [void] ImportPrinters ([OptionImportPrinters]$Properties) {
            # -O
            $ParamO = "";
        
            # -P
            $ParamP = "";
        
            # -LPR2TCP
            $ParamLPR = "";
        
            # -NOACL
            $ParamACL = "";
        
            # -S
            $ParamTS = "";
        
            ###########################################################
        
            $ParamFP = "-F '$($this.FilePath)' ";
        
            if ($Properties.Force -eq $true) { $ParamO = "-O FORCE " }
        
            if ($Properties.PublishScope -eq [PublishScope]::all) { $ParamP = "-P all " }
            if ($Properties.PublishScope -eq [PublishScope]::org) { $ParamP = "-P org " }
        
            if ($Properties.LPR2TCP -eq $true) { $ParamLPR = "-LPR2TCP " }
        
            if ($Properties.NOACL -eq $true) { $ParamACL = "-NOACL " }
        
            ###########################################################
            
            $switchConstruction = "-R $ParamFP$ParamO$ParamP$ParamLPR$ParamACL$ParamTS"

            Invoke-Expression -Command "C:\Windows\System32\spool\tools\printbrm.exe $($switchConstruction)" | Out-Null;
    }

    [void] UnregisterPrinterShares () {
        # Load BrmPrinters file.
        [xml]$brmXML = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmPrinters.xml";

        $brmXML.Printers.PrintQueue | ForEach-Object {
            [xml]$printQueue = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\Printers\$($_.FileName)";

            $printQueue.PRINTQUEUE.ShareName = "";
            $printQueue.PRINTQUEUE.Attributes = "576";
            $printerPorts.Save("$($this.WorkingDirectory)\expandedArchive\Printers\$($_.FileName)");
        }
    }

    #[TypePrintersPrintQueue] GetPrinterMigrationItem () {
    [System.Object[]] GetPrinterMigrationItem () {
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\expandedArchive")) { throw "Could not discover expanded archive in working directory. Call OpenPrinterMigration() before attempting to modify or read it's content." }
        # Load BrmPrinters file.
        [xml]$brmXML = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmPrinters.xml";

        # Return list of printers.
        return $brmXML.PRINTERS.PRINTQUEUE;
    }

    [void] RemoveDefaultPrinterMigrationItems () {
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\expandedArchive")) { throw "Could not discover expanded archive in working directory. Call OpenPrinterMigration() before attempting to modify or read it's content." }
        $Printers = @(
            "Microsoft Print to PDF",
            "OneNote (Desktop)",
            "Fax",
            "Microsoft XPS Document Writer"
        );
    
        # Load BrmPrinters file.
        [xml]$brmXML = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmPrinters.xml";
    
        $Printers | ForEach-Object {
            $PrinterName = $_;
            # Remove associated entries in other files.
            $brmXML.Printers.PrintQueue | Where-Object {$_.PrinterName -ieq $PrinterName} | ForEach-Object {
                [xml]$printQueue = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\Printers\$($_.FileName)";
                [xml]$brmDrivers = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmDrivers.xml";
                [xml]$printerPorts = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmPorts.xml";
                # Remove any binary driver files associated.
                $brmDrivers.PrinterDrivers.Driver | Where-Object {$_.DriverName -eq $printQueue.PrintQueue.DriverName} | ForEach-Object {
                    $DriverPackagePath = $_.DriverPackagePath;
                    $DriverPackageFile = (Get-ChildItem -Path "$($this.WorkingDirectory)\expandedArchive\Drivers" -File -Recurse | Where-Object {$_.Name -eq $DriverPackagePath});
                    if ($DriverPackageFile) {
                        if (Test-Path -Path $DriverPackageFile.FullName) {
                            Remove-Item -Recurse -Path $DriverPackageFile.Directory.FullName;
                        }
                    }
                }
    
                # Also remove the driver from the list.
                $brmDrivers.PrinterDrivers.Driver | Where-Object {$_.DriverName -eq $printQueue.PrintQueue.DriverName} | ForEach-Object {$_.ParentNode.RemoveChild($_);}
                $brmDrivers.Save("$($this.WorkingDirectory)\expandedArchive\BrmDrivers.xml");
    
                # Also remove the printer port from the list.
                $printerPorts.PrinterPorts.ChildNodes | Where-Object {$_.PortName -eq $printQueue.PrintQueue.PortName} | ForEach-Object {$_.ParentNode.RemoveChild($_);}
                $printerPorts.Save("$($this.WorkingDirectory)\expandedArchive\BrmPorts.xml");
            }
    
            # Remove Printer queue file.
            $brmXML.Printers.PrintQueue | Where-Object {$_.PrinterName -ieq $PrinterName} | ForEach-Object {Remove-Item -Path "$($this.WorkingDirectory)\expandedArchive\Printers\$($_.FileName)";}
    
            # Remove entry of printer from source file. Don't know why this one requires an Out-Null? Presumably because it's not encapsulated with a ForEach?
            $brmXML.Printers.PrintQueue | Where-Object {$_.PrinterName -ieq $PrinterName} | ForEach-Object {$_.ParentNode.RemoveChild($_) | Out-Null;}
            $brmXML.Save("$($this.WorkingDirectory)\expandedArchive\BrmPrinters.xml");
        }
    }

    [void] RemovePrinterMigrationItem ([string]$PrinterName) {
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\expandedArchive")) { throw "Could not discover expanded archive in working directory. Call OpenPrinterMigration() before attempting to modify or read it's content." }
        # Load BrmPrinters file.
        [xml]$brmXML = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmPrinters.xml";
    
        # Remove associated entries in other files.
        $brmXML.Printers.PrintQueue | Where-Object {$_.PrinterName -ieq $PrinterName} | ForEach-Object {
            [xml]$printQueue = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\Printers\$($_.FileName)";
            [xml]$brmDrivers = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmDrivers.xml";
            [xml]$printerPorts = Get-Content -Path "$($this.WorkingDirectory)\expandedArchive\BrmPorts.xml";
            # Remove any binary driver files associated.
            $brmDrivers.PrinterDrivers.Driver | Where-Object {$_.DriverName -eq $printQueue.PrintQueue.DriverName} | ForEach-Object {
                $DriverPackagePath = $_.DriverPackagePath;
                $DriverPackageFile = (Get-ChildItem -Path "$($this.WorkingDirectory)\expandedArchive\Drivers" -File -Recurse | Where-Object {$_.Name -eq $DriverPackagePath});
                if ($DriverPackageFile) {
                    if (Test-Path -Path $DriverPackageFile.FullName) {
                        Remove-Item -Recurse -Path $DriverPackageFile.Directory.FullName;
                    }
                }
            }
    
            # Also remove the driver from the list.
            $brmDrivers.PrinterDrivers.Driver | Where-Object {$_.DriverName -eq $printQueue.PrintQueue.DriverName} | ForEach-Object {$_.ParentNode.RemoveChild($_);}
            $brmDrivers.Save("$($this.WorkingDirectory)\expandedArchive\BrmDrivers.xml");
    
            # Also remove the printer port from the list.
            $printerPorts.PrinterPorts.ChildNodes | Where-Object {$_.PortName -eq $printQueue.PrintQueue.PortName} | ForEach-Object {$_.ParentNode.RemoveChild($_);}
            $printerPorts.Save("$($this.WorkingDirectory)\expandedArchive\BrmPorts.xml");
        }
    
        # Remove Printer queue file.
        $brmXML.Printers.PrintQueue | Where-Object {$_.PrinterName -ieq $PrinterName} | ForEach-Object {Remove-Item -Path "$($this.WorkingDirectory)\expandedArchive\Printers\$($_.FileName)";}
    
        # Remove entry of printer from source file. Don't know why this one requires an Out-Null? Presumably because it's not encapsulated with a ForEach?
        $brmXML.Printers.PrintQueue | Where-Object {$_.PrinterName -ieq $PrinterName} | ForEach-Object {$_.ParentNode.RemoveChild($_) | Out-Null;}
        $brmXML.Save("$($this.WorkingDirectory)\expandedArchive\BrmPrinters.xml");
    }

    [void] NewIntunePrinterPackage ([OptionNewIntunePrinterPackage]$Properties) {
        if (-not (Test-Path -Path $this.FilePath)) {throw "Printer Migration file not found.";}
        # -O
        $ParamO = "";

        # -P
        $ParamP = "";

        # -LPR2TCP
        $ParamLPR = "";

        # -NOACL
        $ParamACL = "";

        ###########################################################

        if ($Properties.Force -eq $true) { $ParamO = "-O FORCE " }

        if ($Properties.PublishScope -eq [PublishScope]::all) { $ParamP = "-P all " }
        if ($Properties.PublishScope -eq [PublishScope]::org) { $ParamP = "-P org " }

        if ($Properties.LPR2TCP -eq $true) { $ParamLPR = "-LPR2TCP " }

        if ($Properties.NOACL -eq $true) { $ParamACL = "-NOACL " }

        ###########################################################
        
        $switchConstruction = "-R -F c:\Printerdeploy\printers.printerexport $ParamO$ParamP$ParamLPR$ParamACL"

        if (Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full") {
            # Atleast 4.5 must be installed.
            if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release) -ge 461808) {
                # Atleast 4.7.2 must be installed.

                # Download the packing utility.
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
                (New-Object System.Net.WebClient).DownloadFile("http://raw.githubusercontent.com/microsoft/Microsoft-Win32-Content-Prep-Tool/master/IntuneWinAppUtil.exe", "$($env:temp)\IntuneWinAppUtil.exe");

                # Create the staging directory.
                if (-not (Test-Path -Path "$($this.WorkingDirectory)\IntuneStaging")) { New-Item -ItemType Directory -Name "IntuneStaging" -Path $this.WorkingDirectory; }

                # Recreate the Output directory.
                if (Test-Path -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)") { Remove-Item -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)" -Recurse;}
                if (-not (Test-Path -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)")) { New-Item -ItemType Directory -Name $this.IntuneWin32Directory -Path $this.WorkingDirectory; }

                # Write the setup script to the staging directory.
                $setupScript = "@echo off`nmkdir c:\Printerdeploy\`ncopy /Y .\printers.printerexport c:\Printerdeploy\`n%systemroot%\System32\spool\tools\printbrm.exe $($switchConstruction)";
                $setupScript | Out-File -Encoding utf8 -FilePath "$($this.WorkingDirectory)\IntuneStaging\setup.bat";

                # Copy printer migration file to staging directory.
                Copy-Item -Path $this.FilePath -Destination "$($this.WorkingDirectory)\IntuneStaging\printers.printerexport";
                
                # Package for Intune.
                #Invoke-Expression -Command "`"$($env:temp)\IntuneWinAppUtil.exe`" -q -c `"$($this.WorkingDirectory)\intuneStaging`" -s setup.bat -o `"$($this.WorkingDirectory)\$($this.IntuneWin32Directory)`"";
                Start-Process -FilePath "$($env:temp)\IntuneWinAppUtil.exe" -ArgumentList "-q", "-c `"$($this.WorkingDirectory)\intuneStaging`"", "-s setup.bat", "-o `"$($this.WorkingDirectory)\$($this.IntuneWin32Directory)`"" -Wait -NoNewWindow | Out-Null;

                #############################################
                # Create detection rule covering all printers
                #############################################

                $intunePrinters = @();

                # Open the migration file to get a list of printers.
                $this.OpenPrintMigration();

                # Load BrmPrinters file.
                $this.GetPrinterMigrationItem() | ForEach-Object {$intunePrinters += $_.PrinterName};

                # Close the migration file while discarding the output.
                $this.ClosePrintMigration($true);
                
                # String manipulation to add quotes.
                $intunePrinters = $intunePrinters | ForEach-Object {$i="`"$($_)`"";$i;}

                $this.IntuneDetectionScript = "`$cp=Get-Printer;`$np=@($($intunePrinters -join","));[boolean[]]`$pc=@();`$np|%{`$p=`$_;if(`$cp|?{`$_.Name -eq`$p}){`$pc+=`$true}else{`$pc+=`$false}};if(`$pc -contains`$false){exit 1;}else{Write-Host'100%';exit 0;}"

                $this.IntuneDetectionScript | Out-File -FilePath "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)\detectionRule.ps1" -Encoding utf8;
                
                # Remove the temporary extraction file.
                Remove-Item -Path "$($this.WorkingDirectory)\IntuneStaging" -Recurse;
            } else {
                throw ".NET 4.5 is not installed.";
            }
        } else {
            throw ".NET 4.5 is not installed.";
        }
    }

    [void] NewIntunePrinterPackage ([OptionNewIntunePrinterPackage]$Properties, [string]$FilePath) {
        if (-not (Test-Path -Path $this.FilePath)) {throw "Printer Migration file not found.";}
        # -O
        $ParamO = "";

        # -P
        $ParamP = "";

        # -LPR2TCP
        $ParamLPR = "";

        # -NOACL
        $ParamACL = "";

        ###########################################################

        if ($Properties.Force -eq $true) { $ParamO = "-O FORCE " }

        if ($Properties.PublishScope -eq [PublishScope]::all) { $ParamP = "-P all " }
        if ($Properties.PublishScope -eq [PublishScope]::org) { $ParamP = "-P org " }

        if ($Properties.LPR2TCP -eq $true) { $ParamLPR = "-LPR2TCP " }

        if ($Properties.NOACL -eq $true) { $ParamACL = "-NOACL " }

        if ($FilePath.Length -eq 0) {"$($this.WorkingDirectory)\$($this.IntuneWin32Directory)"}

        ###########################################################
        
        $switchConstruction = "-R -F c:\Printerdeploy\printers.printerexport $ParamO$ParamP$ParamLPR$ParamACL"

        if (Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full") {
            # Atleast 4.5 must be installed.
            if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -Name Release) -ge 461808) {
                # Atleast 4.7.2 must be installed.

                # Download the packing utility.
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
                (New-Object System.Net.WebClient).DownloadFile("http://raw.githubusercontent.com/microsoft/Microsoft-Win32-Content-Prep-Tool/master/IntuneWinAppUtil.exe", "$($env:temp)\IntuneWinAppUtil.exe");

                # Create the staging directory.
                if (-not (Test-Path -Path "$($this.WorkingDirectory)\IntuneStaging")) { New-Item -ItemType Directory -Name "IntuneStaging" -Path $this.WorkingDirectory; }

                # Recreate the Output directory.
                if (Test-Path -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)") { Remove-Item -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)" -Recurse;}
                if (-not (Test-Path -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)")) { New-Item -ItemType Directory -Name $this.IntuneWin32Directory -Path $this.WorkingDirectory; }

                # Write the setup script to the staging directory.
                $setupScript = "@echo off`nmkdir c:\Printerdeploy\`ncopy /Y .\printers.printerexport c:\Printerdeploy\`n%systemroot%\System32\spool\tools\printbrm.exe $($switchConstruction)";
                $setupScript | Out-File -Encoding utf8 -FilePath "$($this.WorkingDirectory)\IntuneStaging\setup.bat";

                # Copy printer migration file to staging directory.
                Copy-Item -Path $this.FilePath -Destination "$($this.WorkingDirectory)\IntuneStaging\printers.printerexport";
                
                # Package for Intune.
                #Invoke-Expression -Command "`"$($env:temp)\IntuneWinAppUtil.exe`" -q -c `"$($this.WorkingDirectory)\intuneStaging`" -s setup.bat -o `"$($FilePath)`"";
                Start-Process -FilePath "$($env:temp)\IntuneWinAppUtil.exe" -ArgumentList "-q", "-c `"$($this.WorkingDirectory)\intuneStaging`"", "-s setup.bat", "-o `"$($FilePath)`"" -Wait -NoNewWindow | Out-Null;

                #############################################
                # Create detection rule covering all printers
                #############################################

                $intunePrinters = @();

                # Open the migration file to get a list of printers.
                $this.OpenPrintMigration();

                # Load BrmPrinters file.
                $this.GetPrinterMigrationItem() | ForEach-Object {$intunePrinters += $_.PrinterName};

                # Close the migration file while discarding the output.
                $this.ClosePrintMigration($true);
                
                # String manipulation to add quotes.
                $intunePrinters = $intunePrinters | ForEach-Object {$i="`"$($_)`"";$i;}

                $this.IntuneDetectionScript = "`$cp=Get-Printer;`$np=@($($intunePrinters -join","));[boolean[]]`$pc=@();`$np|%{`$p=`$_;if(`$cp|?{`$_.Name -eq`$p}){`$pc+=`$true}else{`$pc+=`$false}};if(`$pc -contains`$false){exit 1;}else{Write-Host'100%';exit 0;}"

                $this.IntuneDetectionScript | Out-File -FilePath "$($FilePath)\detectionRule.ps1" -Encoding utf8;

                # Remove the temporary extraction file.
                Remove-Item -Path "$($this.WorkingDirectory)\IntuneStaging" -Recurse;
            } else {
                throw ".NET 4.5 is not installed.";
            }
        } else {
            throw ".NET 4.5 is not installed.";
        }
    }

    [void] PublishIntunePrinterPackage ([OptionIntuneWin32Application]$Properties) {
        if (-not ($this.PSVersionTable.PSVersion.Major -ge 5)) { throw "Current PowerShell verison is less than 5. Method cannot resolve." }
        
        # Create the staging directory.
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\IntuneStaging")) { New-Item -ItemType Directory -Name "IntuneStaging" -Path $this.WorkingDirectory | Out-Null; }

        Test-AuthToken;

        $this.IntuneDetectionScript | Out-File -Encoding utf8 -FilePath "$($this.WorkingDirectory)\IntuneStaging\detectionRule.ps1";

        $PSRule = New-DetectionRule -PowerShell -ScriptString $this.IntuneDetectionScript -enforceSignatureCheck $false -runAs32Bit $false;

        # Creating Array for detection Rule
        $DetectionRule = @($PSRule);

        $ReturnCodes = Get-DefaultReturnCodes;

        $ReturnCodes += New-ReturnCode -returnCode 302 -type softReboot;
        $ReturnCodes += New-ReturnCode -returnCode 145 -type hardReboot;

        # Win32 Application Upload
        if (-not ($this.IntuneDetectionScript)) {
            $this.IntuneDetectionScript = Get-Content -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)\detectionRule.ps1" -Encoding utf8;
        }
        Upload-Win32Lob -displayName $Properties.DisplayName -SourceFile "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)\setup.intunewin" -publisher $Properties.Publisher -description $Properties.Description -detectionRules $DetectionRule -returnCodes $ReturnCodes -installCmdLine "setup.bat" -uninstallCmdLine "echo unavailable && pause";

        # Remove the temporary extraction file.
        Remove-Item -Path "$($this.WorkingDirectory)\IntuneStaging" -Recurse;
        Remove-Item -Path "$($this.WorkingDirectory)\IntuneWin" -Recurse;
    }

    [void] PublishIntunePrinterPackage ([OptionIntuneWin32Application]$Properties, [boolean]$AutoAcceptAzureADModule) {
        if (-not ($this.PSVersionTable.PSVersion.Major -ge 5)) { throw "Current PowerShell verison is less than 5. Method cannot resolve." }
        if ((-not (Get-Module -ListAvailable | Where-Object {$_.Name -eq "AzureAD"})) -and ($AutoAcceptAzureADModule -eq $false)) {
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force;
            Install-Module AzureAD -Force;
        }

        # Create the staging directory.
        if (-not (Test-Path -Path "$($this.WorkingDirectory)\IntuneStaging")) { New-Item -ItemType Directory -Name "IntuneStaging" -Path $this.WorkingDirectory | Out-Null; }

        Test-AuthToken;

        $this.IntuneDetectionScript | Out-File -Encoding utf8 -FilePath "$($this.WorkingDirectory)\IntuneStaging\detectionRule.ps1";

        $PSRule = New-DetectionRule -PowerShell -ScriptString $this.IntuneDetectionScript -enforceSignatureCheck $false -runAs32Bit $false;

        # Creating Array for detection Rule
        $DetectionRule = @($PSRule);

        $ReturnCodes = Get-DefaultReturnCodes;

        $ReturnCodes += New-ReturnCode -returnCode 302 -type softReboot;
        $ReturnCodes += New-ReturnCode -returnCode 145 -type hardReboot;

        # Win32 Application Upload
        if (-not ($this.IntuneDetectionScript)) {
            $this.IntuneDetectionScript = Get-Content -Path "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)\detectionRule.ps1" -Encoding utf8;
        }
        Upload-Win32Lob -displayName $Properties.DisplayName -SourceFile "$($this.WorkingDirectory)\$($this.IntuneWin32Directory)\setup.intunewin" -publisher $Properties.Publisher -description $Properties.Description -detectionRules $DetectionRule -returnCodes $ReturnCodes -installCmdLine "setup.bat" -uninstallCmdLine "echo unavailable && pause";

        # Remove the temporary extraction file.
        Remove-Item -Path "$($this.WorkingDirectory)\IntuneStaging" -Recurse;
        Remove-Item -Path "$($this.WorkingDirectory)\IntuneWin" -Recurse;
    }
}

class OptionIntuneWin32Application {
    [string]$Displayname
    [string]$Publisher
    [string]$Description
}

class TypePrintersPrintQueue {
    [string]$PrinterName
    [string]$FileName
    [string]$Name
    [string]$LocalName
    [string]$NamespaceURI
    [string]$Prefix
    [string]$NodeType
    [string]$ParentNode
    [string]$OwnerDocument
    [boolean]$IsEmpty
    [hashtable]$Attributes
    [boolean]$HasAttributes
    [System.Data.SchemaType]$SchemaInfo
    [string]$InnerXml
    [string]$InnerText
    [string]$NextSibling
    [string]$PreviousSibling
    [string]$Value
    [hashtable]$ChildNodes
    [string]$FirstChild
    [string]$LastChild
    [boolean]$HasChildNodes
    [boolean]$IsReadOnly
    [string]$OuterXml
    [string]$BaseURI
    [string]$PreviousText
}

class OptionExportPrinters {
    [boolean]$NOBIN
    [string]$TargetServer
}

class OptionImportPrinters {
    [boolean]$Force
    [PublishScope]$PublishScope
    [boolean]$LPR2TCP
    [boolean]$NOACL
    [string]$TargetServer
}

class OptionNewIntunePrinterPackage : OptionImportPrinters {}

enum PublishScope {all;org;}