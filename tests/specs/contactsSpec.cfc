
component extends="testbox.system.BaseSpec" {

    function run() {
        
        describe( 'Contacts...', function() {
            
            var notifuse = new notifuse( 'fake_key', 'https://demo.notifuse.com/' );
            var httpService = getProperty( notifuse, 'httpService' );
            prepareMock( httpService );
            httpService.$(
                'exec',
                {
                    responseHeader: {
                        'Content-Type': 'application/json',
                        'Request-Id': ''
                    },
                    statuscode: '200 OK',
                    filecontent: '{}'
                }
            );

            afterEach( function() {
                httpService.$reset();
            } );

            it( 'can be listed', function() {
                var res = notifuse.contactsList( workspace_id = 'my_ws' );

                // Verify the HTTP request was made correctly
                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.method ).toBe( 'GET' );
                expect( httpRequest.url ).toInclude( '/contacts.list' );

                // expect( res.contacts ).toBeTypeOf( 'array' );
            });

            it( 'can be filtered', function() {
                var res = notifuse.contactsList( workspace_id = 'my_ws', email = 'test@example.com' );
                // writedump( res );
                
                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.method ).toBe( 'GET' );
                expect( httpRequest.url ).toInclude( '/contacts.list' );
                expect( httpRequest.url ).toInclude( urlEncodedFormat('test@example.com') );

            });

            it( 'can be counted', function() {
                var res = notifuse.contactsCount( workspace_id = 'my_ws' );
                // writedump( res );
                
                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.method ).toBe( 'GET' );
                expect( httpRequest.url ).toInclude( '/contacts.count' );
                expect( httpRequest.url ).toInclude( urlEncodedFormat('my_ws') );

            });

            it( 'can be created with only email', function() {
                var res = notifuse.contactsUpsert( workspace_id = 'my_ws', contact = { email = 'test@example.com' });

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.method ).toBe( 'POST' );
                expect( httpRequest.url ).toInclude( '/contacts.upsert' );

                expect( httpRequest.body ).toInclude( 'my_ws' );
                expect( httpRequest.body ).toInclude( 'test@example.com' );
            });

            it( 'can be created with standard fields', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'john.doe@example.com',
                        first_name = 'John',
                        last_name = 'Doe',
                        full_name = 'John Doe',
                        phone = '+1234567890',
                        timezone = 'America/New_York',
                        language = 'en-US'
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.method ).toBe( 'POST' );
                expect( httpRequest.url ).toInclude( '/contacts.upsert' );

                // Verify all fields are in request body
                expect( httpRequest.body ).toInclude( 'john.doe@example.com' );
                expect( httpRequest.body ).toInclude( 'John' );
                expect( httpRequest.body ).toInclude( 'Doe' );
                expect( httpRequest.body ).toInclude( '+1234567890' );
                expect( httpRequest.body ).toInclude( 'America/New_York' );
                expect( httpRequest.body ).toInclude( 'en-US' );
            });

            it( 'can be created with address fields', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'user@example.com',
                        address_line_1 = '123 Main St',
                        address_line_2 = 'Apt 4B',
                        country = 'US',
                        state = 'NY',
                        postcode = '10001'
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.body ).toInclude( '123 Main St' );
                expect( httpRequest.body ).toInclude( 'Apt 4B' );
                expect( httpRequest.body ).toInclude( 'US' );
                expect( httpRequest.body ).toInclude( 'NY' );
                expect( httpRequest.body ).toInclude( '10001' );
            });

            it( 'can be created with external_id and job_title', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'employee@example.com',
                        external_id = 'EMP-12345',
                        job_title = 'Software Engineer'
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.body ).toInclude( 'EMP-12345' );
                expect( httpRequest.body ).toInclude( 'Software Engineer' );
            });

            it( 'can be created with custom string fields', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'customer@example.com',
                        custom_string_1 = 'Premium',
                        custom_string_2 = 'VIP Customer',
                        custom_string_3 = 'Monthly Plan'
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.body ).toInclude( 'Premium' );
                expect( httpRequest.body ).toInclude( 'VIP Customer' );
                expect( httpRequest.body ).toInclude( 'Monthly Plan' );
            });

            it( 'can be created with custom number fields', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'customer@example.com',
                        custom_number_1 = 100,
                        custom_number_2 = 5000,
                        custom_number_3 = 42
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.body ).toInclude( '100' );
                expect( httpRequest.body ).toInclude( '5000' );
                expect( httpRequest.body ).toInclude( '42' );
            });

            it( 'can be created with custom datetime fields', function() {
                var testDate = '2026-01-03T12:00:00Z';
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'customer@example.com',
                        custom_datetime_1 = testDate,
                        custom_datetime_2 = '2025-12-31T23:59:59Z'
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.body ).toInclude( testDate );
                expect( httpRequest.body ).toInclude( '2025-12-31T23:59:59Z' );
            });

            it( 'can be created with custom JSON fields', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'customer@example.com',
                        custom_json_1 = { preference = 'dark_mode', notifications = true },
                        custom_json_2 = { plan = 'enterprise', seats = 10 }
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.body ).toInclude( 'dark_mode' );
                expect( httpRequest.body ).toInclude( 'enterprise' );
            });

            it( 'only includes fields that are provided', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'minimal@example.com',
                        first_name = 'Jane'
                    }
                );

                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                var body = httpRequest.body;

                // Should include provided fields
                expect( body ).toInclude( 'minimal@example.com' );
                expect( body ).toInclude( 'Jane' );

                // Should not include unprovided optional fields
                expect( body ).notToInclude( 'last_name' );
                expect( body ).notToInclude( 'phone' );
                expect( body ).notToInclude( 'address_line_1' );
            });
        } );

    }

    
}
