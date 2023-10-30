Users = Get-ADUser -SearchBase 'OU=название ,DC=,DC=ваш домен,DC=ru' -filter -Properties msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword, UserPrincipalName
$Users | select @{Name="Email";Expression={$_.UserPrincipalName}}, @{Name="ExpirationDate";Expression= {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, PasswordLastSet | Export-Csv -Path "C:\pass.csv" -NoTypeInformation

$Excel = New-Object -ComObject Excel.Application
$Workbook = $Excel.Workbooks.Open("C:\pass.csv")
$Worksheet = $Workbook.Worksheets.item(1)
$Worksheet.Name = "User Passwords"
$Workbook.SaveAs("C:\pass.xlsx", 51)
$Excel.Quit()