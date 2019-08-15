## System Variables:
## This script uses the current user as an added variable in the message
## body.

$user = [Environment]::UserName

## Send Settings:
## A single configuration file controls most of the other components of
## this script allowing for minimal in-script editing of commands and
## actions performed, one thing that will need to be edited is the
## location of the file itself.

$automailerconfig =  cat "\\######\auto-mailer-config.json" | ConvertFrom-Json

## Message Message Construction:
## The lines bellow write the content of the message to  memory with data
## from the configuration files and system called variables. 

## $htmlobject - the base HTML template, this file controls the visual
## appearance of the message with embedded CSS
$htmltemplate = "$(cat $automailerconfig.htmltemplate)"

## $maildate - a simple date stamp added to the end of the subject line
$maildate = Get-Date -Format $automailerconfig.timestamp

## $subject - subject line in the message, formed from what is in the
## configuration file and the $maildate variable
$subject = "$($automailerconfig.subject) $maildate"

## $htmlnote - the actual content of the message to be include in the body
$htmlnote = "$($automailerconfig.htmlnote)"

## $htmlbody - body of the message fully assembled with all previously defined parts
$htmlbody = $htmltemplate.Replace("<var id=title>",$subject).Replace("<var id=htmlnote>",$htmlnote).Replace("<var id=user>",$user)

## Send Command
## "Send-MailMessage" is a build-in PowerShell command that can be used to
## send an email message, it uses multiple perameters to construct and send the
## message to the defined recipients.

Send-MailMessage -SmtpServer $automailerconfig.serveraddress -UseSsl -To $automailerconfig.recipients -From $automailerconfig.sender -Subject $subject -Body $htmlbody -BodyAsHTML
