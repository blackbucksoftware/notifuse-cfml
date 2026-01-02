component {

	this.name           = "notifuse-cfml";
	this.title          = "Notifuse CFML";
	this.author         = "Lutz Lesener";
	this.webURL         = "https://github.com/blackbucksoftware/notifuse-cfml";
	this.description    = "This module will provide you with connectivity to the Notifuse API for any ColdFusion (CFML) application.";
	this.entryPoint     = "notifusecfml";
	this.modelNamespace = "notifusecfml";
	this.cfmapping      = "notifusecfml";
	this.dependencies   = [];

	function configure(){
		settings = { apiKey : "YOUR_KEY", baseUrl : "https://demo.notifuse.com" };
	}

	function onLoad(){
		binder.map( "notifuse@notifusecfml" ).to( "#moduleMapping#.notifuse" ).asSingleton().initWith( apiKey = settings.apiKey, baseUrl = settings.baseUrl );
	}

}
