## Setting FileSystemWatcher to monitor file changes
$Watcher = New-object System.IO.FileSystemWatcher
$Watcher.Path = "C:\Scripts"
$Watcher.Filter = "*.xlsx"
$Watcher.IncludeSubdirectories = $false
$Watcher.EnableRaisingEvents = $true

## Defining Paths to Rscript and the script for data processing


## Defining Destination for R output file - Rscript should receive '/' operated filedir instead of naive MSOS "\" dirsys - this is also repeated in the Action definition for input to R


## Defining actions to be made when file creation is detected

## Detecting Created Files and Executing Actions.
Register-ObjectEvent $Watcher 'Created' -SourceIdentifier Created -Action {
	$filepath = $Event.SourceEventArgs.FullPath
	$filename = $Event.SourceEventArgs.Name	
	$RScript = 'C:\Scripts\testps.R'
	$Destination = "C:/Scripts/outdir"
	#$RPath = 'C:\Program Files\R\R-4.1.3\bin\Rscript.exe'
	if (-not ($filename -like '~$*')){
	Write-Host "This $filename was created and being processed"
	Out-File -filepath 'C:\Scripts\Log.txt' -append -inputobject "This $filename, was created"
	
	$filepathR = $filepath -replace '\\', '/';
	Write-Host "Writing file to $filepathR, passing arguments FileDirectory:$filepathR, FileName:$filename, Destination:$Destination"
	&'C:\Program Files\R\R-4.1.3\bin\Rscript.exe' $Rscript @($filepathR, $filename, $Destination)
	} else {Write-Host "File $filename has been opened"};
}
while ($true) {Start-Sleep -Seconds 10}

## or while ($true) {Unregister-Event -SourceIdentifier 'Created'}
