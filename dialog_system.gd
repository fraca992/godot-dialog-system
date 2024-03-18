#@tool

extends CanvasLayer
@export_category("General")
@export_range(0, 1) var windowCoverage := float(0.5)

@export_category("Portrait")
@export_range(0, 1) var l_PortraitMargin := float(0.014)
@export var portraitBackgroundStyle: StyleBoxFlat
@export var portraitTextureStyle: StyleBoxTexture
@export var portraits: Array[Texture2D]

@export_category("DialogBox")
@export var dialogBackgroundStyle: StyleBoxFlat
@export_range(0, 1) var dialogBoxMargin := float(0.01)
@export var indicatorTexture: Texture2D
@export_range(0, 1) var indicatorScaling := float(0.1)

@export_category("TextLabels")
@export var nameFont : FontFile
@export var textFont : FontFile
@export var lineNumber := int(3)
@export var nameText := String("Name")
@export_multiline var dialogText := String("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus ultrices libero malesuada maximus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum ullamcorper sodales libero, eget varius lorem maximus at. Vivamus faucibus urna quis dui sodales fringilla. Etiam mollis eu tortor quis vulputate. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam fermentum nibh id purus volutpat condimentum. Aenean at dignissim diam, nec lobortis orci. Morbi lacinia ipsum sed dapibus rhoncus. Vestibulum in cursus nisl.")

# Called when the node enters the scene tree for the first time.
func _ready():
	var windowSize = DisplayServer.window_get_size(0)
	Init_MonitorOverlay(windowSize, windowCoverage)
	Init_Portrait(windowSize)
	Init_DialogBox(windowSize)


#Initialize ARC_Monitor
func Init_MonitorOverlay(p_WindowSize, p_WindowCoverage):
	#the size of the overlay depends on the coverage percentage p_WindowCoverage
	var containerSize := Vector2i(p_WindowSize[0],p_WindowSize[1] * p_WindowCoverage)
	var containerPosition := Vector2i(0,p_WindowSize[1] - containerSize[1])
	var containerAspectRatio = (containerSize[0] as float)/(containerSize[1] as float)
	var aspectRatioCont = get_node("ARC_MonitorOverlay")
	
	aspectRatioCont.set_anchors_preset(Control.PRESET_FULL_RECT)
	aspectRatioCont.set_ratio(containerAspectRatio)
	aspectRatioCont.set_size(containerSize)
	aspectRatioCont.set_position(containerPosition)
	
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next
	return

#Initialize Portrait nodes
func Init_Portrait(p_windowSize):
	var MC_Portrait = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait")
	MC_Portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
	MC_Portrait.add_theme_constant_override("margin_left", p_windowSize[0] * l_PortraitMargin)

	var ARC_Portrait = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait/ARC_Portrait")
	ARC_Portrait.set_alignment_horizontal (AspectRatioContainer.ALIGNMENT_BEGIN)

	var PC_Background = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait/ARC_Portrait/PC_PortraitBackground")
	PC_Background.add_theme_stylebox_override("panel", portraitBackgroundStyle)
	
	var PC_Portrait = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait/ARC_Portrait/PC_PortraitTexture")
	portraitTextureStyle.texture = portraits[1] #TODO: add functionality to change this
	PC_Portrait.add_theme_stylebox_override("panel", portraitTextureStyle)
	
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next.
	return

#Initialize DialogBox nodes
func Init_DialogBox(p_windowSize):
	var MC_DialogBox = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox")
	MC_DialogBox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var PC_Background = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground")
	PC_Background.add_theme_stylebox_override("panel", dialogBackgroundStyle)
	
	MC_DialogBox.add_theme_constant_override("margin_left", p_windowSize[0] * dialogBoxMargin)
	MC_DialogBox.add_theme_constant_override("margin_right", p_windowSize[0] * dialogBoxMargin)
	MC_DialogBox.add_theme_constant_override("margin_bottom", p_windowSize[0] * dialogBoxMargin)
	
	#Initialize MC_Name
	var  MC_Name = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Name")
	var dialogBoxMargins = [PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_LEFT), PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_TOP)
	, PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_RIGHT), PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_BOTTOM)]
	MC_Name.set_anchor_and_offset(SIDE_LEFT,0,0)
	MC_Name.set_anchor_and_offset(SIDE_TOP,0,0)
	MC_Name.set_anchor_and_offset(SIDE_RIGHT,1,0)
	MC_Name.set_anchor_and_offset(SIDE_BOTTOM,0.3,0)
	MC_Name.set_h_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Name.set_v_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Name.add_theme_constant_override("margin_left", 2 * dialogBoxMargins[0])
	MC_Name.add_theme_constant_override("margin_top", 2 * dialogBoxMargins[1])
	MC_Name.add_theme_constant_override("margin_right", 2 * dialogBoxMargins[2])
	MC_Name.add_theme_constant_override("margin_bottom", 2 * dialogBoxMargins[3])
	
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next
	
	#Initialize MC_Dialog
	var MC_Dialog = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Dialog")
	MC_Dialog.set_anchor_and_offset(SIDE_LEFT,0,0)
	MC_Dialog.set_anchor_and_offset(SIDE_TOP,0.3,0)
	MC_Dialog.set_anchor_and_offset(SIDE_RIGHT,1,0)
	MC_Dialog.set_anchor_and_offset(SIDE_BOTTOM,1,0)
	MC_Dialog.set_h_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Dialog.set_v_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Dialog.add_theme_constant_override("margin_left", 2 * dialogBoxMargins[0])
	MC_Dialog.add_theme_constant_override("margin_top", 2 * dialogBoxMargins[1])
	MC_Dialog.add_theme_constant_override("margin_right", 2 * dialogBoxMargins[2])
	MC_Dialog.add_theme_constant_override("margin_bottom", 2 * dialogBoxMargins[3])
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next
	
	Init_DialogIndicator(MC_DialogBox)
	Init_DialogTextLabels(MC_DialogBox)
	return

