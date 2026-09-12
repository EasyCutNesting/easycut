set str=This\message\ needs\changed. 
echo %str% 

set str=%str:\=\\% 
echo %str%