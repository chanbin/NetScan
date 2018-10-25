#usage1 .\portscanner.ps1 [ip or domain] multi port port
#usage2 .\portscanner.ps1 [ip or domain] port
#put our arguments into their respective variables
$device = $args[0]
$port = $args[1]
$start = $args[2]
$stop = $args[3]

#function pingdevice
#ping the device to see if it is on the network
function pingdevice{
    if(test-connection $device -ErrorAction SilentlyContinue){
        Write-Output "$device is up"
    }else{
        Write-Output "$device is down"
        exit
    }
}

#function checkports
#check to see if our ports are open
function checkports{
    if($port -match "multi"){#this branch checks a port range
        Write-Output "testing port on $device"
        for($counter=$start; $counter -le $stop; $counter++){
            #Write-Output "testing port $counter on $device"
            $porttest = new-object Net.Sockets.TcpClient
            $connect = $porttest.BeginConnect($device, $counter, $null, $null)
            $wait = $connect.AsyncWaitHandle.WaitOne(1000,$false)
            if(!$wait){
                Write-Output "$counter is closed"
            }else{
                $Error.clear()
                $porttest.EndConnect($connect)| Out-Null
                if($Error[0]){
                    Write-Warning ("{0}" -f $Error[0].Exception.Message)
                }else{
                    Write-Output "$counter is open"
                }
            }
 
            #try{
            #    $connect = $porttest.Connect($device,$counter)
            #    Write-Output "$counter is open"
            #}catch{
            #    Write-Output "$counter is closed"
            #}
            #$porttest.Close();
        }
    }else{ #this branch checks a single port
        #Write-Output "testing port $port on $device"
        Write-Output "testing port on $device"
        #$porttest = new-object Net.Sockets.TcpClient
        #$connect = $porttest.BeginConnect($device, $counter, $null, $null)
        #$wait = $connect.AsyncWaitHandle.WaitOne(1000,$false)
        #if(!$wait){
        #    Write-Output "$counter is closed"
        #}else{
        #    $Error.clear()
        #    $porttest.EndConnect($connect)| Out-Null
        #    if($Error[0]){
        #        Write-Warning ("{0}" -f $Error[0].Exception.Message)
        #    }else{
        #        Write-Output "$counter is open"
        #    }
        #}
        $porttest = New-Object Net.Sockets.TcpClient
        $porttest.SendTimeout = 1000;
        $porttest.ReceiveTimeout = 1000;
        try{
            $connect = $porttest.Connect($device,$port)
            Write-Output "$port is open"
        }catch{
            Write-Output "$port is closed"
        }
        $porttest.Close();
    }
}

#run our functions
pingdevice
checkports