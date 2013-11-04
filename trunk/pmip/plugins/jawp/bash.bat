@echo off
rem ## TIP: you must have run firstTimeSetup.bat first - to install cygwin
rem ### magic to make cygwin use the current directory for its working directory, see: http://superuser.com/questions/345964/start-bash-shell-cygwin-with-correct-path-without-changing-directory
set CHERE_INVOKED=1
rem ### replace all the "\" into "/" before passing the current directory to cygwin
set cwd=%CD%
set cwd=%cwd:\=/%
cls
\cygwin\bin\bash.exe -l -c "cd %cwd%;./%1 %2"
