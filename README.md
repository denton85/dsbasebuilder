# dsbasebuilder

This is a basebuilding addon for Godot, meant to be fully customizable.
You can add your own building components, meaning it doesn't just have to be used for base-building.

Structure:
- Component: This is your wall, foundation, ceiling, etc. It should inherit from on of the base classes.
- Connection: Instantiate these inside your component scenes, and use the exported array to tell the connection what components it should "accept" to be built on it.
- BaseBuilder scene: Instantiate this on your player however you wish, it has a detection zone to detect Connection points. 

BaseBuilder Scene:
	This is how you can build with components in your scene. It detects Connection Points using the ConnectionDetect area3d.
	The BaseBuilder node holds a dictionary of scenes (your custom build components). They have a name and a scene you drag into them.
	The BaseBuilder script has an ENUM called COMPONENT_REGISTRY. Paste the name you gave your component into the enum. 
	If the dictionary name and the enum name don't match, it will error.

Base Component Classes: (these may introduce extra properties, currently none)
- BaseBuildComponent
- FoundationComponent
- WallComponent
- CeilingComponent

Creating a new building component:
Make a scene, in the script you can extend one of the base classes.
Drag the scene into your BaseBuilder exported array of components. 
Give it a name, and then go to the enum called COMPONENT_REGISTRY
and copy the same name there. It will error if it doesn't match.

Throw some connections in there, and assign those connections to 
accept other scenes. The "accepts" array is based off the enum
you just edited, which is how the Connections are able to define 
what components they accept.

UI:
	The UI here is just an example. All it does in this example
	is make buttons out the components inside of the BaseBuilder dictionary.
	The buttons then change the "current_build_component" and 
	"current_build_component_id", and then emit a signal with the 
	current_build_component_id. I'mhoping to clean this up even further,
	but for the most part the UI and how it hooks up is up to you.