func Init_DialogIndicator(p_MC_DialogBox):
	var dialogIndicator = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/DialogIndicator")
	dialogIndicator.set_texture(indicatorTexture)
	var dialogBoxSize = p_MC_DialogBox.get_size()
	
	# set the scaling for the texture. indicator texture should be square
	var scaling = (( dialogBoxSize[1] as float * indicatorScaling) / dialogIndicator.get_rect().size[0]) # scaling the indicator to about 10% of vertical size
	dialogIndicator.set_scale(Vector2(scaling,scaling))

	# set the position for the indicator
	var xPos:= int(0.97 * dialogBoxSize[0])
	var yPos:= int(0.85 * dialogBoxSize[1])
	dialogIndicator.set_position(Vector2(xPos,yPos))
	dialogIndicator.set_z_index(1) #ensures the indicator is always on top
	
	# set animation
	var indicatorAnimationPlayer = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/DialogIndicator/IndicatorPlayer")
	var library = load("res://Themes/DialogSystem_AnimationLibrary.res")
	var bouncingAnimation = Animation.new()
	var trackIndex = bouncingAnimation.add_track(Animation.TYPE_VALUE)
	var bounce = int(0.05 * dialogBoxSize[1])
	bouncingAnimation.track_set_path(trackIndex, ".:position:y")
	bouncingAnimation.track_insert_key(trackIndex,0,dialogIndicator.get_position()[1],1)
	bouncingAnimation.track_insert_key(trackIndex,0.5,dialogIndicator.get_position()[1] + bounce,0.25)
	bouncingAnimation.set_loop_mode(Animation.LOOP_PINGPONG)
	library.add_animation("bounce",bouncingAnimation) # the library still needs to be added as a resource
	indicatorAnimationPlayer.play("DialogSystem_AnimationLibrary/bounce")
	
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next.
	return

func Init_DialogTextLabels(_p_MC_Background): #remove parameter?
	## Initialize TextName label
	# initial settings
	var nameLabel = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Name/TextName")
	nameLabel.scroll_active = false
	nameLabel.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
	
	# pushing initial name context
	var nameLabelHeight = nameLabel.size[1]
	nameLabel.text = "" # resetting content, this also clears the tag stack
	nameLabel.push_context() # pushing tags under a context call, to facilitate popping and switching
	nameLabel.push_font(nameFont, nameLabelHeight + 10)
	nameLabel.add_text(nameText)
	
	
	##Initializa TextDialog label
	# initial settings
	var textLabel = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Dialog/TextDialog")
	textLabel.scroll_active = false
	textLabel.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
	
	# pushing initial name context
	var textLabelHeight = textLabel.size[1]
	textLabel.clear() # altough official documentation says that clear does not clear text, it is not true, at least with add_text function; editing the text property to empty string ("") does not clear the text. did not test if AUTOWRAP fault.
	textLabel.push_context() # pushing tags under a context call, to facilitate popping and switching
	textLabel.push_font(textFont, (textLabelHeight/ lineNumber))
	textLabel.add_text(dialogText)
	
	var new_DialogText = dialogText
	while textLabel.get_line_count() > lineNumber:
		var splitChar = ""
		if new_DialogText.contains("."):
			splitChar = "."
		elif new_DialogText.contains(","):
			splitChar = ","
			printerr("While cropping dialog text couldn't find \".\". used \",\" instead. Consider increasing number of lines or rewriting dialog")
		elif new_DialogText.contains(" "):
			splitChar = " "
			printerr("While cropping dialog text couldn't find \".\" or \",\". used space instead. Consider increasing number of lines or rewriting dialog")
		else:
			splitChar = ""
			printerr("what the heck (wo)man/enby...") #TODO: move the printing error after while
		
		var splitText = new_DialogText.rsplit(splitChar, false, 1)
		new_DialogText = splitText[0]
		
		# TODO: needs to be a function...
		textLabel.clear()
		textLabel.push_context() # pushing tags under a context call, to facilitate popping and switching
		textLabel.push_font(textFont, (textLabelHeight/ lineNumber))
		textLabel.add_text(new_DialogText)

	return
