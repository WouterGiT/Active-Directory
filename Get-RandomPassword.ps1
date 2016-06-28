Function Get-RandomPassword
{
    <#
    .SYNOPSIS
        Create a random Password
 
    .DESCRIPTION
        Create a random Password
 
    .PARAMETER passwordLength
        The name of lenght of the password, default is 8.
 
    .EXAMPLE
        Get-RandomPassword
    
    .EXAMPLE
        Get-RandomPassword -passwordLength 14

    .INPUTS
        Integer
 
    .OUTPUTS
        Password is outputted to screen
 
    .NOTES
        Author:  Wouter de Dood
        Website: 
        Twitter: @WMouter
    #>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory                       = $false,
                   ValueFromPipeline               = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage                     = 'Password length (8 characters or more)')]
        [int]$passwordLength = 8
    )

    Begin
    {
        $strNumbers        = "123456789"
        $strCapitalLetters = "ABCDEFGHJKMNPQRSTUVWXYZ"
        $strLowerLetters   = "abcdefghjkmnpqrstuvwxyz"
        $strSymbols        = "!%&*()+=/?{}[],.:"
        $rand              = New-Object -TypeName System.Random
    }


    Process
    {
        if ($passwordLength -lt 8)
        {
            $passwordLength = 8
        } 
        for ($a=1; $a -le $passwordLength; $a++)
        {
            if ($a -gt 4)
            {
          	    $b = $rand.next(0,4) + $a
          	    $b = $b % 4 + 1
          	}
            else
            {
                $b = $a
            }
          	switch ($b)
          	{
          	    "1" {$b = "$strNumbers"}
          	    "2" {$b = "$strCapitalLetters"}
          	    "3" {$b = "$strLowerLetters"}
          	    "4" {$b = "$strSymbols"}
          	}
            $charset         = $($b)
            $number          = $rand.next(0,$charset.Length)
            $randomPassword += $charset[$number]
        }
    }


    End
    {
        return $randomPassword
    }
}