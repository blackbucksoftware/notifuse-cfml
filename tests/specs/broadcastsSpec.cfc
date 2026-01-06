
component extends="testbox.system.BaseSpec" {

    function run() {

        describe( 'Broadcasts...', function() {

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
                var res = notifuse.broadcastsList( workspace_id = 'my_ws' );

                // Verify the HTTP request was made correctly
                var mockCallLog = notifuse.$callLog().makeHttpRequest;
                expect( mockCallLog ).toHaveLength( 1 );

                var httpRequest = mockCallLog[ 1 ];
                expect( httpRequest.httpMethod ).toBe( 'GET' );
                expect( httpRequest.path ).toInclude( '/broadcasts.list' );
                expect( httpRequest.queryParams.workspace_id ).toBe( 'my_ws' );
            });

            
        } );



    }


}
