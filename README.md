# Cell_PCR_Reader

This is a project to develop automatic processing of output files from experiments in biological laboratory.
The test phase of this project will include Powershell Script - as most settings use Windows-operated computers.
The script will detect any new files that had been read by your machine to a specific folder, and pass through different graphical and statistical tests to provide a summary of your experiment that just ran.

* *Oct 2022 - Update on Windows 10 - Powershell/R based processing complete* *

## Windows 10 Task Scheduler
1) Open Windows Task Scheduler
![Image1](https://raw.githubusercontent.com/jaychoi4830/Cell_PCR_Reader/tree/main/image/Task_Scheduler1.PNG)
2) Click **Create Task**
3) Fill in General Options
<img src="https://github.com/jaychoi4830/Cell_PCR_Reader/main/image/Task_Scheduler2.PNG?raw=true" />
5) Add trigger
6) Add Action * *Start a program* * -> select Powershell.exe from C:\System32\.. -> and use argument
``-NoExit -nologo -NonInteractive -Executionpolicy bypass -File "C:\Pathto\Script.ps1"``
6) Run the scheduled task
