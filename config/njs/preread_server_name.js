let server_name = '-';

/**
 * Read the server name from the HTTP stream.
 */
function read_server_name( stream ){
	stream.on( 'upload', function( data, flags ){
		if( data.length || flags.last ){
			stream.done();
		}

		// Get "Host". Without port (:)
		let match = data.match( /\r?\nHost: ([^\r\n:]+)/ );
		if( match ){
			server_name = match[1];
		}
	} );
}

function get_server_name( stream ){
	return server_name
}

export default { read_server_name, get_server_name }
