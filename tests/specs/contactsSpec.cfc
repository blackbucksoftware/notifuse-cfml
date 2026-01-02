
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
        } );

    }

    
}
