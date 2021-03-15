<#
This example script can be used to block every country and then only allow specific IP addresses, forming a simple blocklist. 



#>


#For your convenience an array of all the countries in WaaS
$country_array = ("AX", "AF", "AL", "DZ", "AS", "AD", "AO", "AI", "AQ", "AG", "AR", "AM", "AW", "AU", "AT", "AZ", "BS", "BH", "BD", "BB", "BY", "BE", "BZ", "BJ", "BM", "BT", "BO", "BA", "BW", "BV", "BR", "IO", "BN", "BG", "BF", "BI", "KH", "CM", "CA", "CV", "KY", "CF", "TD", "CL", "CN", "CX", "CC", "CO", "KM", "CG", "CD", "CK", "CR", "CI", "HR", "CU", "CY", "CZ", "DK", "DJ", "DM", "DO", "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FO", "FJ", "FI", "FR", "GF", "PF", "TF", "GA", "GM", "GE", "DE", "GH", "GI", "GR", "GL", "GD", "GP", "GU", "GT", "GG", "GN", "GW", "GY", "HT", "HM", "VA", "HN", "HK", "HU", "IS", "IN", "ID", "IR", "IQ", "IE", "IM", "IL", "IT", "JM", "JP", "JE", "JO", "KZ", "KE", "KI", "KP", "KR", "KW", "KG", "LA", "LV", "LB", "LS", "LR", "LY", "LI", "LT", "LU", "MO", "MK", "MG", "MW", "MY", "MV", "ML", "MT", "MH", "MQ", "MR", "MU", "YT", "MX", "FM", "MD", "MC", "MN", "MS", "MA", "MZ", "MM", "NA", "NR", "NP", "NL", "NC", "NZ", "NI", "NE", "NG", "NU", "NF", "MP", "NO", "OM", "PK", "PW", "PS", "PA", "PG", "PY", "PE", "PH", "PN", "PL", "PT", "PR", "QA", "RE", "RO", "RU", "RW", "SH", "KN", "LC", "PM", "VC", "WS", "SM", "ST", "SA", "SN", "SC", "SL", "SG", "SK", "SI", "SB", "SO", "ZA", "GS", "ES", "LK", "SD", "SR", "SJ", "SZ", "SE", "CH", "SY", "TW", "TJ", "TZ", "TH", "TL", "TG", "TK", "TO", "TT", "TN", "TR", "TM", "TC", "TV", "UG", "UA", "AE", "GB", "UM", "UY", "UZ", "US", "VU", "VE", "VN", "VG", "VI", "WF", "EH", "YE", "ZM", "ZW")


#either create an array of hashtable values, in the format ip=10.2.5.0;netmask=255.255.255.0,
$network_exceptions =  @(@{"allow"=true;"ip"="";"netmask"=""},@{"allow"=false;"ip"="";"netmask"=""})

#or import a CSV in the format below, set the allow column to true of false to permit or deny access
<#
allow,ip,netmask
true,10.2.5.0,255.255.255.0
false,192.168.1.1,255.255.255.128
true,10.7.1.5,255.255.255.255
#>
$list = Get-Content -Path C:\Store\sample.csv | ConvertFrom-Csv -Delimiter "," 

#Provide login creds
$waas_creds = Get-Credential

#Login to WaaS
$waas_token = Login-BarracudaWaaS -credentials $waas_creds 

#Get your Apps
$apps = Get-BarracudaWaaS-Application -authkey $waas_token.key 

$apps | Format-Table

#You need to collect the Application ID from here to use in the next commands.

$appid = 

#Get the existing IP Reputation Settings
$iprep = Get-BarracudaWaaS-IPReputation -authkey $waas_token.key -application_id $appid

#Keeps the existing settings and adds the blocked countries. 
$iprep | Set-BarracudaWaaS-IPReputation -authkey $waas_token.key -id $iprep.id -application_id $appid -network_exceptions $list -blocked_countries $country_array