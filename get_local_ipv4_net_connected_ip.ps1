function Get-SubnetAddresses {

# https://stackoverflow.com/questions/67828512/building-a-list-of-ip-addresses

  Param (
    [IPAddress]$IP,
    [ValidateRange(0, 32)][int]$maskbits
  )

  # Convert the mask to type [IPAddress]:
  $mask = ([Math]::Pow(2, $MaskBits) - 1) * [Math]::Pow(2, (32 - $MaskBits))
  $maskbytes = [BitConverter]::GetBytes([UInt32] $mask)
  $DottedMask = [IPAddress]((3..0 | ForEach-Object { [String] $maskbytes[$_] }) -join '.')
  
  # bitwise AND them together, and you've got the subnet ID
  $lower = [IPAddress] ( $ip.Address -band $DottedMask.Address )

  # We can do a similar operation for the broadcast address
  # subnet mask bytes need to be inverted and reversed before adding
  $LowerBytes = [BitConverter]::GetBytes([UInt32] $lower.Address)
  [IPAddress]$upper = (0..3 | %{$LowerBytes[$_] + ($maskbytes[(3-$_)] -bxor 255)}) -join '.'

  # Make an object for use elsewhere
  Return [pscustomobject][ordered]@{
    Lower=$lower
    Upper=$upper
  }
}
Function Get-IPRange {
	
# https://stackoverflow.com/questions/67828512/building-a-list-of-ip-addresses

param (
  [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)][IPAddress]$lower,
  [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)][IPAddress]$upper
)
  # use lists for speed
  $IPList = [Collections.ArrayList]::new()
  $null = $IPList.Add($lower)
  $i = $lower

  # increment ip until reaching $upper in range
  while ( $i -ne $upper ) { 
    # IP octet values are built back-to-front, so reverse the octet order
    $iBytes = [BitConverter]::GetBytes([UInt32] $i.Address)
    [Array]::Reverse($iBytes)

    # Then we can +1 the int value and reverse again
    $nextBytes = [BitConverter]::GetBytes([UInt32]([bitconverter]::ToUInt32($iBytes,0) +1))
    [Array]::Reverse($nextBytes)

    # Convert to IP and add to list
    $i = [IPAddress]$nextBytes
    $null = $IPList.Add($i)
  }

  return $IPList
}

$a = Get-NetIPAddress |  ? {$_.interfaceindex -eq (Get-NetRoute -DestinationPrefix "0.0.0.0/0").interfaceindex} | ? {$_.addressfamily -eq "IPv4"}

$cidr = "$($a.IPv4Address)/$($a.PrefixLength)"
$list = Get-SubnetAddresses $a.IPv4Address $a.PrefixLength| Get-IPRange | Select -ExpandProperty IPAddressToString

$list.count