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
	public struct function transactionalSend(
		required string workspace_id,
		required string id,
		required struct contact,
		array channels = ['email'],
		string external_id,
		struct data,
		struct metadata,
		struct email_options
	) {
        var params = {};

        params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'notification' ] = {};
		params.notification[ 'id' ] = arguments.id;

		// Contact object - required email field
		params.notification[ 'contact' ] = {};
		params.notification[ 'contact' ] = processContact( arguments.contact );
		params.notification[ 'channels' ] = arguments.channels;

		// Optional notification-level fields
		if ( !isNull( arguments.external_id ) && len( arguments.external_id ) ) {
			params.notification[ 'external_id' ] = arguments.external_id;
		}

		if ( !isNull( arguments.data ) && !arguments.data.isEmpty() ) {
			params.notification[ 'data' ] = arguments.data;
		}

		if ( !isNull( arguments.metadata ) && !arguments.metadata.isEmpty() ) {
			params.notification[ 'metadata' ] = arguments.metadata;
		}

		if ( !isNull( arguments.email_options ) && !arguments.email_options.isEmpty() ) {
			params.notification[ 'email_options' ] = {};

			if ( arguments.email_options.keyExists( 'from_name' ) ) {
				params.notification.email_options[ 'from_name' ] = arguments.email_options.from_name;
			}
			if ( arguments.email_options.keyExists( 'cc' ) ) {
				params.notification.email_options[ 'cc' ] = listToArray( arguments.email_options.cc );
			}
			if ( arguments.email_options.keyExists( 'bcc' ) ) {
				params.notification.email_options[ 'bcc' ] = listToArray( arguments.email_options.bcc );
			}
			if ( arguments.email_options.keyExists( 'reply_to' ) ) {
				params.notification.email_options[ 'reply_to' ] = arguments.email_options.reply_to;
			}
			if ( arguments.email_options.keyExists( 'attachments' ) && isArray( arguments.email_options.attachments ) ) {
				params.notification.email_options[ 'attachments' ] = [];
				arrayEach(arguments.email_options.attachments, function(element,index) {
					if ( element.keyExists('content') && element.keyExists('filename') && element.keyExists('content_type') ) {
						params.notification.email_options[ 'attachments' ].append( {
							'content' : element.content,
							'filename' : element.filename,
							'content_type' : element.content_type
						} );
					}
				});
			}
		}
		// writedump(var=params,label="Params"); abort;
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
		params[ 'contact' ] = processContact( arguments.contact );
		return apiCall( 'POST', '/contacts.upsert', {}, params, {} );
    }

	// /contacts.getByEmail
	public struct function contactsGetByEmail( required string workspace_id, required string email ) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'email' ] = arguments.email;
		return apiCall( 'GET', '/contacts.getByEmail', params, {}, {} );
	}

	// /contacts.getByExternalId
	public struct function contactsGetByExternalId( required string workspace_id, required string external_id ) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'external_id' ] = arguments.external_id;
		return apiCall( 'GET', '/contacts.getByExternalId', params, {}, {} );
	}

	// /contacts.import
	public struct function contactsBatchImport( required string workspace_id, required array contacts, array subscribe_to_lists ) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'contacts' ] = [];

		// Process each contact in the array
		for ( var contact in arguments.contacts ) {
			var processedContact = processContact( contact );

			
			params.contacts.append( processedContact );
		}

		// Optional subscribe_to_lists parameter
		if ( !isNull( arguments.subscribe_to_lists ) && arguments.subscribe_to_lists.len() ) {
			params[ 'subscribe_to_lists' ] = arguments.subscribe_to_lists;
		}

		return apiCall( 'POST', '/contacts.import', {}, params, {} );
	}

	// /contacts.delete
	public struct function contactsDelete( required string workspace_id, required string email ) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'email' ] = arguments.email;
		return apiCall( 'POST', '/contacts.delete', {}, params, {} );
	}	


	// Contact Lists
	// contactLists.updateStatus
	public struct function contactListsUpdateStatus( required string workspace_id, required string list_id, required string email, required string status ) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'list_id' ] = arguments.list_id;
		params[ 'email' ] = arguments.email;
		if ( listFindNoCase( 'active,pending,unsubscribed,bounced,complained', arguments.status ) ) {
			params[ 'status' ] = arguments.status;
		}
		return apiCall( 'POST', '/contactLists.updateStatus', {}, params, {} );
	}

	// subscribe
	public struct function subscribe( required string workspace_id, required struct contact, required string list_ids) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'list_id' ] = listToArray( arguments.list_ids );
		params[ 'contact' ] = processContact( arguments.contact );
		return apiCall( 'POST', '/subscribe', {}, params, {} );
	}

	// lists.subscribe
	public struct function listsSubscribe( required string workspace_id, required struct contact, required string list_ids) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'list_id' ] = listToArray( arguments.list_ids );
		params[ 'contact' ] = processContact( arguments.contact );
		return apiCall( 'POST', '/lists.subscribe', {}, params, {} );
	}

	// Custom Events

	// /customEvents.import	

	// Broadcasts
	// /broadcasts.list
	public struct function broadcastsList( required string workspace_id, string status, numeric limit = 50, numeric offset = 0, bool with_templates = false) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		
		if ( listFindNoCase( 'draft,scheduled,sending,paused,sent,cancelled,failed,testing,test_completed,winner_selected', arguments.status ) ) {
			params[ 'status' ] = arguments.status;
		}
		params[ 'limit' ] = arguments.limit;
		params[ 'offset' ] = arguments.offset;
		params[ 'with_templates' ] = arguments.with_templates;
		return apiCall( 'GET', '/broadcasts.list', params, {}, {} );
	}

	// /broadcasts.get
	public struct function broadcastsGet( required string workspace_id, required string id, bool with_templates = false) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'id' ] = arguments.id;
		params[ 'with_templates' ] = arguments.with_templates;
		return apiCall( 'GET', '/broadcasts.get', params, {}, {} );
	}

	// /broadcasts.create
	public struct function broadcastsCreate( required string workspace_id, required string name, required struct audience, struct test_settings = {}, bool tracking_enabled = false, struct utm_parameters = {}, struct metadata = {} ) {
		var params = {};
		params[ 'workspace_id' ] = arguments.workspace_id;
		params[ 'name' ] = left(trim(arguments.name), 255);

		// Audience object - required list field
		params[ 'audience' ] = {};
		if ( arguments.audience.keyExists( 'list' ) ) {
			params.audience[ 'list' ] = arguments.audience.list;
		}
		if ( arguments.audience.keyExists( 'segments' ) ) {
			params.audience[ 'segments' ] = listToArray(arguments.audience.segments);
		}
		if ( arguments.audience.keyExists( 'exclude_unsubscribed' ) && isBoolean( arguments.audience.exclude_unsubscribed ) ) {
			params.audience[ 'exclude_unsubscribed' ] = arguments.audience.exclude_unsubscribed;
		} else {
			params.audience[ 'exclude_unsubscribed' ] = true;
		}

		// Test settings
		if ( !isNull( arguments.test_settings ) && !arguments.test_settings.isEmpty() ) {
			params[ 'test_settings' ] = {};

			if ( arguments.test_settings.keyExists( 'enabled' ) ) {
				params.test_settings[ 'enabled' ] = arguments.test_settings.enabled;
			}
			if ( arguments.test_settings.keyExists( 'sample_percentage' ) && isNumeric( arguments.test_settings.sample_percentage ) ) {
				params.test_settings[ 'sample_percentage' ] = arguments.test_settings.sample_percentage;
			}
			if ( arguments.test_settings.keyExists( 'auto_send_winner' ) && isBoolean( arguments.test_settings.auto_send_winner ) ) {
				params.test_settings[ 'auto_send_winner' ] = arguments.test_settings.auto_send_winner;
			}
			if ( arguments.test_settings.keyExists( 'auto_send_winner_metric' ) ) {
				if ( listFindNoCase( 'open_rate,click_rate', arguments.test_settings.auto_send_winner_metric ) ) {
					params.test_settings[ 'auto_send_winner_metric' ] = arguments.test_settings.auto_send_winner_metric;
				}
			}
			if ( arguments.test_settings.keyExists( 'test_duration_hours' ) && isNumeric( arguments.test_settings.test_duration_hours ) ) {
				params.test_settings[ 'test_duration_hours' ] = arguments.test_settings.test_duration_hours;
			}
			if ( arguments.test_settings.keyExists( 'variations' ) && isArray( arguments.test_settings.variations ) ) {
				if ( arguments.test_settings.variations.len() >= 2 && arguments.test_settings.variations.len() <= 8 ) {
					params.test_settings[ 'variations' ] = [];
					arrayEach(arguments.test_settings.variations, function(element,index) {
						if ( element.keyExists('template_id') ) {
							// we are assuming the element is valid
							params.test_settings[ 'variations' ].append( element )
						};
					});
				}
			}
		}

		// Tracking enabled
		if ( !isNull( arguments.tracking_enabled ) ) {
			params[ 'tracking_enabled' ] = arguments.tracking_enabled;
		}

		// UTM parameters
		if ( !isNull( arguments.utm_parameters ) && !arguments.utm_parameters.isEmpty() ) {
			params[ 'utm_parameters' ] = {};

			if ( arguments.utm_parameters.keyExists( 'source' ) ) {
				params.utm_parameters[ 'source' ] = arguments.utm_parameters.source;
			}
			if ( arguments.utm_parameters.keyExists( 'medium' ) ) {
				params.utm_parameters[ 'medium' ] = arguments.utm_parameters.medium;
			}
			if ( arguments.utm_parameters.keyExists( 'campaign' ) ) {
				params.utm_parameters[ 'campaign' ] = arguments.utm_parameters.campaign;
			}
			if ( arguments.utm_parameters.keyExists( 'term' ) ) {
				params.utm_parameters[ 'term' ] = arguments.utm_parameters.term;
			}
			if ( arguments.utm_parameters.keyExists( 'content' ) ) {
				params.utm_parameters[ 'content' ] = arguments.utm_parameters.content;
			}
		}

		// Metadata
		if ( !isNull( arguments.metadata ) && !arguments.metadata.isEmpty() ) {
			params[ 'metadata' ] = arguments.metadata;
		}

		return apiCall( 'POST', '/broadcasts.create', {}, params, {} );
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

  private struct function processContact( required struct contact ) {
	var processedContact = {};

	// Required field
	processedContact[ 'email' ] = contact.email;

	// Optional string fields
	if ( contact.keyExists( 'external_id' ) ) processedContact[ 'external_id' ] = contact.external_id;
	if ( contact.keyExists( 'timezone' ) ) processedContact[ 'timezone' ] = contact.timezone;
	if ( contact.keyExists( 'language' ) ) processedContact[ 'language' ] = contact.language;
	if ( contact.keyExists( 'first_name' ) ) processedContact[ 'first_name' ] = contact.first_name;
	if ( contact.keyExists( 'last_name' ) ) processedContact[ 'last_name' ] = contact.last_name;
	if ( contact.keyExists( 'full_name' ) ) processedContact[ 'full_name' ] = contact.full_name;
	if ( contact.keyExists( 'phone' ) ) processedContact[ 'phone' ] = contact.phone;
	if ( contact.keyExists( 'address_line_1' ) ) processedContact[ 'address_line_1' ] = contact.address_line_1;
	if ( contact.keyExists( 'address_line_2' ) ) processedContact[ 'address_line_2' ] = contact.address_line_2;
	if ( contact.keyExists( 'country' ) ) processedContact[ 'country' ] = contact.country;
	if ( contact.keyExists( 'postcode' ) ) processedContact[ 'postcode' ] = contact.postcode;
	if ( contact.keyExists( 'state' ) ) processedContact[ 'state' ] = contact.state;
	if ( contact.keyExists( 'job_title' ) ) processedContact[ 'job_title' ] = contact.job_title;

	// Custom string fields (1-5)
	for ( var i = 1; i <= 5; i++ ) {
		if ( arguments.contact.keyExists( 'custom_string_#i#' ) ) processedContact[ 'custom_string_#i#' ] = arguments.contact[ 'custom_string_#i#' ];
	}

	// Custom number fields (1-5)
	for ( var i = 1; i <= 5; i++ ) {
		if ( arguments.contact.keyExists( 'custom_number_#i#' ) ) processedContact[ 'custom_number_#i#' ] = arguments.contact[ 'custom_number_#i#' ];
	}

	// Custom datetime fields (1-5)
	for ( var i = 1; i <= 5; i++ ) {
		if ( arguments.contact.keyExists( 'custom_datetime_#i#' ) ) processedContact[ 'custom_datetime_#i#' ] = arguments.contact[ 'custom_datetime_#i#' ];
	}

	// Custom JSON fields (1-5)
	for ( var i = 1; i <= 5; i++ ) {
		if ( arguments.contact.keyExists( 'custom_json_#i#' ) ) processedContact[ 'custom_json_#i#' ] = arguments.contact[ 'custom_json_#i#' ];
	}

	return processedContact;
  }


}