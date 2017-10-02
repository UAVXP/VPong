rem "C:\Program Files\LOVE\love.exe" "D:\Games\VPong"
if exist "%ProgramFiles%\LOVE\love.exe" (
	"%ProgramFiles%\LOVE\love.exe" "D:\Games\VPong"
) else (
	if exist "%ProgramFiles(x86)%\LOVE\love.exe" (
		"%ProgramFiles(x86)%\LOVE\love.exe" "D:\Games\VPong"
	) else (
		echo LOVE2D doesn't exist!
		pause
		exit
	)
)