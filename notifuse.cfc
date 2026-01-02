component displayname="notifuse" output="false" accessors="true" { 
 // functions and properties here 
	property name="apiKey" type="string";
	property name="baseUrl" type="string";
	property httpService;

	public struct function init( string apiKey = '', string baseUrl = '' ) {
		setApiKey( apiKey );
		setBaseUrl( baseUrl );
		variables.httpService = new lib.httpService();

        return this;
    }

	private string function getURL( required string section, required string method ) {
        var ApiUrl = getBaseUrl();
		ApiUrl &= '/' & 'api';
        ApiUrl &= '/' & arguments.section;
        ApiUrl &= '.' & arguments.method;

        return ApiUrl;
    }

    private any function postAPI( required string section, required string method, struct options = {} ) {
        var httpResult = '';
        var result = {
			'message_id' = '',
			'success' = false,
            'error' = 'There was a connection error.'
        };

		var httpRequest = {
			method: 'POST',
			url: getURL( arguments.section, arguments.method ),
			headers: [
				{ name: 'Content-Type', value: 'application/json' },
				{ name: 'Authorization', value: 'Bearer ' & getAPIKey() }
			],
			body: serializeJSON( arguments.options ),
			timeout: 1600
		};

		httpResult = variables.httpService.exec( httpRequest );

        if ( isJSON( httpResult ) ) {
            result = deserializeJSON( httpResult );
        } else {
            result.error = httpResult;
        }

        return result;
    }

	private any function getAPI( required string section, required string method, struct options = {} ) {
        var httpResult = '';
        var result = {
            'error' = 'There was a connection error.'
        };

		// Build query string from options
		var queryParams = [];
		for ( var currentKey in arguments.options ) {
			queryParams.append( currentKey & '=' & urlEncodedFormat( arguments.options[ currentKey ] ) );
		}
		var url2 = getURL( arguments.section, arguments.method );
		if ( arrayLen( queryParams ) ) {
			url2 &= '?' & arrayToList( queryParams, '&' );
		}

		var httpRequest = {
			method: 'GET',
			url: url2,
			headers: [
				{ name: 'Authorization', value: 'Bearer ' & getAPIKey() }
			],
			timeout: 1600
		};


		httpResult = variables.httpService.exec( httpRequest );

        if ( isJSON( httpResult ) ) {
            result = deserializeJSON( httpResult );
        } else {
            result.error = httpResult;
        }

        return result;
    }

	// /transactional

	// /transactional.send
	public struct function transactionalSend( required string workspace_id, required string id, required struct contact, array channels = ['email'] ) {
        var results = {};
        var options = {};

        options[ 'workspace_id' ] = arguments.workspace_id;
		options[ 'notification' ] = {};
		options.notification[ 'id' ] = arguments.id;

		options.notification[ 'contact' ] = {};
		options.notification.contact[ 'email' ] = arguments.contact.email;

		options.notification[ 'channels' ] = arguments.channels;

        structAppend( results, postAPI( 'transactional', 'send', options ) );

        return results;
    }

	// /contacts

	// /contacts.list
	public struct function contactsList( required string workspace_id, string email, string external_id, string first_name, string last_name, string full_name, string phone, string country, string language, string list_id, string contact_list_status, array segments, boolean with_contact_lists = false,  numeric limit = 20, string cursor ) {
		var results = {
			contacts = {},
            next_cursor = ''
		};
		var options = {};

		options[ 'workspace_id' ] = arguments.workspace_id;

		if ( len( arguments.email ) ) {
			options[ 'email' ] = arguments.email;
		}
		if ( len( arguments.external_id ) ) {
			options[ 'external_id' ] = arguments.external_id;
		}
        if ( len( arguments.first_name ) ) {
            options[ 'first_name' ] = arguments.first_name;
        }
        if ( len( arguments.last_name ) ) {
            options[ 'last_name' ] = arguments.last_name;
        }
        if ( len( arguments.full_name ) ) {
            options[ 'full_name' ] = arguments.full_name;
        }
		if ( len( arguments.phone ) ) {
			options[ 'phone' ] = arguments.phone;
		}
		if ( len( arguments.country ) ) {
			options[ 'country' ] = arguments.country;
		}
		if ( len( arguments.language ) ) {
			options[ 'language' ] = arguments.language;
		}
		if ( len( arguments.list_id ) ) {
			options[ 'list_id' ] = arguments.list_id;
		}
		
		if ( listFindNoCase( 'active,pending,unsubscribed,bounced,complained', arguments.contact_list_status ) ) {
			options[ 'contact_list_status' ] = arguments.contact_list_status;
		}

		if ( len( arguments.segments ) ) {
			options[ 'segments' ] = arguments.segments;
		}
		options[ 'with_contact_lists' ] = arguments.with_contact_lists;

		options[ 'limit' ] = arguments.limit;

		if ( len( arguments.cursor ) ) {
			options[ 'cursor' ] = arguments.cursor;
		}

		structAppend( results, getAPI( 'contacts', 'list', options ) );
		// writeDump( results );
		return results;
	}

	// /contacts.count
	public struct function contactsCount( required string workspace_id ) {
		var results = {
			total_contacts = 0
		};
		var options = {};

		options[ 'workspace_id' ] = arguments.workspace_id;

		structAppend( results, getAPI( 'contacts', 'count', options ) );
		
		return results;
	}

	// /contacts.upsert
	public struct function contactsUpsert( required string workspace_id, required struct contact ) {
        var results = {
			'email' = '',
			'action' = '',
			'error' = ''
		};
        var options = {};

        options[ 'workspace_id' ] = arguments.workspace_id;
		options[ 'contact' ] = {};

		// Required field
		options.contact[ 'email' ] = arguments.contact.email;

		// Optional string fields
		if ( arguments.contact.keyExists( 'external_id' ) ) options.contact[ 'external_id' ] = arguments.contact.external_id;
		if ( arguments.contact.keyExists( 'timezone' ) ) options.contact[ 'timezone' ] = arguments.contact.timezone;
		if ( arguments.contact.keyExists( 'language' ) ) options.contact[ 'language' ] = arguments.contact.language;
		if ( arguments.contact.keyExists( 'first_name' ) ) options.contact[ 'first_name' ] = arguments.contact.first_name;
		if ( arguments.contact.keyExists( 'last_name' ) ) options.contact[ 'last_name' ] = arguments.contact.last_name;
		if ( arguments.contact.keyExists( 'full_name' ) ) options.contact[ 'full_name' ] = arguments.contact.full_name;
		if ( arguments.contact.keyExists( 'phone' ) ) options.contact[ 'phone' ] = arguments.contact.phone;
		if ( arguments.contact.keyExists( 'address_line_1' ) ) options.contact[ 'address_line_1' ] = arguments.contact.address_line_1;
		if ( arguments.contact.keyExists( 'address_line_2' ) ) options.contact[ 'address_line_2' ] = arguments.contact.address_line_2;
		if ( arguments.contact.keyExists( 'country' ) ) options.contact[ 'country' ] = arguments.contact.country;
		if ( arguments.contact.keyExists( 'postcode' ) ) options.contact[ 'postcode' ] = arguments.contact.postcode;
		if ( arguments.contact.keyExists( 'state' ) ) options.contact[ 'state' ] = arguments.contact.state;
		if ( arguments.contact.keyExists( 'job_title' ) ) options.contact[ 'job_title' ] = arguments.contact.job_title;

		// Custom string fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_string_#i#' ) ) options.contact[ 'custom_string_#i#' ] = arguments.contact[ 'custom_string_#i#' ];
		}

		// Custom number fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_number_#i#' ) ) options.contact[ 'custom_number_#i#' ] = arguments.contact[ 'custom_number_#i#' ];
		}

		// Custom datetime fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_datetime_#i#' ) ) options.contact[ 'custom_datetime_#i#' ] = arguments.contact[ 'custom_datetime_#i#' ];
		}

		// Custom JSON fields (1-5)
		for ( var i = 1; i <= 5; i++ ) {
			if ( arguments.contact.keyExists( 'custom_json_#i#' ) ) options.contact[ 'custom_json_#i#' ] = arguments.contact[ 'custom_json_#i#' ];
		}

        structAppend( results, postAPI( 'contacts', 'upsert', options ) );

        return results;
    }

}
