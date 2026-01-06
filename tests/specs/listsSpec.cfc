
component extends="testbox.system.BaseSpec" {

    function run() {

        describe( 'Contact Lists...', function() {

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

            it( 'can update contact list status to active', function() {
                var res = notifuse.contactListsUpdateStatus(
                    workspace_id = 'my_ws',
                    list_id = 'list_123',
                    email = 'test@example.com',
                    status = 'active'
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'POST' );
                expect( httpRequest.path ).toInclude( '/contactLists.updateStatus' );

                expect( httpRequest.body.workspace_id ).toBe( 'my_ws' );
                expect( httpRequest.body.list_id ).toBe( 'list_123' );
                expect( httpRequest.body.email ).toBe( 'test@example.com' );
                expect( httpRequest.body.status ).toBe( 'active' );
            });

            it( 'can update contact list status to unsubscribed', function() {
                var res = notifuse.contactListsUpdateStatus(
                    workspace_id = 'my_ws',
                    list_id = 'list_456',
                    email = 'user@example.com',
                    status = 'unsubscribed'
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.workspace_id ).toBe( 'my_ws' );
                expect( httpRequest.body.list_id ).toBe( 'list_456' );
                expect( httpRequest.body.email ).toBe( 'user@example.com' );
                expect( httpRequest.body.status ).toBe( 'unsubscribed' );
            });

            it( 'can update contact list status to pending', function() {
                var res = notifuse.contactListsUpdateStatus(
                    workspace_id = 'my_ws',
                    list_id = 'list_789',
                    email = 'pending@example.com',
                    status = 'pending'
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.status ).toBe( 'pending' );
            });

            it( 'can update contact list status to bounced', function() {
                var res = notifuse.contactListsUpdateStatus(
                    workspace_id = 'my_ws',
                    list_id = 'list_abc',
                    email = 'bounced@example.com',
                    status = 'bounced'
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.status ).toBe( 'bounced' );
            });

            it( 'can update contact list status to complained', function() {
                var res = notifuse.contactListsUpdateStatus(
                    workspace_id = 'my_ws',
                    list_id = 'list_def',
                    email = 'complained@example.com',
                    status = 'complained'
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                expect( httpRequest.body.status ).toBe( 'complained' );
            });

            it( 'does not include invalid status values', function() {
                var res = notifuse.contactListsUpdateStatus(
                    workspace_id = 'my_ws',
                    list_id = 'list_ghi',
                    email = 'invalid@example.com',
                    status = 'invalid_status'
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                var httpRequest = mockCallLog[ 1 ];

                // Invalid status should not be included in the request
                expect( httpRequest.body ).notToHaveKey( 'status' );
                expect( httpRequest.body.workspace_id ).toBe( 'my_ws' );
                expect( httpRequest.body.list_id ).toBe( 'list_ghi' );
                expect( httpRequest.body.email ).toBe( 'invalid@example.com' );
            });
        } );



    }


}
