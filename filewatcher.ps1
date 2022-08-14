$Watcher = New-object System.IO.FileSystemWatcher
$Watcher.Path = "C:\Pathto\FoldertoWatch"
$Watcher.Filter = ".txt"
$Watcher.IncludeSubdirectories = $false
$Watcher.EnableRaisingEvents = $true


