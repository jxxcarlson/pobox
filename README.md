
# PO Box

PO Box is an experiment in setting up a mail box system of communication among Elm apps living in the same web page, e.g., different tabs thereof. Local storage is used as a post office, with a mail box for each app.  Apps are distinguished by an identifier, e.g. `"aaa123"` for  one app, and `"xxx456"` for another.  Each app sets up an entry in local storage, where the key is the app identifier and the value is a string representing a list of JSON-encoded Elm values of type `Message`:

```
type alias Message =
    { to : String
    , from : String
    , subject : String
    , body : String
    , timeSent : Time.Posix
    }
```

The `subject` field can be something generic like "message," of it can be used as a key for determining what action the receiving app takes on the information contained in the message `body`.  Of course, the `Message` type can be customized according to need.

Ports are used both to send and receive messages.  In the current version, an app implementing PO Box asks the post office to send any waiting messages once per clock tick (one second).  When this operation is carried out, the app's mail box is cleared out.

## Demo

The source code for this experiment is at https://github.com/jxxcarlson/pobox

To play with PO Box, do `sh make.sh`, then click on `index1.html`  and `index2.html`.  Your browser should be configues so that these open up in different tabs of the same browser window.  Try sending messages from each app, and see what happens in the other app.

In this demo, all the app does on receipt of a new message is add it to its list of messages.

In this demo, both apps are identical. They don't have to be.

## Comments

I'd very much appreciate comments, e.g., is this is viable concept?
