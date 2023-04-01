powershell -command "& { Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser }"
powershell -command "& { . .\split-pdf.ps1 }"
powershell -command "& { Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser }"

pause