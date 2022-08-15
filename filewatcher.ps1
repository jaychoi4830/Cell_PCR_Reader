## Setting FileSystemWatcher to monitor file changes
$Watcher = New-object System.IO.FileSystemWatcher
$Watcher.Path = "C:\Pathto\FoldertoWatch"
$SavetoDirectory = "C:\Where\ToSave"
$Watcher.Filter = ".txt"
$Watcher.IncludeSubdirectories = $false
$Watcher.EnableRaisingEvents = $true

## Defining Paths to R and the script for data processing
$RPath = "C:\Program Files\R\R-4.1.3\bin\Rscript.exe"
$RScript = "C:\PathtoRscript"
$Destination = "C:\Destination\output"

## Defining actions to be made when file creation is detected
$action = {
	$filepath = $Event.SourceEventArgs.FullPath
	$filename = $Event.SourceEventArgs.Name

	$Rpath $Rscript $filepath $filename $Destination
}

## Detecting Created Files and Executing Actions.
Register-ObjectEvent $Watcher "Created" -Action $action

while ($true) {sleep 10}

