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

}
