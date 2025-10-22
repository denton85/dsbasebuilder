# dsbasebuilder

This is a basebuilding addon for Godot, meant to be fully customizable.
You can add your own building components, meaning it doesn't just have to be used for base-building.

Structure:
- Component: This is your wall, foundation, ceiling, etc. It should inherit from on of the base classes.
- Connection: Instantiate these inside your component scenes, and use the exported array to tell the connection what components it should "accept" to be built on it.
- BaseBuilder scene: Instantiate this on your player however you wish, it has a detection zone to detect Connection points. Drag your scenes into the exported components dictionary and give them a simple name.
- BaseBuilder script: Currently, any scene you add to the BaseBuilder node needs to have its name copied into the enum in the BaseBuilder script, called COMPONENT_REGISTRY. This will hopefully change in the future to make things easier.


Base Classes: (these may introduce extra properties, currently none)
- BaseBuildComponent
- FoundationComponent
- WallComponent
- CeilingComponent
