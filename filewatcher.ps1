## Setting FileSystemWatcher to monitor file changes
$Watcher = New-object System.IO.FileSystemWatcher
$Watcher.Path = "C:\Pathto\FoldertoWatch"
$SavetoDirectory = "C:\Where\ToSave"
$Watcher.Filter = ".txt"
$Watcher.IncludeSubdirectories = $false
$Watcher.EnableRaisingEvents = $true

## Defining Paths to Rscript and the script for data processing
$RPath = "C:\Program Files\R\R-4.1.3\bin\Rscript.exe"
$RScript = "C:\PathtoRscript"
## Defining Destination for R output file - Rscript should receive '/' operated filedir instead of naive MSOS "\" dirsys - this is also repeated in the Action definition for input to R
$Destination = "C:/Destination/output"

## Defining actions to be made when file creation is detected
$action = {
	$filepath = $Event.SourceEventArgs.FullPath
	$filename = $Event.SourceEventArgs.Name

	$filepathR = $filepath -replace '\\', '/'

	$Rpath $Rscript $filepathR $filename $Destination
}

## Detecting Created Files and Executing Actions.
Register-ObjectEvent -InputObject $Watcher Created -Action $action

while ($true) {sleep 10}
## or while ($true) {Unregister-Event -SourceIdentifier 'Created'}
