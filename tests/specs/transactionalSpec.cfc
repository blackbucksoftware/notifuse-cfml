
component extends="testbox.system.BaseSpec" {

    function run() {

        describe( 'Transactional Notifications...', function() {

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

            it( 'can send a basic transactional notification', function() {
                var res = notifuse.transactionalSend(
                    workspace_id = 'my_ws',
                    id = 'my_transactional_template',
                    contact = { email = "test@example.com" }
                );

                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'POST' );
                expect( httpRequest.path ).toInclude( '/transactional.send' );

                // body is already a struct, no need to deserialize
                expect( httpRequest.body.workspace_id ).toBe( 'my_ws' );
                expect( httpRequest.body.notification.id ).toBe( 'my_transactional_template' );
                expect( httpRequest.body.notification.contact.email ).toBe( 'test@example.com' );
                expect( httpRequest.body.notification.channels[ 1 ] ).toBe( 'email' );
            } );

        } );


    }

}
