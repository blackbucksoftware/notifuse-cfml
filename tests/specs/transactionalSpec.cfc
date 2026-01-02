
component extends="testbox.system.BaseSpec" {

    function run() {
        
        describe( 'The wrapper', function() {
            
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

            it( 'can make a POST request to send a message', function() {
                var res = notifuse.transactionalSend( workspace_id = 'my_ws', id = 'my_transactional_template', contact = { email = "test@example.com" });
                
                // Verify the HTTP request was made correctly
                var httpRequest = httpService.$callLog().exec[ 1 ][ 1 ];
                expect( httpRequest.method ).toBe( 'POST' );
                expect( httpRequest.url ).toInclude( '/transactional.send' );
                
                // Verify request body contains expected data
                expect( httpRequest.body ).toInclude( 'my_ws' );
                expect( httpRequest.body ).toInclude( 'my_transactional_template' );
                expect( httpRequest.body ).toInclude( 'test@example.com' );
            } );

        } );

        
    }

    private function sum( a, b ){
            return a + b;
        }

}
