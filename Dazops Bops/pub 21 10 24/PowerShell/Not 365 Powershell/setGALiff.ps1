$userUPNs = @()

foreach ($upn in $userUPNs) {
    try {
        $user = Get-ADUser -filter { UserPrincipalName -eq $upn }

        if ($user) {
            set-aduser -identity $user.DistinguishedName -replace @{MSExchHideFromAddressList = $true }

        }
        else {
            write-host "$($upn) not found"
        }
    }
    catch { write-host "$($_)" }
}

foreach ($upn in $userUPNs) {
    try {
        $user = Get-ADUser -Filter {UserPrincipalName -eq $upn} -Properties msExchHideFromAddressLists

        if ($user) {
            if (-not $user.msExchHideFromAddressLists) {
                $global:UsersWithoutHideFromGAL += $user
            }
        } else {
            Write-Host "User not found: $upn" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error processing $($upn): $_" -ForegroundColor Red
    }
}

Error processing a.tidman@theparkstrust.com: Method invocation failed because [Microsoft.ActiveDirector
y.Management.ADUser] does not contain a method named 'op_Addition'



$userUPNs2 = @(
    "A.Hurren@theparkstrust.com",
    "a.tidman@theparkstrust.com",
    "B.Ahmed@theparkstrust.com",
    "d.hanley@theparkstrust.com",
    "E.Chitty@theparkstrust.com",
    "g.dundas@theparkstrust.com",
    "i.rebecchi@theparkstrust.com",
    "j.ballinger@theparkstrust.com",
    "j.burns@theparkstrust.com",
    "j.hill@willenlake.org.uk",
    "j.robertson@theparkstrust.com",
    "K.Dean@theparkstrust.com",
    "K.Odell@theparkstrust.com",
    "L.Morgan@theparkstrust.com",
    "l.smuts@theparkstrust.com",
    "m.jarman@willenlake.org.uk",
    "m.kincaid@theparkstrust.com",
    "m.lawer@theparkstrust.com",
    "n.kuzma@willenlake.org.uk",
    "p.arnold@theparkstrust.com",
    "r.blake@theparkstrust.com",
    "r.riekie@theparkstrust.com",
    "r.simpson@theparkstrust.com",
    "s.green@theparkstrust.com",
    "S.Keen@theparkstrust.com",
    "UCB@theparkstrust.com",
    "WillenAdmin@theparkstrust.com"
)

$userUPNs = @(
    "A.Bailey@theparkstrust.com",
    "a.barnes@theparkstrust.com",
    "A.chapman@theparkstrust.com",
    "A.dearn@theparkstrust.com",
    "A.Heath@theparkstrust.com",
    "A.Hurren@theparkstrust.com",
    "a.kalinevica@theparkstrust.com",
    "A.Krupinski@theparkstrust.com",
    "a.phillips@theparkstrust.com",
    "a.tidman@theparkstrust.com",
    "Administrator_Tmpl@mkpt.onmicrosoft.com",
    "B.Ahmed@theparkstrust.com",
    "b.allott@theparkstrust.com",
    "C.Goudie@willenlake.org.uk",
    "C.Jefferies@theparkstrust.com",
    "C.Kerridge@theparkstrust.com",
    "C.Lancaster@willenlake.org.uk",
    "comrang-duty-aa@mkpt.onmicrosoft.com",
    "d.foster@theparkstrust.com",
    "d.goodger@theparkstrust.com",
    "d.hanley@theparkstrust.com",
    "E.Chitty@theparkstrust.com",
    "e.Nelmes-Adams@theparkstrust.com",
    "EmployerSafe@mkpt.onmicrosoft.com",
    "eoduty-aa@theparkstrust.com",
    "eventbookings-aa@theparkstrust.com",
    "g.dundas@theparkstrust.com",
    "g.gager@theparkstrust.com",
    "Guest@mkpt.onmicrosoft.com",
    "I.Dymond@theparkstrust.com",
    "i.rebecchi@theparkstrust.com",
    "j.ballinger@theparkstrust.com",
    "j.burns@theparkstrust.com",
    "j.hill@willenlake.org.uk",
    "j.robertson@theparkstrust.com",
    "k.cope@theparkstrust.com",
    "K.Dean@theparkstrust.com",
    "k.horner@theparkstrust.com",
    "K.Odell@theparkstrust.com",
    "ka.brown@theparkstrust.com",
    "krbtgt@mkpt.onmicrosoft.com",
    "L.Ball@willenlake.org.uk",
    "l.dawson@theparkstrust.com",
    "L.Morgan@theparkstrust.com",
    "l.sims@theparkstrust.com",
    "l.smuts@theparkstrust.com",
    "landscapeofficers-cq@theparkstrust.com",
    "M.Bayley@theparkstrust.com",
    "M.Chesse@theparkstrust.com",
    "m.colton@theparkstrust.com",
    "m.jarman@willenlake.org.uk",
    "m.kincaid@theparkstrust.com",
    "m.lawer@theparkstrust.com",
    "mainoffice-aa@theparkstrust.com",
    "marina-aa@theparkstrust.com",
    "MKPARK_@mkpt.onmicrosoft.com",
    "Mobile_User_Tmpl@mkpt.onmicrosoft.com",
    "n.donovan@theparkstrust.com",
    "n.kuzma@willenlake.org.uk",
    "p.arnold@theparkstrust.com",
    "Power_User_Tmpl@mkpt.onmicrosoft.com",
    "propertyemergency-aa@theparkstrust.com",
    "purchaseledger-cq@theparkstrust.com",
    "r.blake@theparkstrust.com",
    "r.riekie@theparkstrust.com",
    "r.simpson@theparkstrust.com",
    "reception-cq@theparkstrust.com",
    "reception-vm@theparkstrust.com",
    "RevealDEMS360@mkpt.onmicrosoft.com",
    "S.Green@theparkstrust.com",
    "s.keen@theparkstrust.com",
    "S.Revill-Darton@theparkstrust.com",
    "SBS_Backup_User@mkpt.onmicrosoft.com",
    "SpiceWorks@mkpt.onmicrosoft.com",
    "T.Roxburgh@theparkstrust.com",
    "t.tomlinson@theparkstrust.com",
    "T.Walter@willenlake.org.uk",
    "UCB@theparkstrust.com",
    "User_Tmpl@mkpt.onmicrosoft.com",
    "WillenAdmin@theparkstrust.com"
)


foreach ($upn in $userUPNs) {
    try {
        Set-mailbox -Identity $upn -HiddenFromAddressListsEnabled $true
        Write-Host "Successfully hid $upn from the GAL." -ForegroundColor Green
    } catch {
        Write-Host "Failed to hide $upn from the GAL. Error: $_" -ForegroundColor Red
    }
}