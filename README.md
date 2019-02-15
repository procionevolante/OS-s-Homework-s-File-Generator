OS's Homework's files generator - GOLD Edition
==============================================

These scripts can be used to manage homeworks of the Operating Systems course at
Polytechnic of Turin.

## `create.sh`
`create.sh` creates a directory tree that respects the requirements of the
professor.

Specifically, it'll create a dir named `S(studentID)_L(lab_number)_NameSurname`
with inside a dir for each exercise named `D(exercise_number)`  
Inside each `D`_xx_ a set of file are generated, with names starting with
`E(exercise_number)`:
* `E`_xx_`_text.(chosen_format)` that contains the text of the exercise
* `E`_xx_`_report.(chosen_format)` that contains the report
* `E`_xx_`_report.(exercise_format)` that contains the actual exercise

These files are copied from the `templates` dir.  
Reports and exercise's texts can be in Markdown format, in which case they will
later be converted automatically to the PDF format.

Note that this script was written just after creating the above structure
manually for the first laboratory, while screaming.

### Templates
Files in this dir are used as skeletons for exercises, reports and exercises'
text.
* report models have name `report.`_format_
* exercise's text models have name `text.`_format_
* exercise models have name _format.format_

Templates may contain the special words `%SURNAME%`, `%NAME%`, `%STUDENT_ID%`,
`%LAB_NUM%` and `%EXERCISE_NUM%` that will be automagically substituted
accordingly after models have been copied (based on values in `config` file).

## `finalize.sh`
This script packs all the contents of the current directory in a tar.gz archive
ready to be uploaded to the portal to get a 30 at the exam.

Before doing that, it tries to convert the reports and exercises' text to the
PDF format using `pandoc` (works only with Markdown documents at the moment).  
Files that don't need to be uploaded are deleted (.odt, .md, .jpg, .png, binary
files)

## Example of use
```
$ ../create.sh
```
The script can be called from any dir, and it will try to generate the
structure on the current working directory.
```
:::: OS's Homework's Files Generator 1.1 - GOLD Edition ::::
reading config file ...DONE!
insert laboratory number (1,2,3,..): 
> 3
insert number of exercises (1,2,3,..): 
> 2
zip name is "S241543903_L03_HectorSalamanca"
```
Laboratory 3 has 2 exercises.  
Since I'm a good boy, I have edited the config file and now the archive name is
correct.
```
available exercise's types:
c
sh
choose type of exercise: 
> sh
```
The 2 exercises are of type sh
```
creating structure on disk ...
'/home/andrea/sorgenti/github/OSHFG-GE/templates/report.md' -> 'D01/E01_report.md'
'/home/andrea/sorgenti/github/OSHFG-GE/templates/text.md' -> 'D01/E01_text.md'
'/home/andrea/sorgenti/github/OSHFG-GE/templates/sh.sh' -> 'D01/E01.sh'
'/home/andrea/sorgenti/github/OSHFG-GE/templates/report.md' -> 'D02/E02_report.md'
'/home/andrea/sorgenti/github/OSHFG-GE/templates/text.md' -> 'D02/E02_text.md'
'/home/andrea/sorgenti/github/OSHFG-GE/templates/sh.sh' -> 'D02/E02.sh'
```
(program terminates)

I do the homework:
* copy exercise texts to markdown
* write E01.sh and E02.sh
* write reports
* don't search for 241543903 on google images

And now it's time to submit the homework
```
$ cd S241543903_L03_HectorSalamanca
$ ../../finalize.sh
:::: OS's Homework's Files Generator 1.1 - GOLD Edition ::::
WARNING: considering the current directory as the exercise's directory
 (/home/andrea/sorgenti/github/OSHFG-GE/fuffa/S241543903_L03_HectorSalamanca)
it seems you wrote the reports in MarkDown!
do you want to convert them automatically in PDF?
 [Y, n]
Y
```
Of course: I'm lazy  
**Note** that if the reports were written in `odt` format then they have to be
converted manually!
```
elaborating "D01" ...
elaborating "D02" ...
creating copy of S241543903_L03_HectorSalamanca to work on ...
removing unneeded files ...
creating archive S241543903_L03_HectorSalamanca.tar.gz ...

final result of S241543903_L03_HectorSalamanca.tar.gz :
D01/
D01/E01_text.pdf
D01/E01.sh
D01/E01_report.pdf
D02/
D02/E02.sh
D02/E02_report.pdf
D02/E02_text.pdf
```
Script terminates and on the upper level directory there is the archive and
I'm very happy of all the time that there is left in the day to not create
manually directories and files.
