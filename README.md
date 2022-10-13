# Cell_PCR_Reader

This is a project to provide automatic initial processing of output files from experiments in biological laboratory.

The script will detect any new files that had been read by your machine to a specific folder, and pass through different graphical and statistical tests in R to provide a summary of your experiment that just ran.

**Installation Dependencies:**
- * *Powershell v1.0* *
- * *Rscript > 3.0* *
  - * *tidyverse* *
  - * *ggplot2* *
  

* *Oct 2022 - Update on Windows 10 - Powershell/R based processing complete* *

## Windows 10 Task Scheduler
1) Open Windows Task Scheduler

![Image1](https://raw.githubusercontent.com/jaychoi4830/Cell_PCR_Reader/main/image/Task_Scheduler1.PNG?token=GHSAT0AAAAAABXULXKEY6UW5VEDEOLTUA4WY2ILKLQ)

2) Click **Create Task**

3) Fill in General Options

![Image2](https://raw.githubusercontent.com/jaychoi4830/Cell_PCR_Reader/main/image/Task_Scheduler2.PNG?token=GHSAT0AAAAAABXULXKF3GXIFOCCXB6OG3MKY2ILKWQ)

4) Add trigger

5) Add Action * *Start a program* * -> select Powershell.exe from C:\System32\.. -> and use argument:

``-NoExit -nologo -NonInteractive -Executionpolicy bypass -File "C:\Pathto\Script.ps1"``

6) Run the scheduled task
