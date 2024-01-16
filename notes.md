# The LiveView Loop

- Liveview manages the state of a page in a long lived process that loops through a set of steps again and again(After all, it is a genserver).
- The LV flow:

  1. LV will receive events(eg clicks, scrolls etc)
  2. Based on the events, you will write your functions to transform your state.
  3. After state change, LV will re-render only the portions of the page that changed.
  4. After rendering, LV gain will wait for events, and go back to step 1.

  ## The LiveView Lifecycle

  - Liveview allows us to think about Single Page Applications(SPAs) in terms of a shared, evolving state instead of isolate requests/responses.
  - The state of a liveview is managed by a data structure called the **socket**.(Therefore, if you see a socket anywhere, recognize that it is the data that constitutes the state of the liveview) (see Phoenix.LiveView.Socket.**struct**)
  - Every running LV keeps data describiing state in a socket.
  - You establish and update the state by interacting with the :assigns map in the socket struct.

  A LV lifecycle starts from the router where a live route is defined.
  Live routes are defined with a call to live/3 and map an incoming HTTP request to a specified liveview process.

  The process will initialize the state b setting up socket info in a function mount/3(this is your constructor), then render the state in some markup for the client in render/1(this is your convertor). (This initial process is a normal HTTP GET request).

  The connection is then upgraded to a websocket connection and calls mount and render again to render the dynamic portions of the page.

  The LV can now receive, change state and render state again.

  Since elixir and functional programming in general is all about transforming data, you can think of the above as a pipeline:

  construct |> reduce |> convert
  The constructor being mount/3 and handle_params/3 (initializing data)
  The reducer being handle_events / handle_info as they change the socket to a new version of the socket
  The convertor being render/1, as it converts the socket to completely new data type.
