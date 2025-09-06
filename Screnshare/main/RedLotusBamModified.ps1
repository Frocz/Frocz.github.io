$ErrorActionPreference = SilentlyContinue

function Get-Signature {

    [CmdletBinding()]
     param (
        [string[]]$FilePath
    )

    $Existence = Test-Path -PathType Leaf -Path $FilePath
    $Authenticode = (Get-AuthenticodeSignature -FilePath $FilePath -ErrorAction SilentlyContinue).Status
    $Signature = Invalid Signature (UnknownError)

    if ($Existence) {
        if ($Authenticode -eq Valid) {
            $Signature = Valid Signature
        }
        elseif ($Authenticode -eq NotSigned) {
            $Signature = Invalid Signature (NotSigned)
        }
        elseif ($Authenticode -eq HashMismatch) {
            $Signature = Invalid Signature (HashMismatch)
        }
        elseif ($Authenticode -eq NotTrusted) {
            $Signature = Invalid Signature (NotTrusted)
        }
        elseif ($Authenticode -eq UnknownError) {
            $Signature = Invalid Signature (UnknownError)
        }
        return $Signature
    } else {
        $Signature = File Was Not Found
        return $Signature
    }
}

Clear-Host

Write-Host ;
Write-Host ;
Write-Host -ForegroundColor Red "░█████╗░░█████╗░░█████╗░ PURA GENTE DE LA RANA"
Write-Host -ForegroundColor Red "██╔═══╝░██╔═══╝░██╔═══╝░ PURA GENTE DE LA RANA"
Write-Host -ForegroundColor Red "██████╗░██████╗░██████╗░ PURA GENTE DE LA RANA"
Write-Host -ForegroundColor Red "██╔══██╗██╔══██╗██╔══██╗ PURA GENTE DE LA RANA"
Write-Host -ForegroundColor Red "╚█████╔╝╚█████╔╝╚█████╔╝ PURA GENTE DE LA RANA"
Write-Host -ForegroundColor Red "░╚════╝░░╚════╝░░╚════╝░ PURA GENTE DE LA RANA"
Write-Host ;
Write-Host -ForegroundColor Blue    Made By PureIntent (Shitty ScreenSharer) For Red Lotus ScreenSharing and DFIR -  -NoNewLine
Write-Host -ForegroundColor Red discord.ggredlotus;
Write-Host ;

function Test-Admin {;$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]GetCurrent());$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]Administrator);}
if (!(Test-Admin)) {
    Write-Warning Please Run This Script as Admin.
    Start-Sleep 10
    Exit
}

$sw = [Diagnostics.Stopwatch]StartNew()

if (!(Get-PSDrive -Name HKLM -PSProvider Registry)){
    Try{New-PSDrive -Name HKLM -PSProvider Registry -Root HKEY_LOCAL_MACHINE}
    Catch{Write-Warning Error Mounting HKEY_Local_Machine}
}
$bv = (bam, bamState)
Try{$Users = foreach($ii in $bv){Get-ChildItem -Path HKLMSYSTEMCurrentControlSetServices$($ii)UserSettings  Select-Object -ExpandProperty PSChildName}}
Catch{
    Write-Warning Error Parsing BAM Key. Likely unsupported Windows Version
    Exit
}
$rpath = @(HKLMSYSTEMCurrentControlSetServicesbam,HKLMSYSTEMCurrentControlSetServicesbamstate)

$UserTime = (Get-ItemProperty -Path HKLMSYSTEMCurrentControlSetControlTimeZoneInformation).TimeZoneKeyName
$UserBias = (Get-ItemProperty -Path HKLMSYSTEMCurrentControlSetControlTimeZoneInformation).ActiveTimeBias
$UserDay = (Get-ItemProperty -Path HKLMSYSTEMCurrentControlSetControlTimeZoneInformation).DaylightBias

$Bam = Foreach ($Sid in $Users){$u++
            
        foreach($rp in $rpath){
           $BamItems = Get-Item -Path $($rp)UserSettings$Sid -ErrorAction SilentlyContinue  Select-Object -ExpandProperty Property
           Write-Host -ForegroundColor Red Extracting  -NoNewLine
           Write-Host -ForegroundColor Blue $($rp)UserSettings$SID
           $bi = 0 

            Try{
            $objSID = New-Object System.Security.Principal.SecurityIdentifier($Sid)
            $User = $objSID.Translate( [System.Security.Principal.NTAccount]) 
            $User = $User.Value
            }
            Catch{$User=}
            $i=0
            ForEach ($Item in $BamItems){$i++
		    $Key = Get-ItemProperty -Path $($rp)UserSettings$Sid -ErrorAction SilentlyContinue Select-Object -ExpandProperty $Item
	
            If($key.length -eq 24){
                $Hex=[System.BitConverter]ToString($key[7..0]) -replace -,
                $TimeLocal = Get-Date ([DateTime]FromFileTime([Convert]ToInt64($Hex, 16))) -Format yyyy-MM-dd HHmmss
			    $TimeUTC = Get-Date ([DateTime]FromFileTimeUtc([Convert]ToInt64($Hex, 16))) -Format yyyy-MM-dd HHmmss
			    $Bias = -([convert]ToInt32([Convert]ToString($UserBias,2),2))
			    $Day = -([convert]ToInt32([Convert]ToString($UserDay,2),2)) 
			    $Biasd = $Bias60
			    $Dayd = $Day60
			    $TImeUser = (Get-Date ([DateTime]FromFileTimeUtc([Convert]ToInt64($Hex, 16))).addminutes($Bias) -Format yyyy-MM-dd HHmmss) 
			    $d = if((((split-path -path $item)  ConvertFrom-String -Delimiter ).P3)-match 'd{1}')
			    {((split-path -path $item).Remove(23)).trimstart(DeviceHarddiskVolume)} else {$d = }
			    $f = if((((split-path -path $item)  ConvertFrom-String -Delimiter ).P3)-match 'd{1}')
			    {Split-path -leaf ($item).TrimStart()} else {$item}	
			    $cp = if((((split-path -path $item)  ConvertFrom-String -Delimiter ).P3)-match 'd{1}')
			    {($item).Remove(1,23)} else {$cp = }
			    $path = if((((split-path -path $item)  ConvertFrom-String -Delimiter ).P3)-match 'd{1}')
			    {Join-Path -Path C -ChildPath $cp} else {$path = }			
			    $sig = if((((split-path -path $item)  ConvertFrom-String -Delimiter ).P3)-match 'd{1}')
			    {Get-Signature -FilePath $path} else {$sig = }				
                [PSCustomObject]@{
                            'Examiner Time' = $TimeLocal
						    'Last Execution Time (UTC)'= $TimeUTC
						    'Last Execution User Time' = $TimeUser
						     Application = 	$f
						     Path =  		$path
                             Signature =          $Sig
						     User =         $User
						     SID =          $Sid
                             Regpath =        $rp
                             }}}}}

$Bam  Out-GridView -PassThru -Title BAM key entries $($Bam.count)  - User TimeZone ($UserTime) - ActiveBias ( $Bias) - DayLightTime ($Day)

$sw.stop()
$t = $sw.Elapsed.TotalMinutes
Write-Host 
Write-Host Elapsed Time $t Minutes -ForegroundColor Yellow