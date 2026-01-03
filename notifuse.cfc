component displayname="notifuse.cfc" output="false" accessors="true" { 
 	
	variables._notifusecfc_version = '0.1.0';

	public any function init(
		string apiKey = '',
		string baseUrl = "https://demo.notifuse.com",
		numeric httpTimeout = 50,
		boolean includeRaw = false ) {

		structAppend( variables, arguments );

		//map sensitive args to env variables or java system props
		var secrets = {
			'apiKey': 'SENDGRID_API_KEY',
			};
		var system = createObject( 'java', 'java.lang.System' );

		for ( var key in secrets ) {
			//arguments are top priority
			if ( variables[ key ].len() ) continue;

			//check environment variables
			var envValue = system.getenv( secrets[ key ] );
			if ( !isNull( envValue ) && envValue.len() ) {
				variables[ key ] = envValue;
				continue;
			}

			//check java system properties
			var propValue = system.getProperty( secrets[ key ] );
			if ( !isNull( propValue ) && propValue.len() ) {
				variables[ key ] = propValue;
			}
		}

		variables.utcBaseDate = dateAdd( "l", createDate( 1970,1,1 ).getTime() * -1, createDate( 1970,1,1 ) );

		return this;
  	}


	

	// /transactional

	// /transactional.send
	public struct function transactionalSend( required string workspace_id, required string id, required struct contact, array channels = ['email'] ) {
        var params = {};

        params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'notification' ] = {};
		params.notification[ 'id' ] = arguments.id;

		params.notification[ 'contact' ] = {};
		params.notification.contact[ 'email' ] = arguments.contact.email;

		params.notification[ 'channels' ] = arguments.channels;

        // structAppend( results, postAPI( 'transactional', 'send', options ) );

        // return results;
		return apiCall( 'POST', '/transactional.send', {}, params, {} );
    }

	// /contacts

	// /contacts.list
	public struct function contactsList( required string workspace_id, string email, string external_id, string first_name, string last_name, string full_name, string phone, string country, string language, string list_id, string contact_list_status, array segments, boolean with_contact_lists = false,  numeric limit = 20, string cursor ) {
		var params = {};

		params[ 'workspace_id' ] = arguments.workspace_id;

		if ( len( arguments.email ) ) {
			params[ 'email' ] = arguments.email;
		}
		if ( len( arguments.external_id ) ) {
			params[ 'external_id' ] = arguments.external_id;
		}
        if ( len( arguments.first_name ) ) {
            params[ 'first_name' ] = arguments.first_name;
        }
        if ( len( arguments.last_name ) ) {
            params[ 'last_name' ] = arguments.last_name;
        }
        if ( len( arguments.full_name ) ) {
            params[ 'full_name' ] = arguments.full_name;
        }
		if ( len( arguments.phone ) ) {
			params[ 'phone' ] = arguments.phone;
		}
		if ( len( arguments.country ) ) {
			params[ 'country' ] = arguments.country;
		}
		if ( len( arguments.language ) ) {
			params[ 'language' ] = arguments.language;
		}
		if ( len( arguments.list_id ) ) {
			params[ 'list_id' ] = arguments.list_id;
		}
		
		if ( listFindNoCase( 'active,pending,unsubscribed,bounced,complained', arguments.contact_list_status ) ) {
			params[ 'contact_list_status' ] = arguments.contact_list_status;
		}

		if ( len( arguments.segments ) ) {
			params[ 'segments' ] = arguments.segments;
		}
		params[ 'with_contact_lists' ] = arguments.with_contact_lists;

		params[ 'limit' ] = arguments.limit;
		if ( len( arguments.cursor ) ) {
			params[ 'cursor' ] = arguments.cursor;
		}


		return apiCall( 'GET', '/contacts.list', params, {}, {} );
	}

	// /contacts.count
	public struct function contactsCount( required string workspace_id ) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;

		return apiCall( 'GET', '/contacts.count', params, {}, {} );
	}

	// /contacts.upsert
	public struct function contactsUpsert( required string workspace_id, required struct contact ) {
        var params = {};

        params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'contact' ] = {};

		// Required field
		params.contact[ 'email' ] = arguments.contact.email;

		// Optional string fields
		if ( arguments.contact.keyExists( 'external_id' ) ) params.contact[ 'external_id' ] = arguments.contact.external_id;
		if ( arguments.contact.keyExists( 'timezone' ) ) params.contact[ 'timezone' ] = arguments.contact.timezone;
		if ( arguments.contact.keyExists( 'language' ) ) params.contact[ 'language' ] = arguments.contact.language;
		if ( arguments.contact.keyExists( 'first_name' ) ) params.contact[ 'first_name' ] = arguments.contact.first_name;
		if ( arguments.contact.keyExists( 'last_name' ) ) params.contact[ 'last_name' ] = arguments.contact.last_name;
		if ( arguments.contact.keyExists( 'full_name' ) ) params.contact[ 'full_name' ] = arguments.contact.full_name;
		if ( arguments.contact.keyExists( 'phone' ) ) params.contact[ 'phone' ] = arguments.contact.phone;
		if ( arguments.contact.keyExists( 'address_line_1' ) ) params.contact[ 'address_line_1' ] = arguments.contact.address_line_1;
		if ( arguments.contact.keyExists( 'address_line_2' ) ) params.contact[ 'address_line_2' ] = arguments.contact.address_line_2;
		if ( arguments.contact.keyExists( 'country' ) ) params.contact[ 'country' ] = arguments.contact.country;
		if ( arguments.contact.keyExists( 'postcode' ) ) params.contact[ 'postcode' ] = arguments.contact.postcode;
		if ( arguments.contact.keyExists( 'state' ) ) params.contact[ 'state' ] = arguments.contact.state;
		if ( arguments.contact.keyExists( 'job_title' ) ) params.contact[ 'job_title' ] = arguments.contact.job_title;

		// Custom string fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_string_#i#' ) ) params.contact[ 'custom_string_#i#' ] = arguments.contact[ 'custom_string_#i#' ];
		}

		// Custom number fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_number_#i#' ) ) params.contact[ 'custom_number_#i#' ] = arguments.contact[ 'custom_number_#i#' ];
		}

		// Custom datetime fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_datetime_#i#' ) ) params.contact[ 'custom_datetime_#i#' ] = arguments.contact[ 'custom_datetime_#i#' ];
		}

		// Custom JSON fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_json_#i#' ) ) params.contact[ 'custom_json_#i#' ] = arguments.contact[ 'custom_json_#i#' ];
		}

        // structAppend( results, postAPI( 'contacts', 'upsert', options ) );
		return apiCall( 'POST', '/contacts.upsert', {}, params, {} );
    }


	private struct function apiCall(
		required string httpMethod,
		required string path,
		struct queryParams = { },
		any body = '',
		struct headers = { } )  {

		var fullApiPath = variables.baseUrl & '/api' & path;
		var requestHeaders = getBaseHttpHeaders();
		requestHeaders.append( headers, true );

		var requestStart = getTickCount();
		var apiResponse = makeHttpRequest( httpMethod = httpMethod, path = fullApiPath, queryParams = queryParams, headers = requestHeaders, body = body );

		// writedump( var=apiResponse, label="API Response" );
		// abort;
		var result = {
		'responseTime' = getTickCount() - requestStart,
		'statusCode' = listFirst( apiResponse.statuscode, " " ),
		'statusText' = listRest( apiResponse.statuscode, " " )
		};

		var deserializedFileContent = {};

		if ( isJson( apiResponse.fileContent ) )
		deserializedFileContent = deserializeJSON( apiResponse.fileContent );

		//needs to be cusomtized by API integration for how errors are returned
		if ( result.statusCode >= 400 ) {
		if ( isStruct( deserializedFileContent ) )
			result.append( deserializedFileContent );
		}

		//stored in data, because some responses are arrays and others are structs
		result[ 'data' ] = deserializedFileContent;

		if ( variables.includeRaw ) {
		result[ 'raw' ] = {
			'method' : ucase( httpMethod ),
			'path' : fullApiPath,
			'params' : serializeJSON( queryParams ),
			'response' : apiResponse.fileContent,
			'responseHeaders' : apiResponse.responseheader
		};
		}

		return result;
  }

  private struct function getBaseHttpHeaders() {
    return {
      'Accept' : 'application/json',
      'Content-Type' : 'application/json',
      'User-Agent' : 'notifuse.cfc/#variables._notifusecfc_version# (ColdFusion)',
      'Authorization' : 'Bearer #variables.apiKey#'
    };
  }

  private any function makeHttpRequest(
    required string httpMethod,
    required string path,
    struct queryParams = { },
    struct headers = { },
    any body = ''
  ) {
    var result = '';

    var fullPath = path & ( !queryParams.isEmpty()
      ? ( '?' & parseQueryParams( queryParams, false ) )
      : '' );

    var requestHeaders = parseHeaders( headers );
    var requestBody = parseBody( body );

    cfhttp( url = fullPath, method = httpMethod, result = 'result', timeout = variables.httpTimeout ) {

      for ( var header in requestHeaders ) {
        cfhttpparam( type = "header", name = header.name, value = header.value );
      }

      if ( arrayFindNoCase( [ 'POST','PUT','PATCH','DELETE' ], httpMethod ) && isJSON( requestBody ) )
        cfhttpparam( type = "body", value = requestBody );

    }
    return result;
  }

  /**
  * @hint convert the headers from a struct to an array
  */
  private array function parseHeaders( required struct headers ) {
    var sortedKeyArray = headers.keyArray();
    sortedKeyArray.sort( 'textnocase' );
    var processedHeaders = sortedKeyArray.map(
      function( key ) {
        return { name: key, value: trim( headers[ key ] ) };
      }
    );
    return processedHeaders;
  }

  /**
  * @hint converts the queryparam struct to a string, with optional encoding and the possibility for empty values being pass through as well
  */
  private string function parseQueryParams( required struct queryParams, boolean encodeQueryParams = true, boolean includeEmptyValues = true ) {
    var sortedKeyArray = queryParams.keyArray();
    sortedKeyArray.sort( 'text' );

    var queryString = sortedKeyArray.reduce(
      function( queryString, queryParamKey ) {
        var encodedKey = encodeQueryParams
          ? encodeUrl( queryParamKey )
          : queryParamKey;
        if ( !isArray( queryParams[ queryParamKey ] ) ) {
          var encodedValue = encodeQueryParams && len( queryParams[ queryParamKey ] )
            ? encodeUrl( queryParams[ queryParamKey ] )
            : queryParams[ queryParamKey ];
        } else {
          var encodedValue = encodeQueryParams && ArrayLen( queryParams[ queryParamKey ] )
            ?  encodeUrl( serializeJSON( queryParams[ queryParamKey ] ) )
            : queryParams[ queryParamKey ].toList();
          }
        return queryString.listAppend( encodedKey & ( includeEmptyValues || len( encodedValue ) ? ( '=' & encodedValue ) : '' ), '&' );
      }, ''
    );

    return queryString.len() ? queryString : '';
  }

  private string function parseBody( required any body ) {
    if ( isStruct( body ) || isArray( body ) )
      return serializeJson( body );
    else if ( isJson( body ) )
      return body;
    else
      return '';
  }

  private struct function parseSubUser( string on_behalf_of = '' ){
    if( len( on_behalf_of ) ){
      return { 'on-behalf-of': on_behalf_of };
    } else {
      return {}
    }
  }

  private string function encodeUrl( required string str, boolean encodeSlash = true ) {
    var result = replacelist( urlEncodedFormat( str, 'utf-8' ), '%2D,%2E,%5F,%7E', '-,.,_,~' );
    if ( !encodeSlash ) result = replace( result, '%2F', '/', 'all' );

    return result;
  }

  private numeric function returnUnixTimestamp( required any dateToConvert ) {
    return dateDiff( "s", variables.utcBaseDate, dateToConvert );
  }

}
