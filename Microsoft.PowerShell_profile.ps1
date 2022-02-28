function prompt_custom {
	
	Import-Module posh-git

	$host.ui.RawUI.WindowTitle = "Current Folder: $pwd"
	
	$IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

	Write-host ($(if ($IsAdmin) { ' Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline

	Write-Host "$env:USERNAME" -NoNewLine -Foregroundcolor green
	Write-Host "@" -NoNewLine -Foregroundcolor DarkYellow
	Write-Host "$env:COMPUTERNAME" -NoNewLine -Foregroundcolor green
	Write-Host ":" -NoNewLine -Foregroundcolor DarkYellow
	Write-Host "$pwd" -Foregroundcolor blue

	Try {			
		$currentBranchName = [regex]::matches($(git branch), "\* ([\w-]*)").captures.groups[1].value
		Write-Host "($($currentBranchName)) " -NoNewLine -Foregroundcolor DarkYellow
	}
	Catch {
		Write-Host "" -NoNewLine
	}

	Write-Host "$(Get-Date -Format [HH:mm]) " -NoNewline -Foregroundcolor red
	"⚡⠀"
}

function prompt {
	prompt_custom
}

# Run conda_start when you want to use conda.
function conda_start {
  $CONDA_PATH = "C:\...\conda.exe"
	#region conda initialize
	# !! Contents within this block are managed by 'conda init' !!
	(& $CONDA_PATH "shell.powershell" "hook") | Out-String | Invoke-Expression
	#endregion
	
	#Fix conda Path when username contains "É"
	$Env:PATH = $Env:PATH.replace("├ë", "É")

	function prompt {
		$env = (conda info --json | ConvertFrom-Json).active_prefix_name
		Write-Host "($env) " -NoNewline -Foregroundcolor green
		prompt_custom
	}
}
