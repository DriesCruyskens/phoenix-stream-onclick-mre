## Issue

https://github.com/phoenixframework/phoenix_live_view/issues/2940

the fix is not ideal since it requires to reattach the listeners for all markers everytime selected marker is changed. phx-update='append' is more efficient in that regard.

# phx-update=stream does not trigger onClick events

Hello,

I came across a weird behaviour while refactoring one of my applications from the old 'temporary assigns' to the new 'stream' api. I'm not sure if it's an actual bug or not but it is definitely preventing me using the new streams api.

For some reason the click event is not triggered when clicking on elements with `phx-update=stream`.

I have constructed a minimal reproducable example that shows this behaviour. It consist of a single liveview page and some leaflet.js javascript code. Most javascript code is bootstrap except one important function:

- leaflet-map.js: connectedCallback()

To replicate the weird behaviour, simply change `phx-update=stream` to  `phx-update=append` or remove the attribute completely (in `index.html.heex`). As you can see in the browser logs the original leaflet html element does not receive the 'click' event when streams are enabled on the parent. Here's a summary of the observed behavior:

phx-update=append: both leafletmarker and the original element's click event are triggered on click (bind is inside the hook)
phx-update=stream: only leaflet marker click event is triggered

I hope this issue is not too esoteric and I would appreciate it greatly if someone would be able to take a look at this.

Thanks again to everyone working Phoenix LiveView!

