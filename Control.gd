extends CanvasLayer

@export var windowCoverage = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	var windowSize = DisplayServer.window_get_size(0)
	Init_DialogStructure(windowSize, windowCoverage)
	Init_Portrait(windowSize)
	Init_DialogBox()


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func Init_DialogStructure(p_windowSize, p_windowCoverage):
	"""
	# Initializing ARC_DialogStructure node
	"""
	var containerSize := Vector2i(p_windowSize[0],p_windowSize[1] * p_windowCoverage)
	var containerPosition := Vector2i(0,p_windowSize[1] - containerSize[1])
	var containerAspectRatio = (containerSize[0] as float)/(containerSize[1] as float)
	var AspectRatioCont = get_node("ARC_DialogStructure")
	
	AspectRatioCont.set_anchors_preset(Control.PRESET_FULL_RECT)
	AspectRatioCont.ratio = containerAspectRatio
	AspectRatioCont.set_size(containerSize)
	AspectRatioCont.set_position(containerPosition)
	return
	
func Init_Portrait(p_windowSize):
	var MC_Portrait = get_node("ARC_DialogStructure/VBC_DialogStructure/MC_Portrait")
	MC_Portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
	MC_Portrait.add_theme_constant_override("margin_left", p_windowSize[0]/72) # gives 20pixel for 1440 window width. expose this?

	var ARC_Portrait = get_node("ARC_DialogStructure/VBC_DialogStructure/MC_Portrait/ARC_Portrait")
	ARC_Portrait.set_alignment_horizontal (AspectRatioContainer.ALIGNMENT_BEGIN)

	var PC_Background = get_node("ARC_DialogStructure/VBC_DialogStructure/MC_Portrait/ARC_Portrait/PC_PortBackground")
	PC_Background.add_theme_stylebox_override("panel", load("res://Themes/Portrait_Background.tres"))
	
	var PC_Portrait = get_node("ARC_DialogStructure/VBC_DialogStructure/MC_Portrait/ARC_Portrait/PC_PortTexture")
	var textureStyle = load("res://Themes/Portrait_Texture.tres")
	textureStyle.texture = load("res://Portraits/portrait_happy_cropped.png") #expose this?
	PC_Portrait.add_theme_stylebox_override("panel", textureStyle)
	

func Init_DialogBox():
	var MC_DialogBox = get_node("ARC_DialogStructure/VBC_DialogStructure/MC_DialogBox")
	MC_DialogBox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# expose margins?
	
	var PC_Background = get_node("ARC_DialogStructure/VBC_DialogStructure/MC_Portrait/ARC_Portrait/PC_DialBackground")
	PC_Background.add_theme_stylebox_override("panel", load("res://Themes/DialogBox_Background.tres"))
	
	
	"""
	## Initializa DialogBox indicator
	"""
	
	
	"""
	## Initializa DialogName label
	"""
	
	
	"""
	## Initializa DialogText label
	"""
	var TextLabel = get_node("ARC_DialogStructure/VBC_DialogStructure/MC_DialogBox/PC_DialogBox/Text")
	var myFont = load("res://Fonts/pixelletters-font/Pixellettersfull-BnJ5.ttf")
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next
	var DialogBoxHeight = TextLabel.size[1]
	var lineNumber = 3 # expose this
	var dialogueText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sem nunc, dignissim sed elit nec, consectetur mattis ex. Integer maximus nisl dui, at luctus est consequat sed. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent pellentesque metus vitae ante sollicitudin gravida."
	
	TextLabel.text = "" # resetting content, this also clears the tag stack
	TextLabel.scroll_active = false
	TextLabel.push_context() # pushing tags under a context call, to facilitate popping and switching
	TextLabel.push_font(myFont, DialogBoxHeight/ lineNumber)
	TextLabel.add_text(dialogueText)

	# resize bouncing triangle??
	return
