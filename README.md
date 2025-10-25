# dsbasebuilder

This is a basebuilding addon for Godot, meant to be fully customizable.
You can add your own building components, meaning it can be useful in any game where you need to add scenes to each other in a structured way in 3D space.

Future Plans:

- Add rotation
- Add previews of the component scenes so you can see what component you have active in front of you.
- Add passing animations to functions? (pass in a "build" or "deconstruct" animation)
- Make it so you can't build the same component on top of itself (turn off Connections when they are already have a component. Need to find a good way to do this while keeping it flexible and customizable.)

Structure of this addon:

- COMPONENT_TYPE_REGISTRY - This is in the BaseBuilder script. It contains the "Component types". These define what components connections can accept in their own "accepts" array. If you edit this, do not remove the "deconstruct" type, or things will error. Otherwise, just make sure you assign a default integer value to whatever types you add. Try not to reuse an integer value of a type you previously deleted, unless you want to have to go back and change a bunch of Connections. Just use a new integer every time.
- Component: This is a scene. It's your wall, foundation, ceiling, etc. It should inherit from on of the base classes.
- DSComponentResource: this is the resource that holds you component scene and it's "type", so Connections know whether a component is allowed to be connected to them or not.
- Connection: Instantiate these inside your component scenes, and use the exported array to tell the connection what component types it should accept (ie, Wall, Ceiling, etc. These are from the COMPONENT_TYPE_REGISTRY, which you can edit to add new component types if needed).
- BaseBuilder scene: Instantiate this on your player however you wish, it has a detection zone to detect Connection points. The shape of the zone can be changed in case you aren't doing a FPS and want to attach it to something else.

BaseBuilder Scene:
This is how you can build with components in your scene. It detects Connection Points using the ConnectionDetect area3d.
The BaseBuilder node holds a dictionary of resources (your custom build components). They have a name and a resource which you create for each new component (called DSComponentResource).
The BaseBuilder script has an ENUM called COMPONENT_TYPE_REGISTRY. Make sure your component resource has the correct Type associated with it, so it can only be added to the correct Connections.

Base Component Classes: (these may introduce extra properties, currently none)

- BaseBuildComponent
- FoundationComponent
- WallComponent
- CeilingComponent

Creating a new building component:
Make a scene, in the script you can extend one of the base classes.
Create a new DSComponentResource (with title, type, and the scene of your component). 
Go to your exported "build_resources" dictionary and add a new item, giving it a name and assigning your new resource to it.

Throw some connections in there, and assign those connections to
accept the correct component type (which comes from the COMPONENT_TYPE_REGISTRY enum in the BaseBuilder script)

UI:
The UI here is just an example. All it does in this example
is make buttons out the components inside of the BaseBuilder dictionary.
The buttons just emit a signal to make sure the Connections know what type of 
component is currently in use (from the COMPONENT_TYPE_REGISTRY enum).
