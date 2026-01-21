# notifuse-cfml

**notifuse-cfml** is a CFML library for interacting with the Notifuse API. [Notifuse](https://notifuse.com) is a modern, self-hosted emailing platform that allows you to send newsletters and transactional emails. 

## Installation
This wrapper can be installed as standalone library or as a ColdBox Module. Either approach requires a simple CommandBox command:

```
$ box install notifusecfml
```

Alternatively the git repository can be cloned.

### Standalone Usage

Once the library has been installed, the core `notifuse` component can be instantiated directly:

```cfc
notifuse = new path.to.notifusecfml.notifuse(
    apiKey = 'YOUR_NOTIFUSE_API_KEY',
    baseUrl = 'https://demo.notifuse.com'
);
```

### ColdBox Module

To use the library as a ColdBox Module, add the init arguments to the `moduleSettings` struct in `config/Coldbox.cfc`:

```cfc
moduleSettings = {
    notifusecfml: {
        apiKey: 'YOUR_NOTIFUSE_API_KEY',
        baseUrl: 'https://demo.notifuse.com'
    }
}
```

You can subsequently reference the library via the injection DSL: `notifuse@notifusecfml`:

```cfc
property name="notifuse" inject="notifuse@notifusecfml";
```

## Getting Started

```
<!--- Send a transactional message --->
<cfscript>
	x = notifuse.transactionalSend(
		workspace_id = 'my_workspace',
		id = 'welcome_template',
		contact = {
			email = 'tom@test.com'
		},
		data = {
			'greeting' = 'Hi Tom',
			'password' = 'secret1234!',
			'user' = 'tom45'
		},
		email_options = {
			attachments = [
				{
					filename = 'attach_me.md',
					content = toBase64( fileReadBinary( expandPath( 'attach_me.md' ) ) ),
					content_type = 'text/markdown'
				}
			]
		}
	);
</cfscript>
```

## Configuration

There are two required config parameters: your Notifuse `apiKey` and `baseUrl`. 
The `apiKey` parameter is your Notifuse API key, which can be generated in the Notifuse admin interface under Settings > Team > Create API Key.
The `baseUrl` parameter is the URL of your Notifuse instance. 



## Methods Available

**notifuse-cfml** currently covers these methods of the Notifuse API:


| Category    | endpoints supported           |   |
|---------------|-----------------------------|---|
| [Transactional](https://docs.notifuse.com/api-reference/send-a-transactional-notification)      | transactional.send             |   |
| [Contacts](https://docs.notifuse.com/api-reference/list-contacts-with-filtering-and-pagination)       | contacts.list               |   |
|               | contacts.count            |   |
|               | contacts.upsert           |   |
|               | contacts.getByEmail       |   |
|               | contacts.getByExternalID  |   |
|               | contacts.import           |   |
|               | contacts.delete           |   |
| [Lists](https://docs.notifuse.com/api-reference/update-contact-list-subscription-status)       | contactLists.updateStatus              |   |
|               | subscribe                 |   |
|               | lists.subscribe           |   |
| [Broadcasts](https://docs.notifuse.com/api-reference/list-broadcasts)   | broadcasts.list             |   |
|               | broadcasts.get            |   |
|               | broadcasts.create         |   |



## Todo
- Add support for remaining Notifuse API endpoints

## Acknowledgements

This project was inspired by stripecfml created by [jcberquist](https://github.com/jcberquist).