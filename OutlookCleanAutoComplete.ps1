 If(Test-Path -Path 'C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE') {
            Start-Process -FilePath 'C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE' -ArgumentList '/cleanautocompletecache','/recycle'
        }

If(Test-Path -Path 'C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE') {
            Start-Process -FilePath 'C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE' -ArgumentList '/cleanautocompletecache','/recycle'
        }
