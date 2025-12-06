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

/**
 * Get the proxied host IP address.
 *
 * @return {string}
 */
function get_proxied_host_ip(){
  return process.env.PROXIED_HOST_IP // 127.0.0.1 (for Ubuntu/macOS), 172.27.205.45 (for WSL2)
}

export default {
  read_server_name,
  get_server_name,
  get_proxied_host_ip,
}
