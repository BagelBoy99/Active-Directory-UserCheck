#Uncomment the below line if you are wanting to use the unlock feature as it requires elevated permissions.
#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Add-Type -AssemblyName System.Windows.Forms

$FormObject= [System.Windows.Forms.Form]
$LabelObject=[System.Windows.Forms.Label]
$ComboBoxObject=[System.Windows.Forms.ComboBox]
$TextBoxObject = [System.Windows.Forms.TextBox]
$ButtonObject = [System.Windows.Forms.Button]

#Variables
$DefaultFont = 'Verdana, 10'
$HeaderFont= 'Verdana, 12'
$underFont= 'Verdana, 8, style=italic'

$iconPath = "C:\path\to\logo.ico" #insert path to .ico file for icon
$icon = New-Object System.Drawing.Icon($iconPath)

$backPath = "C:\Path\to\background.png" #insert path to background image

#Set Base Form
$AppForm= New-Object $FormObject
$AppForm.ClientSize= '600,100'
$AppForm.Text= 'Account Status'
$AppForm.BackColor=''
$AppForm.Font=$DefaultFont
$AppForm.FormBorderStyle = 'FixedSingle'
$Appform.KeyPreview = $true
$AppForm.Icon = $icon
$AppForm.BackgroundImage = [System.Drawing.Image]::FromFile($backPath)


#Input Box
$TextBox= New-Object $TextBoxObject
$TextBox.Width= '150'
$TextBox.Text= ''
$TextBox.Location= New-Object System.Drawing.Point(140,20)

#Drop Down Box
$ddlName= New-Object $ComboBoxObject
$ddlName.Width= '200'
$ddlName.Location= New-Object System.Drawing.Point(300,20)

#Name Request
$lblName= New-Object $LabelObject
$lblName.Text='User Name :'
$lblName.AutoSize= $true
$lblName.backcolor = [System.Drawing.Color]::FromName("Transparent")
$lblName.Location= New-Object System.Drawing.Point(20,20)

#region "Usr Info"

#Title
$lblfordate= New-Object $LabelObject
$lblfordate.Text=''
$lblfordate.AutoSize= $true
$lblfordate.backcolor = [System.Drawing.Color]::FromName("Transparent")
$lblfordate.Location= New-Object System.Drawing.Point(20,150)

#Location -------------------------------
$lblforlocat= New-Object $LabelObject
$lblforlocat.Text=''
$lblforlocat.AutoSize= $true
$lblforlocat.Forecolor= 'Darkmagenta'
$lblforlocat.Font= $underFont
$lblforlocat.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblforlocat.Location= New-Object System.Drawing.Point(20,102)

#Full Name 
$lblusr= New-Object $LabelObject
$lblusr.Text=''
$lblusr.AutoSize= $true
$lblusr.Font= $HeaderFont
$lblusr.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblusr.Location= New-Object System.Drawing.Point(20,60)

#User Title -------------------------------
$lbltitle= New-Object $LabelObject
$lbltitle.Text=''
$lbltitle.AutoSize= $true
$lbltitle.Font= $underFont
$lbltitle.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lbltitle.Location= New-Object System.Drawing.Point(20,60)


#Department -------------------------------
$lblpart= New-Object $LabelObject
$lblpart.Text=''
$lblpart.AutoSize= $true
$lblpart.Font= $underFont
$lblpart.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblpart.Location= New-Object System.Drawing.Point(20,85)


#Password Expiration -------------------------------
$lblForexp= New-Object $LabelObject
$lblForexp.Text=""
$lblForexp.AutoSize= $true
$lblFOrexp.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblForexp.Location= New-Object System.Drawing.Point(450,180)

#Lock Result
$lblStatus= New-Object $LabelObject
$lblStatus.Text=''
$lblStatus.AutoSize= $true
$lblStatus.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblStatus.Location= New-Object System.Drawing.Point(450,245)

#Email -------------------------
$lblmail= New-Object $LabelObject
$lblmail.Text=''
$lblmail.AutoSize= $true
$lblmail.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblmail.Location= New-Object System.Drawing.Point(20,250)

#Phone ------------------------------------
$lblphone= New-Object $LabelObject
$lblphone.Text=''
$lblphone.AutoSize= $true
$lblphone.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblphone.Location= New-Object System.Drawing.Point(20,228)

#Manager ------------------------------------
$lblMan= New-Object $LabelObject
$lblMan.Text=''
$lblMan.AutoSize= $true
$lblMan.BackColor=[System.Drawing.Color]::FromName("Transparent")
$lblMan.Location= New-Object System.Drawing.Point(20,120)

#endregion

#region "BUTTONS"

#Check button -------------------------------
$buttonCheck = New-Object $ButtonObject
$buttonCheck.Text='parse'
$buttonCheck.AutoSize= $false
$buttonCheck.BackColor='#f7f7f9'
$buttonCheck.Location= New-Object System.Drawing.Point(505,15)

