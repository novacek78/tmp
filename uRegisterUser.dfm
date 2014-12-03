object fRegisterUser: TfRegisterUser
  Left = 200
  Top = 145
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Registration of new user'
  ClientHeight = 619
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gb2: TGroupBox
    Left = 0
    Top = 0
    Width = 518
    Height = 377
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Billing and shipping address'
    TabOrder = 0
    object Label1: TLabel
      Left = 74
      Top = 22
      Width = 67
      Height = 13
      Caption = 'Billing address'
    end
    object Label3: TLabel
      Left = 32
      Top = 170
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Country'
    end
    object Shape4: TShape
      Left = 231
      Top = 90
      Width = 6
      Height = 21
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object Shape5: TShape
      Left = 151
      Top = 141
      Width = 6
      Height = 21
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object Shape6: TShape
      Left = 231
      Top = 116
      Width = 6
      Height = 21
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object Shape7: TShape
      Left = 243
      Top = 166
      Width = 6
      Height = 21
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object lbStat: TLabel
      Left = 45
      Top = 195
      Width = 26
      Height = 13
      Alignment = taRightJustify
      Caption = 'State'
      Visible = False
    end
    object shapeStat: TShape
      Left = 243
      Top = 192
      Width = 6
      Height = 21
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
      Visible = False
    end
    object lbKrajina2: TLabel
      Left = 278
      Top = 198
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Country'
      Enabled = False
    end
    object lbStat2: TLabel
      Left = 291
      Top = 223
      Width = 26
      Height = 13
      Alignment = taRightJustify
      Caption = 'State'
      Enabled = False
      Visible = False
    end
    object Shape9: TShape
      Left = 231
      Top = 65
      Width = 6
      Height = 20
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object Shape10: TShape
      Left = 231
      Top = 40
      Width = 6
      Height = 20
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object Shape3: TShape
      Left = 298
      Top = 320
      Width = 6
      Height = 21
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object edPSC2: TLabeledEdit
      Left = 320
      Top = 166
      Width = 77
      Height = 21
      Color = clWhite
      EditLabel.Width = 16
      EditLabel.Height = 13
      EditLabel.Caption = 'ZIP'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 10
      TabOrder = 19
    end
    object edMesto2: TLabeledEdit
      Left = 320
      Top = 141
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = 'City'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 18
    end
    object edUlica2: TLabeledEdit
      Left = 320
      Top = 116
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Street'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 17
    end
    object cbDeliverToBillingAddress: TCheckBox
      Left = 320
      Top = 21
      Width = 217
      Height = 17
      Caption = 'Deliver to billing address'
      Checked = True
      State = cbChecked
      TabOrder = 13
      OnClick = cbDeliverToBillingAddressClick
    end
    object edUlica: TLabeledEdit
      Left = 74
      Top = 90
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Street'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 2
      OnChange = CheckData
    end
    object edMesto: TLabeledEdit
      Left = 74
      Top = 116
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = 'City'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 3
      OnChange = CheckData
    end
    object edPSC: TLabeledEdit
      Left = 74
      Top = 141
      Width = 76
      Height = 21
      Color = clWhite
      EditLabel.Width = 16
      EditLabel.Height = 13
      EditLabel.Caption = 'ZIP'
      LabelPosition = lpLeft
      MaxLength = 10
      TabOrder = 4
      OnChange = CheckData
    end
    object comKrajina: TComboBox
      Tag = -999
      Left = 74
      Top = 166
      Width = 167
      Height = 21
      Style = csDropDownList
      Color = 15132415
      DropDownCount = 25
      TabOrder = 5
      OnChange = CheckData
      Items.Strings = (
        'Slovakia (Slovensko)'
        'Czech Republic ('#268'esko)'
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
    object comKrajinaValue: TComboBox
      Tag = -999
      Left = 320
      Top = 262
      Width = 51
      Height = 21
      Style = csDropDownList
      Color = clYellow
      TabOrder = 22
      Visible = False
      Items.Strings = (
        'SK'
        'CZ'
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
    object comStat: TComboBox
      Tag = -999
      Left = 74
      Top = 191
      Width = 167
      Height = 21
      Style = csDropDownList
      Color = 15132415
      DropDownCount = 25
      TabOrder = 6
      Visible = False
      OnChange = CheckData
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
    object comStatValue: TComboBox
      Tag = -999
      Left = 320
      Top = 287
      Width = 51
      Height = 21
      Style = csDropDownList
      Color = clYellow
      TabOrder = 23
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
    object comKrajina2: TComboBox
      Tag = -999
      Left = 320
      Top = 192
      Width = 168
      Height = 21
      Style = csDropDownList
      Color = 15132415
      DropDownCount = 25
      Enabled = False
      TabOrder = 20
      OnChange = CheckData
      Items.Strings = (
        'Slovakia (Slovensko)'
        'Czech Republic ('#268'esko)'
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
    object comStat2: TComboBox
      Tag = -999
      Left = 320
      Top = 217
      Width = 168
      Height = 21
      Style = csDropDownList
      Color = 15132415
      DropDownCount = 25
      Enabled = False
      TabOrder = 21
      Visible = False
      OnChange = CheckData
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
    object edMeno2: TLabeledEdit
      Left = 320
      Top = 40
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'First name'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 14
      OnChange = CheckData
    end
    object edPriezvisko2: TLabeledEdit
      Left = 320
      Top = 65
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 49
      EditLabel.Height = 13
      EditLabel.Caption = 'Last name'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 15
      OnChange = CheckData
    end
    object edFirma2: TLabeledEdit
      Left = 320
      Top = 90
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 45
      EditLabel.Height = 13
      EditLabel.Caption = 'Company'
      Enabled = False
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 16
    end
    object edMeno: TLabeledEdit
      Left = 74
      Top = 40
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'First name'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 0
      OnChange = CheckData
    end
    object edPriezvisko: TLabeledEdit
      Left = 74
      Top = 65
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 49
      EditLabel.Height = 13
      EditLabel.Caption = 'Last name'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 1
      OnChange = CheckData
    end
    object edFirma: TLabeledEdit
      Left = 74
      Top = 217
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 45
      EditLabel.Height = 13
      EditLabel.Caption = 'Company'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 7
    end
    object edICO: TLabeledEdit
      Left = 74
      Top = 243
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 42
      EditLabel.Height = 13
      EditLabel.Caption = 'Comp.ID'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 8
    end
    object edDIC: TLabeledEdit
      Left = 74
      Top = 269
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 33
      EditLabel.Height = 13
      EditLabel.Caption = 'VAT ID'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 9
    end
    object edEmail: TLabeledEdit
      Left = 74
      Top = 320
      Width = 222
      Height = 21
      Color = clWhite
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'E-mail'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 11
      OnChange = CheckData
    end
    object edTel: TLabeledEdit
      Left = 74
      Top = 345
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'Telephone'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 12
    end
    object edICDPH: TLabeledEdit
      Tag = -999
      Left = 74
      Top = 295
      Width = 156
      Height = 21
      Color = clWhite
      EditLabel.Width = 34
      EditLabel.Height = 13
      EditLabel.Caption = 'I'#268' DPH'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 10
      Visible = False
    end
  end
  object gb3: TGroupBox
    Left = 0
    Top = 377
    Width = 518
    Height = 185
    Align = alClient
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Legal notice'
    TabOrder = 1
    object Memo1: TMemo
      Left = 74
      Top = 20
      Width = 414
      Height = 131
      TabStop = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object cbPersonalAgree: TCheckBox
      Left = 74
      Top = 157
      Width = 414
      Height = 17
      Caption = 'I agree with storing my personal data'
      TabOrder = 1
      OnClick = CheckData
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 562
    Width = 518
    Height = 57
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    DesignSize = (
      518
      57)
    object Label2: TLabel
      Left = 19
      Top = 34
      Width = 160
      Height = 13
      Caption = 'Red-marked fields are mandatory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnSad: TSpeedButton
      Left = 320
      Top = 13
      Width = 25
      Height = 25
      Hint = 'I haven'#39't found what I needed...'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadClick
    end
    object Shape8: TShape
      Left = 7
      Top = 30
      Width = 6
      Height = 20
      Hint = 'Red-marked fields are mandatory'
      Brush.Color = clRed
      ParentShowHint = False
      Pen.Color = clRed
      Pen.Width = 2
      Shape = stSquare
      ShowHint = True
    end
    object btnSend: TBitBtn
      Left = 438
      Top = 9
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Enabled = False
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnSendClick
    end
    object btnCancel: TBitBtn
      Left = 373
      Top = 9
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Cancel = True
      ModalResult = 2
      TabOrder = 1
    end
  end
end
