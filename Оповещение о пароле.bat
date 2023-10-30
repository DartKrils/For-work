@echo off

powershell.exe -ExecutionPolicy Bypass -Command " 
$smtpServer = 'smtp.yandex.ru'
$smtpPort = '587'
$username = 'ваша почта'
$password = 'пароль от почты'
$senderEmail = 'ваша почта'

$domain = 'название вашего домена'
$daysBeforeExpiration = 5

$date = Get-Date
$expirationDate = $date.AddDays($daysBeforeExpiration)

Import-Module ActiveDirectory

users = Get-ADUser -Filter -Server $domain -Properties EmailAddress, PasswordLastSet, PasswordExpires | Where-Object { $_.PasswordExpires -lt $expirationDate }
foreach ($user in $users) {
    $emailAddress = $user.EmailAddress
    $lastSet = $user.PasswordLastSet
    $expires = $user.PasswordExpires

    $subject = 'Уведомление о истекающем пароле'
    $body = 'Уважаемый(ая) ' + $user.Name + ',' + "`n`n" +
            'Срок действия вашего пароля истекает через ' + $daysBeforeExpiration + ' дней.' + "`n" +
            'Дата последнего изменения пароля: ' + $lastSet.ToShortDateString() + "`n" +
            'Дата истечения пароля: ' + $expires.ToShortDateString() + "`n`n" +
            'Пожалуйста, обновите свой пароль в ближайшее время.' + "`n" +
            'С уважением,' + "`n" +
            

    Send-MailMessage -To $emailAddress -From $senderEmail -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential (New-Object System.Management.Automation.PSCredential($username, (ConvertTo-SecureString -String $password -AsPlainText -Force)))
}
"
