#Script to send email notification to users within 7 days of password expiration

#Import AD Module
 Import-Module ActiveDirectory


#Create warning dates for future password expiration
$SevenDayWarnDate = (get-date).adddays(7).ToLongDateString()
$SixDayWarnDate = (get-date).AddDays(6).ToLongDateString()
$FiveDayWarnDate = (get-date).AddDays(5).ToLongDateString()
$FourDayWarnDate = (get-date).AddDays(4).ToLongDateString()
$ThreeDayWarnDate = (get-date).adddays(3).ToLongDateString()
$TwoDayWarnDate = (get-date).AddDays(2).ToLongDateString()
$OneDayWarnDate = (get-date).adddays(1).ToLongDateString()

#Email Variables
$TestingEmail = 'matthewh@partnercoloradocu.org'
$MailSender = " IT Helpdesk <it@partnercoloradocu.org>"
$Subject = 'Your Windows Password is Expiring Soon'
$EmailStub1 = 'I am a bot and performed this action automatically. I am here to inform you that the password for'
$EmailStub2 = 'will expire in'
$EmailStub3 = 'day(s) on'
$EmailStub4 = '. Please contact the helpdesk if you need assistance changing your password.'
$SMTPServer = 'mx2.partnercoloradocu.org'

#Find accounts that are enabled and have expiring passwords
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordLastSet -gt 0 } `
 -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Name", "EmailAddress", `
 @{Name = "PasswordExpiry"; Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed").tolongdatestring() }}

#check password expiration date and send email on match
foreach ($user in $users) {
     if ($user.PasswordExpiry -eq $SevenDayWarnDate) {
         $days = 7
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $SevenDayWarnDate, $EmailStub4 -join ' '

         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
       #  Send-MailMessage -To $TestingEmail -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody


     }
     elseif ($user.PasswordExpiry -eq $SixDayWarnDate) {
         $days = 6
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $SixDayWarnDate, $EmailStub4 -join ' '

         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
       #  Send-MailMessage -To $TestingEmail -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $FiveDayWarnDate) {
         $days = 5
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $FiveDayWarnDate, $EmailStub4 -join ' '

         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
       #  Send-MailMessage -To $TestingEmail -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $FourDayWarnDate) {
         $days = 4
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $FourDayWarnDate, $EmailStub4 -join ' '

         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
       #  Send-MailMessage -To $TestingEmail -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $ThreeDayWarnDate) {
         $days = 3
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $ThreeDayWarnDate, $EmailStub4 -join ' '

         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
       #  Send-MailMessage -To $TestingEmail -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $TwoDayWarnDate) {
         $days = 2
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $TwoDayWarnDate, $EmailStub4 -join ' '

         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
       #  Send-MailMessage -To $TestingEmail -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
     elseif ($user.PasswordExpiry -eq $oneDayWarnDate) {
         $days = 1
         $EmailBody = $EmailStub1, $user.name, $EmailStub2, $days, $EmailStub3, $OneDayWarnDate, $EmailStub4 -join ' '

         Send-MailMessage -To $user.EmailAddress -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
       #  Send-MailMessage -To $TestingEmail -From $MailSender -SmtpServer $SMTPServer -Subject $Subject -Body $EmailBody
     }
    else {}
 }