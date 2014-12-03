object fPersonal: TfPersonal
  Left = 193
  Top = 197
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Address and the way of delivery'
  ClientHeight = 526
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 106
  TextHeight = 14
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 436
    Height = 331
    Align = alClient
    Caption = 'Address'
    TabOrder = 0
    object lbKrajina: TLabel
      Left = 63
      Top = 269
      Width = 43
      Height = 14
      Alignment = taRightJustify
      Caption = 'Country'
      Enabled = False
    end
    object lbStat: TLabel
      Left = 76
      Top = 296
      Width = 30
      Height = 14
      Alignment = taRightJustify
      Caption = 'State'
      Visible = False
    end
    object edUlica: TLabeledEdit
      Left = 110
      Top = 184
      Width = 206
      Height = 22
      Color = clWhite
      EditLabel.Width = 35
      EditLabel.Height = 14
      EditLabel.Caption = 'Street'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 6
    end
    object edMesto: TLabeledEdit
      Left = 110
      Top = 211
      Width = 206
      Height = 22
      Color = clWhite
      EditLabel.Width = 20
      EditLabel.Height = 14
      EditLabel.Caption = 'City'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 7
    end
    object edPSC: TLabeledEdit
      Left = 110
      Top = 238
      Width = 76
      Height = 22
      Color = clWhite
      EditLabel.Width = 18
      EditLabel.Height = 14
      EditLabel.Caption = 'ZIP'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 10
      TabOrder = 8
    end
    object comKrajina: TComboBox
      Tag = -999
      Left = 110
      Top = 265
      Width = 230
      Height = 22
      Style = csDropDownList
      Color = 15132415
      DropDownCount = 25
      Enabled = False
      TabOrder = 9
      OnChange = UpdateData
      Items.Strings = (
        'Czech Republic ('#268'esko)'
        'Slovakia (Slovensko)'
        'Austria ('#214'sterreich)'
        'Germany (Deutschland)'
        'Poland (Polska)'
        'Hungary (Magyarorsz'#225'g)'
        '------------------------------------------------'
        'Afghanistan ('#1575#1601#1594#1575#1606#1587#1578#1575#1606')'
        'Aland Islands'
        'Albania (Shqip'#235'ria)'
        'Algeria ('#1575#1604#1580#1586#1575#1574#1585')'
        'American Samoa'
        'Andorra'
        'Angola'
        'Anguilla'
        'Antarctica'
        'Antigua and Barbuda'
        'Argentina'
        'Armenia'
        'Aruba'
        'Australia'
        'Austria ('#214'sterreich)'
        'Azerbaijan (Az'#601'rbaycan)'
        'Bahamas'
        'Bahrain ('#1575#1604#1576#1581#1585#1610#1606')'
        'Bangladesh'
        'Barbados'
        'Belarus ('#1041#1077#1083#1072#1088#1091#769#1089#1100')'
        'Belgium (Belgi'#235')'
        'Belize'
        'Benin (B'#233'nin)'
        'Bermuda'
        'Bhutan'
        'Bolivia'
        'Bosnia and Herzegovina (Bosna i Hercegovina)'
        'Botswana'
        'Bouvet Island'
        'Brazil (Brasil)'
        'British Indian Ocean Territory'
        'Brunei (Brunei Darussalam)'
        'Bulgaria ('#1041#1098#1083#1075#1072#1088#1080#1103')'
        'Burkina Faso'
        'Burundi (Uburundi)'
        'Cambodia (Kampuchea)'
        'Cameroon (Cameroun)'
        'Canada'
        'Cape Verde (Cabo Verde)'
        'Cayman Islands'
        'Central African Republic (R'#233'publique Centrafricaine)'
        'Chad (Tchad)'
        'Chile'
        'China ('#20013#22269')'
        'Christmas Island'
        'Cocos Islands'
        'Colombia'
        'Comoros (Comores)'
        'Congo'
        'Congo, Democratic Republic of the'
        'Cook Islands'
        'Costa Rica'
        'C'#244'te d'#39'Ivoire'
        'Croatia (Hrvatska)'
        'Cuba'
        'Cyprus ('#922#965#960#961#959#962')'
        'Czech Republic ('#268'esko)'
        'Denmark (Danmark)'
        'Djibouti'
        'Dominica'
        'Dominican Republic'
        'Ecuador'
        'Egypt ('#1605#1589#1585')'
        'El Salvador'
        'Equatorial Guinea (Guinea Ecuatorial)'
        'Eritrea (Ertra)'
        'Estonia (Eesti)'
        'Ethiopia (Ityop'#39'iya)'
        'Falkland Islands'
        'Faroe Islands'
        'Fiji'
        'Finland (Suomi)'
        'France'
        'French Guiana'
        'French Polynesia'
        'French Southern Territories'
        'Gabon'
        'Gambia'
        'Georgia ('#4321#4304#4325#4304#4320#4311#4309#4308#4314#4317')'
        'Germany (Deutschland)'
        'Ghana'
        'Gibraltar'
        'Greece ('#917#955#955#940#962')'
        'Greenland'
        'Grenada'
        'Guadeloupe'
        'Guam'
        'Guatemala'
        'Guernsey'
        'Guinea (Guin'#233'e)'
        'Guinea-Bissau (Guin'#233'-Bissau)'
        'Guyana'
        'Haiti (Ha'#239'ti)'
        'Heard Island and McDonald Islands'
        'Honduras'
        'Hong Kong'
        'Hungary (Magyarorsz'#225'g)'
        'Iceland ('#205'sland)'
        'India'
        'Indonesia'
        'Iran ('#1575#1740#1585#1575#1606')'
        'Iraq ('#1575#1604#1593#1585#1575#1602')'
        'Ireland'
        'Isle of Man'
        'Israel ('#1497#1513#1512#1488#1500')'
        'Italy (Italia)'
        'Jamaica'
        'Japan ('#26085#26412')'
        'Jersey'
        'Jordan ('#1575#1604#1575#1585#1583#1606')'
        'Kazakhstan ('#1178#1072#1079#1072#1179#1089#1090#1072#1085')'
        'Kenya'
        'Kiribati'
        'Kuwait ('#1575#1604#1603#1608#1610#1578')'
        'Kyrgyzstan ('#1050#1099#1088#1075#1099#1079#1089#1090#1072#1085')'
        'Laos ('#3737#3749#3762#3751')'
        'Latvia (Latvija)'
        'Lebanon ('#1604#1576#1606#1575#1606')'
        'Lesotho'
        'Liberia'
        'Libya ('#1604#1610#1576#1610#1575')'
        'Liechtenstein'
        'Lithuania (Lietuva)'
        'Luxembourg (L'#235'tzebuerg)'
        'Macao'
        'Macedonia ('#1052#1072#1082#1077#1076#1086#1085#1080#1112#1072')'
        'Madagascar (Madagasikara)'
        'Malawi'
        'Malaysia'
        'Maldives ('#1934#1962#1942#1965#1927#1968#1923#1959' '#1940#1959#1927#1968#1923#1960#1920#1963#1929#1968#1942')'
        'Mali'
        'Malta'
        'Marshall Islands'
        'Martinique'
        'Mauritania ('#1605#1608#1585#1610#1578#1575#1606#1610#1575')'
        'Mauritius'
        'Mayotte'
        'Mexico (M'#233'xico)'
        'Micronesia'
        'Moldova'
        'Monaco'
        'Mongolia ('#1052#1086#1085#1075#1086#1083' '#1059#1083#1089')'
        'Montenegro ('#1062#1088#1085#1072' '#1043#1086#1088#1072')'
        'Montserrat'
        'Morocco ('#1575#1604#1605#1594#1585#1576')'
        'Mozambique (Mo'#231'ambique)'
        'Myanmar (Burma)'
        'Namibia'
        'Nauru (Naoero)'
        'Nepal ('#2344#2375#2346#2366#2354')'
        'Netherlands (Nederland)'
        'Netherlands Antilles'
        'New Caledonia'
        'New Zealand'
        'Nicaragua'
        'Niger'
        'Nigeria'
        'Niue'
        'Norfolk Island'
        'Northern Mariana Islands'
        'North Korea ('#51312#49440')'
        'Norway (Norge)'
        'Oman ('#1593#1605#1575#1606')'
        'Pakistan ('#1662#1575#1705#1587#1578#1575#1606')'
        'Palau (Belau)'
        'Palestinian Territories'
        'Panama (Panam'#225')'
        'Papua New Guinea'
        'Paraguay'
        'Peru (Per'#250')'
        'Philippines (Pilipinas)'
        'Pitcairn'
        'Poland (Polska)'
        'Portugal'
        'Puerto Rico'
        'Qatar ('#1602#1591#1585')'
        'Reunion'
        'Romania (Rom'#226'nia)'
        'Russia ('#1056#1086#1089#1089#1080#1103')'
        'Rwanda'
        'Saint Helena'
        'Saint Kitts and Nevis'
        'Saint Lucia'
        'Saint Pierre and Miquelon'
        'Saint Vincent and the Grenadines'
        'Samoa'
        'San Marino'
        'S'#227'o Tom'#233' and Pr'#237'ncipe'
        'Saudi Arabia ('#1575#1604#1605#1605#1604#1603#1577' '#1575#1604#1593#1585#1576#1610#1577' '#1575#1604#1587#1593#1608#1583#1610#1577')'
        'Senegal (S'#233'n'#233'gal)'
        'Serbia ('#1057#1088#1073#1080#1112#1072')'
        'Serbia and Montenegro ('#1057#1088#1073#1080#1112#1072' '#1080' '#1062#1088#1085#1072' '#1043#1086#1088#1072')'
        'Seychelles'
        'Sierra Leone'
        'Singapore (Singapura)'
        'Slovakia (Slovensko)'
        'Slovenia (Slovenija)'
        'Solomon Islands'
        'Somalia (Soomaaliya)'
        'South Africa'
        'South Georgia and the South Sandwich Islands'
        'South Korea ('#54620#44397')'
        'Spain (Espa'#241'a)'
        'Sri Lanka'
        'Sudan ('#1575#1604#1587#1608#1583#1575#1606')'
        'Suriname'
        'Svalbard and Jan Mayen'
        'Swaziland'
        'Sweden (Sverige)'
        'Switzerland (Schweiz)'
        'Syria ('#1587#1608#1585#1610#1575')'
        'Taiwan ('#21488#28771')'
        'Tajikistan ('#1058#1086#1207#1080#1082#1080#1089#1090#1086#1085')'
        'Tanzania'
        'Thailand ('#3619#3634#3594#3629#3634#3603#3634#3592#3633#3585#3619#3652#3607#3618')'
        'Timor-Leste'
        'Togo'
        'Tokelau'
        'Tonga'
        'Trinidad and Tobago'
        'Tunisia ('#1578#1608#1606#1587')'
        'Turkey (T'#252'rkiye)'
        'Turkmenistan (T'#252'rkmenistan)'
        'Turks and Caicos Islands'
        'Tuvalu'
        'Uganda'
        'Ukraine ('#1059#1082#1088#1072#1111#1085#1072')'
        'United Arab Emirates ('#1575#1604#1573#1605#1575#1585#1575#1578' '#1575#1604#1593#1585#1576#1610#1617#1577' '#1575#1604#1605#1578#1617#1581#1583#1577')'
        'United Kingdom'
        'United States of America'
        'United States minor outlying islands'
        'Uruguay'
        'Uzbekistan (O'#39'zbekiston)'
        'Vanuatu'
        'Vatican City (Citt'#224' del Vaticano)'
        'Venezuela'
        'Vietnam (Vi'#7879't Nam)'
        'Virgin Islands, British'
        'Virgin Islands, U.S.'
        'Wallis and Futuna'
        'Western Sahara ('#1575#1604#1589#1581#1585#1575#1569' '#1575#1604#1594#1585#1576#1610#1577')'
        'Yemen ('#1575#1604#1610#1605#1606')'
        'Zambia'
        'Zimbabwe')
    end
    object comStat: TComboBox
      Tag = -999
      Left = 110
      Top = 292
      Width = 230
      Height = 22
      Style = csDropDownList
      Color = 15132415
      DropDownCount = 25
      TabOrder = 11
      Visible = False
      OnChange = UpdateData
      Items.Strings = (
        'Alabama'
        'Alaska'
        'Arizona'
        'Arkansas'
        'California'
        'Colorado'
        'Connecticut'
        'Delaware'
        'Florida'
        'Georgia'
        'Hawai'
        'Idaho'
        'Illinois'
        'Indiana'
        'Iowa'
        'Kansas'
        'Kentucky'
        'Louisiana'
        'Maine'
        'Maryland'
        'Massachusetts'
        'Michigan'
        'Minnesota'
        'Missippi'
        'Missouri'
        'Montana'
        'Nebraska'
        'Nevada'
        'New Hampshire'
        'New Jersey'
        'New Mexico'
        'New York'
        'North Carolina'
        'North Dakota'
        'Ohio'
        'Oklahoma'
        'Oregon'
        'Pennsylvania'
        'Rhode Island'
        'South Carolina'
        'South Dakota'
        'Tennessee'
        'Texas'
        'Utah'
        'Vermont'
        'Virginia'
        'Washington'
        'West Virginia'
        'Wisconsin'
        'Wyoming')
    end
    object comKrajinaValue: TComboBox
      Tag = -999
      Left = 350
      Top = 265
      Width = 55
      Height = 22
      Style = csDropDownList
      Color = clYellow
      TabOrder = 10
      Visible = False
      Items.Strings = (
        'CZ'
        'SK'
        'AT'
        'DE'
        'PL'
        'HU'
        ''
        'AF'
        'AX'
        'AL'
        'DZ'
        'AS'
        'AD'
        'AO'
        'AI'
        'AQ'
        'AG'
        'AR'
        'AM'
        'AW'
        'AU'
        'AT'
        'AZ'
        'BS'
        'BH'
        'BD'
        'BB'
        'BY'
        'BE'
        'BZ'
        'BJ'
        'BM'
        'BT'
        'BO'
        'BA'
        'BW'
        'BV'
        'BR'
        'IO'
        'BN'
        'BG'
        'BF'
        'BI'
        'KH'
        'CM'
        'CA'
        'CV'
        'KY'
        'CF'
        'TD'
        'CL'
        'CN'
        'CX'
        'CC'
        'CO'
        'KM'
        'CG'
        'CD'
        'CK'
        'CR'
        'CI'
        'HR'
        'CU'
        'CY'
        'CZ'
        'DK'
        'DJ'
        'DM'
        'DO'
        'EC'
        'EG'
        'SV'
        'GQ'
        'ER'
        'EE'
        'ET'
        'FK'
        'FO'
        'FJ'
        'FI'
        'FR'
        'GF'
        'PF'
        'TF'
        'GA'
        'GM'
        'GE'
        'DE'
        'GH'
        'GI'
        'GR'
        'GL'
        'GD'
        'GP'
        'GU'
        'GT'
        'GG'
        'GN'
        'GW'
        'GY'
        'HT'
        'HM'
        'HN'
        'HK'
        'HU'
        'IS'
        'IN'
        'ID'
        'IR'
        'IQ'
        'IE'
        'IM'
        'IL'
        'IT'
        'JM'
        'JP'
        'JE'
        'JO'
        'KZ'
        'KE'
        'KI'
        'KW'
        'KG'
        'LA'
        'LV'
        'LB'
        'LS'
        'LR'
        'LY'
        'LI'
        'LT'
        'LU'
        'MO'
        'MK'
        'MG'
        'MW'
        'MY'
        'MV'
        'ML'
        'MT'
        'MH'
        'MQ'
        'MR'
        'MU'
        'YT'
        'MX'
        'FM'
        'MD'
        'MC'
        'MN'
        'ME'
        'MS'
        'MA'
        'MZ'
        'MM'
        'NA'
        'NR'
        'NP'
        'NL'
        'AN'
        'NC'
        'NZ'
        'NI'
        'NE'
        'NG'
        'NU'
        'NF'
        'MP'
        'KP'
        'NO'
        'OM'
        'PK'
        'PW'
        'PS'
        'PA'
        'PG'
        'PY'
        'PE'
        'PH'
        'PN'
        'PL'
        'PT'
        'PR'
        'QA'
        'RE'
        'RO'
        'RU'
        'RW'
        'SH'
        'KN'
        'LC'
        'PM'
        'VC'
        'WS'
        'SM'
        'ST'
        'SA'
        'SN'
        'RS'
        'CS'
        'SC'
        'SL'
        'SG'
        'SK'
        'SI'
        'SB'
        'SO'
        'ZA'
        'GS'
        'KR'
        'ES'
        'LK'
        'SD'
        'SR'
        'SJ'
        'SZ'
        'SE'
        'CH'
        'SY'
        'TW'
        'TJ'
        'TZ'
        'TH'
        'TL'
        'TG'
        'TK'
        'TO'
        'TT'
        'TN'
        'TR'
        'TM'
        'TC'
        'TV'
        'UG'
        'UA'
        'AE'
        'GB'
        'US'
        'UM'
        'UY'
        'UZ'
        'VU'
        'VA'
        'VE'
        'VN'
        'VG'
        'VI'
        'WF'
        'EH'
        'YE'
        'ZM'
        'ZW')
    end
    object comStatValue: TComboBox
      Tag = -999
      Left = 350
      Top = 292
      Width = 55
      Height = 22
      Style = csDropDownList
      Color = clYellow
      TabOrder = 12
      Visible = False
      Items.Strings = (
        'AL'
        'AK'
        'AZ'
        'AR'
        'CA'
        'CO'
        'CT'
        'DE'
        'FL'
        'GA'
        'HI'
        'ID'
        'IL'
        'IN'
        'IA'
        'KS'
        'KY'
        'LA'
        'ME'
        'MD'
        'MA'
        'MI'
        'MN'
        'MS'
        'MO'
        'MT'
        'NE'
        'NV'
        'NH'
        'NJ'
        'NM'
        'NY'
        'NC'
        'ND'
        'OH'
        'OK'
        'OR'
        'PA'
        'RI'
        'SC'
        'SD'
        'TN'
        'TX'
        'UT'
        'VT'
        'VA'
        'WA'
        'WV'
        'WI'
        'WY')
    end
    object edMeno: TLabeledEdit
      Left = 110
      Top = 103
      Width = 206
      Height = 22
      Color = clWhite
      EditLabel.Width = 56
      EditLabel.Height = 14
      EditLabel.Caption = 'First name'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 3
    end
    object edPriezvisko: TLabeledEdit
      Left = 110
      Top = 130
      Width = 206
      Height = 22
      Color = clWhite
      EditLabel.Width = 56
      EditLabel.Height = 14
      EditLabel.Caption = 'Last name'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 4
    end
    object edFirma: TLabeledEdit
      Left = 110
      Top = 157
      Width = 206
      Height = 22
      Color = clWhite
      EditLabel.Width = 50
      EditLabel.Height = 14
      EditLabel.Caption = 'Company'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 5
    end
    object comDeliveryAddress: TRadioButton
      Left = 23
      Top = 29
      Width = 400
      Height = 17
      Caption = 'Send to delivery address I have entered in registration'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = comboAddressesClick
    end
    object comBillingAddress: TRadioButton
      Left = 23
      Top = 52
      Width = 400
      Height = 17
      Caption = 'Send to billing address I have entered in registration'
      TabOrder = 1
      OnClick = comboAddressesClick
    end
    object comOtherAddress: TRadioButton
      Left = 23
      Top = 75
      Width = 400
      Height = 17
      Caption = 'Send to other address'
      TabOrder = 2
      OnClick = comboAddressesClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 331
    Width = 436
    Height = 139
    Align = alBottom
    Caption = 'Shipping details'
    TabOrder = 1
    object Label2: TLabel
      Left = 58
      Top = 65
      Width = 46
      Height = 14
      Alignment = taRightJustify
      Caption = 'Shipping'
    end
    object Label3: TLabel
      Left = 67
      Top = 92
      Width = 37
      Height = 14
      Alignment = taRightJustify
      Caption = 'Priority'
    end
    object Label1: TLabel
      Left = 13
      Top = 38
      Width = 91
      Height = 14
      Alignment = taRightJustify
      Caption = 'Way of payment'
    end
    object comDelivery: TComboBox
      Left = 110
      Top = 60
      Width = 194
      Height = 22
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'DPD parcel service'
      Items.Strings = (
        'DPD parcel service')
    end
    object comPriority: TComboBox
      Left = 110
      Top = 87
      Width = 194
      Height = 22
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'Standard'
      Items.Strings = (
        'Standard')
    end
    object comPaymentMethod: TComboBox
      Left = 110
      Top = 33
      Width = 194
      Height = 22
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Pro forma invoice'
      Items.Strings = (
        'Pro forma invoice')
    end
    object comPaymentMethodValue: TComboBox
      Tag = -999
      Left = 307
      Top = 33
      Width = 70
      Height = 22
      Style = csDropDownList
      Color = clYellow
      ItemIndex = 0
      TabOrder = 3
      Text = 'PREDF'
      Visible = False
      Items.Strings = (
        'PREDF')
    end
    object comDeliveryValue: TComboBox
      Tag = -999
      Left = 307
      Top = 60
      Width = 70
      Height = 22
      Style = csDropDownList
      Color = clYellow
      ItemIndex = 0
      TabOrder = 4
      Text = 'DPD'
      Visible = False
      Items.Strings = (
        'DPD')
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 470
    Width = 436
    Height = 56
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      436
      56)
    object btnSadPersonal: TSpeedButton
      Left = 318
      Top = 14
      Width = 27
      Height = 27
      Hint = 'I haven'#39't found what I needed...'
      Anchors = [akTop, akRight]
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadPersonalClick
    end
    object btnOK: TBitBtn
      Left = 350
      Top = 6
      Width = 65
      Height = 44
      ModalResult = 1
      TabOrder = 0
    end
  end
end