#Confirm button
$buttonConfirm = New-Object $ButtonObject
$buttonConfirm.Text='copy number'
$buttonConfirm.AutoSize= $true
$buttonConfirm.BackColor='#f7f7f9'
$buttonConfirm.Font= $underFont
$buttonConfirm.Location= New-Object System.Drawing.Point(20,190)

#Check button -------------------------------
$buttonUnlock = New-Object $ButtonObject
$buttonUnlock.Text='Unlock'
$buttonUnlock.AutoSize= $true
$buttonUnlock.BackColor='#f7f7f9'
$buttonUnlock.Location= New-Object System.Drawing.Point(508,18)
#endregion


$AppForm.Controls.AddRange(@($TextBox,$lblfordate,$lblMan,$lblName,$ddlName,$lblphone,$lblpart,$lblStatus,$lblForexp,$lblusr,$lblforlocat,$lblmail))



#Function for looking up name
Function Parse(){
    $AppForm.ClientSize= '600,300'
    $AppForm.Controls.Add($buttonConfirm)
    $ddlName.Items.Clear()
    $UsrName = $TextBox.Text
    Get-AdUser -Filter "DisplayName -like '*$UsrName*'" -Properties DisplayName | ForEach-Object {$ddlName.Items.Add($_.Name)}
    
    $ddlName.SelectedIndex= 0 
    $TextBox.Text = ''
    Check
}

#Function for looking up user info
Function Check(){
    $Name = $ddlName.SelectedItem
    $details = Get-AdUser -Filter "DisplayName -like '$Name'" -Properties * 
    $lblusr.Text= ($details.Displayname, ' - ',$details.Title)
    $lblpart.Text = $details.Department
    $lblforlocat.Text = $details.physicalDeliveryOfficeName
    $lblmail.Text = $details.mail
    $lblphone.Text = $details.OfficePhone
    $manager = ($details.manager -split "," | ConvertFrom-StringData).CN
    $lblMan.Text ='Manager: '+$manager
    
    #Lockout Text
    $lblStatus.Text= $details.LockedOut
    if($lblStatus.text -eq 'False'){
        $lblStatus.Text = 'Unlocked'
        $lblStatus.ForeColor = 'green'
        $lblStatus.Font = 'Verdana, 12, style=bold'
        $AppForm.Controls.AddRange(@($buttonUnlock))
    }elseif($lblStatus.Text -eq 'True'){
        $lblStatus.text= 'Locked!'
        $lblStatus.ForeColor= 'red'
        $lblStatus.Font = 'Verdana, 12, style=bold'
        $AppForm.Controls.AddRange(@($buttonUnlock))
    }else{
        $lblStatus.Text = ''
    }

    #Password Expire
    $lblforexp.Text = $details.PasswordExpired
    if($lblforexp.Text -eq 'True'){
        $lblforexp.Text= "Password`n Expired"
        $lblforexp.ForeColor = 'red'
        $lblforexp.Font= 'Verdana, 12, style=bold'
    }else{
        $lblforexp.Text= ''
    }
    
}

#Function for unlocking users. 
Function Unlock(){
    $Name = $ddlName.SelectedItem
    $details = Get-AdUser -Filter "DisplayName -like '$Name'" -Properties SamAccountName
    $account= $details.SamAccountName
    
    Unlock-ADAccount -Identity $account 
    $Name = $ddlName.SelectedItem
    $details = Get-AdUser -Filter "DisplayName -like '$Name'" -Properties LockedOut
    $lblStatus.Text= $details.LockedOut
    if($lblStatus.text -eq 'False'){
        $lblStatus.Text = 'Unlocked'
        $lblStatus.ForeColor = 'green'
        $lblStatus.Font = 'Verdana, 12, style=bold'
        $AppForm.Controls.AddRange(@($buttonUnlock))
    }elseif($lblStatus.Text -eq 'True'){
        $lblStatus.text= 'Locked!'
        $lblStatus.ForeColor= 'red'
        $lblStatus.Font = 'Verdana, 12, style=bold'
        $AppForm.Controls.AddRange(@($buttonUnlock))
    }else{
        $lblStatus.Text = ''
    }
}




#Function for check button
$buttonCheck.Add_Click({Parse})
$ddlName.Add_SelectedIndexChanged({Check})
$buttonUnlock.Add_Click({Unlock})
$buttonConfirm.Add_Click({
    [System.Windows.Forms.Clipboard]::SetText($lblphone.Text)
})

#Allows the ability to hit enter when searching names. 
$Appform.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
    $buttonCheck.PerformClick() 
    }
})


#Show the Form
$AppForm.ShowDialog()

#Garbage Collection
$AppForm.Dispose()