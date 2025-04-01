hook.Add( "InitPostEntity", "nss_clientloaded", function()
	net.Start( "nss_client" )
	net.SendToServer()
end )