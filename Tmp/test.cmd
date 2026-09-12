@echo off
setlocal

set input_file=input.txt
set output_file=output.txt
set search_string=EasyCut

findstr /v %search_string% %input_file% > %output_file%

endlocal