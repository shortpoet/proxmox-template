<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">

  <!-- computer name on network while provisioning: VAGRANT-50DDSO0 -->

  <settings pass="windowsPE">

    <component name="Microsoft-Windows-PnpCustomizationsWinPE" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" processorArchitecture="amd64"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
      <DriverPaths>
        <PathAndCredentials wcm:action="add" wcm:keyValue="2">
          <Path>${drive_letter_drivers}:\viostor\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="3">
          <Path>${drive_letter_drivers}:\NetKVM\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="4">
          <Path>${drive_letter_drivers}:\Balloon\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="5">
          <Path>${drive_letter_drivers}:\pvpanic\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="6">
          <Path>${drive_letter_drivers}:\qemupciserial\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="7">
          <Path>${drive_letter_drivers}:\qxldod\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="8">
          <Path>${drive_letter_drivers}:\vioinput\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="9">
          <Path>${drive_letter_drivers}:\viorng\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="10">
          <Path>${drive_letter_drivers}:\vioscsi\w10\amd64</Path>
        </PathAndCredentials>
        <PathAndCredentials wcm:action="add" wcm:keyValue="11">
          <Path>${drive_letter_drivers}:\vioserial\w10\amd64</Path>
        </PathAndCredentials>
      </DriverPaths>
    </component>

    <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SetupUILanguage>
        <UILanguage>${locale_name}</UILanguage>
      </SetupUILanguage>
      <InputLocale>${locale_code}</InputLocale>
      <SystemLocale>${locale_name}</SystemLocale>
      <UILanguage>${locale_name}</UILanguage>
      <UILanguageFallback>${locale_name}</UILanguageFallback>
      <UserLocale>${locale_name}</UserLocale>
    </component>

    <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <DiskConfiguration>
        <Disk wcm:action="add">
          <CreatePartitions>
            <CreatePartition wcm:action="add">
              <Order>1</Order>
              <Type>Primary</Type>
              <Extend>true</Extend>
            </CreatePartition>
          </CreatePartitions>
          <ModifyPartitions>
            <ModifyPartition wcm:action="add">
              <Format>NTFS</Format>
              <Label>System</Label>
              <Letter>C</Letter>
              <Order>1</Order>
              <PartitionID>1</PartitionID>
            </ModifyPartition>
          </ModifyPartitions>
          <DiskID>0</DiskID>
          <WillWipeDisk>true</WillWipeDisk>
        </Disk>
      </DiskConfiguration>
      <ImageInstall>
        <OSImage>
          <InstallTo>
            <DiskID>0</DiskID>
            <PartitionID>1</PartitionID>
          </InstallTo>
          <InstallToAvailablePartition>false</InstallToAvailablePartition>
          <InstallFrom>
            <MetaData wcm:action="add">
              <Key>/IMAGE/NAME</Key>
              <Value>${image_name}</Value>
            </MetaData>
          </InstallFrom>
        </OSImage>
      </ImageInstall>
      <UserData>
        <!-- Do not uncomment the Key element if you are using trial ISOs -->
        <!-- You must uncomment the Key element (and optionally insert your own key) if you are using retail or volume license ISOs -->
        <!-- Product Key from http://technet.microsoft.com/en-US/library/jj612867.aspx -->
        <ProductKey>
          <WillShowUI>Never</WillShowUI>
          <Key>${image_product_key}</Key>
        </ProductKey>
        <AcceptEula>true</AcceptEula>
        <FullName>${user_name}</FullName>
        <Organization>${user_registered_org}</Organization>
      </UserData>
    </component>
  </settings>

  <settings pass="generalize">
    <component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SkipRearm>1</SkipRearm>
    </component>
  </settings>

  <settings pass="specialize">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <ComputerName>${hostname}</ComputerName>
      <ProductKey>${image_product_key}</ProductKey>
      <!-- <ProductKey>W269N-WFGWX-YVC9B-4J6C9-T83GX</ProductKey> -->
      <OEMInformation>
        <HelpCustomized>false</HelpCustomized>
      </OEMInformation>
      <!-- <ComputerName>*</ComputerName> -->
      <!-- <TimeZone></TimeZone> -->
      <!-- <RegisteredOwner/> -->
    </component>


    <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <InputLocale>${locale_code}</InputLocale>
      <SystemLocale>${locale_name}</SystemLocale>
      <UILanguage>${locale_name}</UILanguage>
      <UILanguageFallback>${locale_name}</UILanguageFallback>
      <UserLocale>${locale_name}</UserLocale>
    </component>

    <component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <fDenyTSConnections>false</fDenyTSConnections>
    </component>

    <component name="Networking-MPSSVC-Svc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <FirewallGroups>
        <FirewallGroup wcm:action="add" wcm:keyValue="RemoteDesktop">
          <Active>true</Active>
          <Group>Remote Desktop</Group>
          <Profile>all</Profile>
        </FirewallGroup>
      </FirewallGroups>
    </component>

    <component name="Microsoft-Windows-TerminalServices-RDP-WinStationExtensions" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SecurityLayer>1</SecurityLayer>
      <UserAuthentication>0</UserAuthentication>
    </component>

    <component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <SkipAutoActivation>true</SkipAutoActivation>
    </component>

    <!-- <component name="Microsoft-Windows-ServerManager-SvrMgrNc" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> -->
    <!-- <DoNotOpenServerManagerAtLogon>true</DoNotOpenServerManagerAtLogon> -->
    <!-- </component> -->

    <!-- <component name="Microsoft-Windows-IE-ESC" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> -->
    <!-- <IEHardenAdmin>false</IEHardenAdmin> -->
    <!-- <IEHardenUser>false</IEHardenUser> -->
    <!-- </component> -->

    <!-- <component name="Microsoft-Windows-OutOfBoxExperience" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> -->
    <!-- <DoNotOpenInitialConfigurationTasksAtLogon>true</DoNotOpenInitialConfigurationTasksAtLogon> -->
    <!-- </component> -->

    <component name="Microsoft-Windows-SQMApi" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <CEIPEnabled>0</CEIPEnabled>
    </component>
  </settings>

  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <NetworkLocation>Home</NetworkLocation>
        <SkipUserOOBE>true</SkipUserOOBE>
        <SkipMachineOOBE>true</SkipMachineOOBE>
        <ProtectYourPC>1</ProtectYourPC>
      </OOBE>

      <RegisteredOrganization>${user_registered_org}</RegisteredOrganization>
      <RegisteredOwner>${user_registered_owner}</RegisteredOwner>
      <DisableAutoDaylightTimeSet>false</DisableAutoDaylightTimeSet>
      <TimeZone>${locale_time_zone}</TimeZone>

      <UserAccounts>
        <LocalAccounts>
          <LocalAccount wcm:action="add">
            <Password>
              <Value>${user_password}</Value>
              <PlainText>${user_is_pw_plain_text}</PlainText>
            </Password>
            <Description></Description>
            <DisplayName>${user_display_name}</DisplayName>
            <Group>${user_group}</Group>
            <Name>${user_name}</Name>
          </LocalAccount>
        </LocalAccounts>
      </UserAccounts>

      <!-- <RegisteredOwner /> -->

      <AutoLogon>
        <Password>
          <Value>${user_password}</Value>
          <PlainText>${user_is_pw_plain_text}</PlainText>
        </Password>
        <Enabled>true</Enabled>
        <Username>${user_name}</Username>
      </AutoLogon>

      <FirstLogonCommands>

        <SynchronousCommand wcm:action="add">
          <CommandLine>cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</CommandLine>
          <Description>Set Execution Policy 64 Bit</Description>
          <Order>1</Order>
          <RequiresUserInput>true</RequiresUserInput>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>C:\Windows\SysWOW64\cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"</CommandLine>
          <Description>Set Execution Policy 32 Bit</Description>
          <Order>2</Order>
          <RequiresUserInput>true</RequiresUserInput>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>cmd.exe /c reg add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff"</CommandLine>
          <Description>Disable Network Discovery Prompt</Description>
          <Order>3</Order>
          <RequiresUserInput>true</RequiresUserInput>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File ${drive_letter_scripts}:\scripts\disable_winrm.ps1</CommandLine>
          <Description>Disable WinRM</Description>
          <Order>4</Order>
          <RequiresUserInput>true</RequiresUserInput>
        </SynchronousCommand>

        <!-- {% if agent is match("enabled=1") %} -->
        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -Command "${drive_letter_drivers}:\guest-agent\qemu-ga-x86_64.msi /quiet"</CommandLine>
          <Order>5</Order>
          <Description>Install qemu-guest-agent</Description>
        </SynchronousCommand>
        <!-- {% endif %} -->

        <SynchronousCommand wcm:action="add">
          <CommandLine>%SystemRoot%\System32\reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "vagrant" /f</CommandLine>
          <Order>10</Order>
          <Description>Enable AutoLogon</Description>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>%SystemRoot%\System32\reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f</CommandLine>
          <Order>11</Order>
          <Description>Enable AutoLogon</Description>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell -File ${drive_letter_scripts}:\scripts\test.ps1</CommandLine>
          <Description>test</Description>
          <Order>20</Order>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell -File ${drive_letter_scripts}:\scripts\Prep-Ansible.ps1</CommandLine>
          <Description>Configure Ansible Prep and WinRM</Description>
          <Order>30</Order>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell -File ${drive_letter_scripts}:\scripts\win-updates-pass1.ps1</CommandLine>
          <Description>Install Get-WindowsUpdate module and Windows Updates Pass 1</Description>
          <Order>40</Order>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell Start-Sleep -Seconds 20</CommandLine>
          <Description>Insert a pause to prevent update pass 2 from starting just before reboot</Description>
          <Order>41</Order>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell -File ${drive_letter_scripts}:\scripts\win-updates-pass2.ps1</CommandLine>
          <Description>Install Windows Updates Pass 2</Description>
          <Order>50</Order>
        </SynchronousCommand>

        <!-- <SynchronousCommand wcm:action="add"> -->
        <!-- <Order>4</Order> -->
        <!-- <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -Command "netsh advfirewall firewall set rule group='Windows Remote Management' new enable=yes"</CommandLine> -->
        <!-- </SynchronousCommand> -->

        <!-- <SynchronousCommand wcm:action="add"> -->
        <!-- <Order>5</Order> -->
        <!-- <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -Command "netsh advfirewall firewall add rule name='ICMP Allow incoming V4 echo request' protocol=icmpv4:8,any dir=in action=allow"</CommandLine> -->
        <!-- </SynchronousCommand> -->

        <!-- <SynchronousCommand wcm:action="add"> -->
        <!-- <Order>6</Order> -->
        <!-- <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-NetAdapter | foreach { Disable-NetAdapterBinding -InterfaceAlias $_.Name -ComponentID ms_tcpip6 }"</CommandLine> -->
        <!-- </SynchronousCommand> -->

        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell Start-Sleep -Seconds 25</CommandLine>
          <Description>Insert a pause to prevent possible reboot during sysprep</Description>
          <Order>51</Order>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>powershell Start-Sleep -Seconds 30</CommandLine>
          <Description>One more pause to prevent an early sysprep start</Description>
          <Order>52</Order>
        </SynchronousCommand>

        <SynchronousCommand wcm:action="add">
          <CommandLine>c:\windows\system32\sysprep\sysprep /generalize /oobe /reboot</CommandLine>
          <Description>Sysprep</Description>
          <Order>99</Order>
        </SynchronousCommand>


        <!-- <SynchronousCommand wcm:action="add"> -->
        <!-- <Order>8</Order> -->
        <!-- <CommandLine>powershell -NoProfile -ExecutionPolicy Bypass -Command "netsh interface teredo set state disabled"</CommandLine> -->
        <!-- </SynchronousCommand> -->

      </FirstLogonCommands>
    </component>

  </settings>

  <settings pass="offlineServicing">
    <component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <EnableLUA>false</EnableLUA>
    </component>
  </settings>

  <cpi:offlineImage cpi:source=${image_catalog_source} xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>
