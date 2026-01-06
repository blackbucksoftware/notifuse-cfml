
component extends="testbox.system.BaseSpec" {

    function run() {

        describe( 'Contacts...', function() {

            var notifuse = new notifuse( 'fake_key', 'https://demo.notifuse.com/' );
            prepareMock( notifuse );

            // Mock the makeHttpRequest method to capture calls and return a mock response
            notifuse.$(
                'makeHttpRequest',
                {
                    responseHeader: {
                        'Content-Type': 'application/json'
                    },
                    statuscode: '200 OK',
                    filecontent: '{}'
                }
            );

            afterEach( function() {
                notifuse.$reset( 'makeHttpRequest' );
            } );

            it( 'can be listed', function() {
                var res = notifuse.contactsList( workspace_id = 'my_ws' );

                // Verify the HTTP request was made correctly
                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'GET' );
                expect( httpRequest.path ).toInclude( '/contacts.list' );
                expect( httpRequest.queryParams.workspace_id ).toBe( 'my_ws' );
            });

            it( 'can be filtered', function() {
                var res = notifuse.contactsList( workspace_id = 'my_ws', email = 'test@example.com' );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'GET' );
                expect( httpRequest.path ).toInclude( '/contacts.list' );
                expect( httpRequest.queryParams.email ).toBe( 'test@example.com' );
            });

            it( 'can be counted', function() {
                var res = notifuse.contactsCount( workspace_id = 'my_ws' );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'GET' );
                expect( httpRequest.path ).toInclude( '/contacts.count' );
                expect( httpRequest.queryParams.workspace_id ).toBe( 'my_ws' );
            });

            it( 'can be created with only email', function() {
                var res = notifuse.contactsUpsert( workspace_id = 'my_ws', contact = { email = 'test@example.com' });

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'POST' );
                expect( httpRequest.path ).toInclude( '/contacts.upsert' );

                // body is already a struct, no need to deserialize
                expect( httpRequest.body.workspace_id ).toBe( 'my_ws' );
                expect( httpRequest.body.contact.email ).toBe( 'test@example.com' );
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

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'POST' );
                expect( httpRequest.path ).toInclude( '/contacts.upsert' );

                expect( httpRequest.body.contact.email ).toBe( 'john.doe@example.com' );
                expect( httpRequest.body.contact.first_name ).toBe( 'John' );
                expect( httpRequest.body.contact.last_name ).toBe( 'Doe' );
                expect( httpRequest.body.contact.full_name ).toBe( 'John Doe' );
                expect( httpRequest.body.contact.phone ).toBe( '+1234567890' );
                expect( httpRequest.body.contact.timezone ).toBe( 'America/New_York' );
                expect( httpRequest.body.contact.language ).toBe( 'en-US' );
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

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contact.address_line_1 ).toBe( '123 Main St' );
                expect( httpRequest.body.contact.address_line_2 ).toBe( 'Apt 4B' );
                expect( httpRequest.body.contact.country ).toBe( 'US' );
                expect( httpRequest.body.contact.state ).toBe( 'NY' );
                expect( httpRequest.body.contact.postcode ).toBe( '10001' );
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

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contact.external_id ).toBe( 'EMP-12345' );
                expect( httpRequest.body.contact.job_title ).toBe( 'Software Engineer' );
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

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contact.custom_string_1 ).toBe( 'Premium' );
                expect( httpRequest.body.contact.custom_string_2 ).toBe( 'VIP Customer' );
                expect( httpRequest.body.contact.custom_string_3 ).toBe( 'Monthly Plan' );
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

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contact.custom_number_1 ).toBe( 100 );
                expect( httpRequest.body.contact.custom_number_2 ).toBe( 5000 );
                expect( httpRequest.body.contact.custom_number_3 ).toBe( 42 );
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

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contact.custom_datetime_1 ).toBe( testDate );
                expect( httpRequest.body.contact.custom_datetime_2 ).toBe( '2025-12-31T23:59:59Z' );
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

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contact.custom_json_1.preference ).toBe( 'dark_mode' );
                expect( httpRequest.body.contact.custom_json_1.notifications ).toBe( true );
                expect( httpRequest.body.contact.custom_json_2.plan ).toBe( 'enterprise' );
                expect( httpRequest.body.contact.custom_json_2.seats ).toBe( 10 );
            });

            it( 'only includes fields that are provided', function() {
                var res = notifuse.contactsUpsert(
                    workspace_id = 'my_ws',
                    contact = {
                        email = 'minimal@example.com',
                        first_name = 'Jane'
                    }
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                // Should include provided fields
                expect( httpRequest.body.contact.email ).toBe( 'minimal@example.com' );
                expect( httpRequest.body.contact.first_name ).toBe( 'Jane' );

                // Should not include unprovided optional fields
                expect( httpRequest.body.contact ).notToHaveKey( 'last_name' );
                expect( httpRequest.body.contact ).notToHaveKey( 'phone' );
                expect( httpRequest.body.contact ).notToHaveKey( 'address_line_1' );
            });
        } );

        describe( 'Batch Import...', function() {

            var notifuse = new notifuse( 'fake_key', 'https://demo.notifuse.com/' );
            prepareMock( notifuse );

            // Mock the makeHttpRequest method to capture calls and return a mock response
            notifuse.$(
                'makeHttpRequest',
                {
                    responseHeader: {
                        'Content-Type': 'application/json'
                    },
                    statuscode: '200 OK',
                    filecontent: '{}'
                }
            );

            afterEach( function() {
                notifuse.$reset( 'makeHttpRequest' );
            } );

            it( 'can import a single contact', function() {
                var contacts = [
                    { email = 'test@example.com' }
                ];
                var res = notifuse.contactsBatchImport( workspace_id = 'my_ws', contacts = contacts );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'POST' );
                expect( httpRequest.path ).toInclude( '/contacts.import' );

                expect( httpRequest.body.workspace_id ).toBe( 'my_ws' );
                expect( httpRequest.body.contacts ).toHaveLength( 1 );
                expect( httpRequest.body.contacts[ 1 ].email ).toBe( 'test@example.com' );
            });

            it( 'can import multiple contacts', function() {
                var contacts = [
                    { email = 'user1@example.com', first_name = 'John' },
                    { email = 'user2@example.com', first_name = 'Jane' },
                    { email = 'user3@example.com', first_name = 'Bob' }
                ];
                var res = notifuse.contactsBatchImport( workspace_id = 'my_ws', contacts = contacts );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'POST' );
                expect( httpRequest.path ).toInclude( '/contacts.import' );

                expect( httpRequest.body.contacts ).toHaveLength( 3 );
                expect( httpRequest.body.contacts[ 1 ].email ).toBe( 'user1@example.com' );
                expect( httpRequest.body.contacts[ 1 ].first_name ).toBe( 'John' );
                expect( httpRequest.body.contacts[ 2 ].email ).toBe( 'user2@example.com' );
                expect( httpRequest.body.contacts[ 2 ].first_name ).toBe( 'Jane' );
                expect( httpRequest.body.contacts[ 3 ].email ).toBe( 'user3@example.com' );
                expect( httpRequest.body.contacts[ 3 ].first_name ).toBe( 'Bob' );
            });

            it( 'can import contacts with all standard fields', function() {
                var contacts = [
                    {
                        email = 'full@example.com',
                        external_id = 'EXT-001',
                        first_name = 'John',
                        last_name = 'Doe',
                        full_name = 'John Doe',
                        phone = '+1234567890',
                        timezone = 'America/New_York',
                        language = 'en-US',
                        address_line_1 = '123 Main St',
                        address_line_2 = 'Apt 4B',
                        country = 'US',
                        state = 'NY',
                        postcode = '10001',
                        job_title = 'Software Engineer'
                    }
                ];
                var res = notifuse.contactsBatchImport( workspace_id = 'my_ws', contacts = contacts );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];
                var contact = httpRequest.body.contacts[ 1 ];

                expect( contact.email ).toBe( 'full@example.com' );
                expect( contact.external_id ).toBe( 'EXT-001' );
                expect( contact.full_name ).toBe( 'John Doe' );
                expect( contact.phone ).toBe( '+1234567890' );
                expect( contact.timezone ).toBe( 'America/New_York' );
                expect( contact.address_line_1 ).toBe( '123 Main St' );
                expect( contact.job_title ).toBe( 'Software Engineer' );
            });

            it( 'can import contacts with custom fields', function() {
                var contacts = [
                    {
                        email = 'custom@example.com',
                        custom_string_1 = 'Premium',
                        custom_number_1 = 100,
                        custom_datetime_1 = '2026-01-03T12:00:00Z',
                        custom_json_1 = { tier = 'gold', active = true }
                    }
                ];
                var res = notifuse.contactsBatchImport( workspace_id = 'my_ws', contacts = contacts );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];
                var contact = httpRequest.body.contacts[ 1 ];

                expect( contact.email ).toBe( 'custom@example.com' );
                expect( contact.custom_string_1 ).toBe( 'Premium' );
                expect( contact.custom_number_1 ).toBe( 100 );
                expect( contact.custom_datetime_1 ).toBe( '2026-01-03T12:00:00Z' );
                expect( contact.custom_json_1.tier ).toBe( 'gold' );
                expect( contact.custom_json_1.active ).toBe( true );
            });

            it( 'can import contacts with subscribe_to_lists', function() {
                var contacts = [
                    { email = 'subscriber@example.com' }
                ];
                var lists = [ 'list_123', 'list_456' ];
                var res = notifuse.contactsBatchImport(
                    workspace_id = 'my_ws',
                    contacts = contacts,
                    subscribe_to_lists = lists
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contacts[ 1 ].email ).toBe( 'subscriber@example.com' );
                expect( httpRequest.body.subscribe_to_lists ).toHaveLength( 2 );
                expect( httpRequest.body.subscribe_to_lists[ 1 ] ).toBe( 'list_123' );
                expect( httpRequest.body.subscribe_to_lists[ 2 ] ).toBe( 'list_456' );
            });

            it( 'only includes fields that are provided for each contact', function() {
                var contacts = [
                    { email = 'minimal1@example.com', first_name = 'Alice' },
                    { email = 'minimal2@example.com', last_name = 'Smith' }
                ];
                var res = notifuse.contactsBatchImport( workspace_id = 'my_ws', contacts = contacts );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contacts[ 1 ].email ).toBe( 'minimal1@example.com' );
                expect( httpRequest.body.contacts[ 1 ].first_name ).toBe( 'Alice' );
                expect( httpRequest.body.contacts[ 1 ] ).notToHaveKey( 'last_name' );

                expect( httpRequest.body.contacts[ 2 ].email ).toBe( 'minimal2@example.com' );
                expect( httpRequest.body.contacts[ 2 ].last_name ).toBe( 'Smith' );
                expect( httpRequest.body.contacts[ 2 ] ).notToHaveKey( 'first_name' );
            });

            it( 'handles mixed contact data structures', function() {
                var contacts = [
                    {
                        email = 'rich@example.com',
                        first_name = 'Rich',
                        custom_string_1 = 'VIP'
                    },
                    {
                        email = 'simple@example.com'
                    },
                    {
                        email = 'medium@example.com',
                        phone = '+9876543210',
                        country = 'UK'
                    }
                ];
                var res = notifuse.contactsBatchImport( workspace_id = 'my_ws', contacts = contacts );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.contacts ).toHaveLength( 3 );
                expect( httpRequest.body.contacts[ 1 ].email ).toBe( 'rich@example.com' );
                expect( httpRequest.body.contacts[ 1 ].first_name ).toBe( 'Rich' );
                expect( httpRequest.body.contacts[ 1 ].custom_string_1 ).toBe( 'VIP' );

                expect( httpRequest.body.contacts[ 2 ].email ).toBe( 'simple@example.com' );
                expect( httpRequest.body.contacts[ 2 ] ).notToHaveKey( 'first_name' );

                expect( httpRequest.body.contacts[ 3 ].email ).toBe( 'medium@example.com' );
                expect( httpRequest.body.contacts[ 3 ].phone ).toBe( '+9876543210' );
                expect( httpRequest.body.contacts[ 3 ].country ).toBe( 'UK' );
            });
        } );

    }


}
