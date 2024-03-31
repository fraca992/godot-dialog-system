@tool

extends CanvasLayer
@export_category("General")
@export_range(0, 1) var windowCoverage : float = 0.5

@export_category("Portrait")
@export_range(0, 1) var l_PortraitMargin : float = 0.014
@export var portraitBackgroundStyle : StyleBoxFlat
@export var portraitTextureStyle : StyleBoxTexture
@export var portraits : Array[Texture2D]

@export_category("DialogBox")
@export var dialogBackgroundStyle: StyleBoxFlat
@export_range(0, 1) var dialogBoxMargin : float = 0.1
@export var indicatorTexture: Texture2D
@export_range(0, 1) var indicatorScaling : float = 0.1

@export_category("TextLabels")
@export var nameFont : FontFile
@export var textFont : FontFile
@export var lineNumber : int = 3
@export var nameText : String = "Name"
@export_multiline var dialogText : String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean rhoncus ultrices libero malesuada maximus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum ullamcorper sodales libero, eget varius lorem maximus at. Vivamus faucibus urna quis dui sodales fringilla. Etiam mollis eu tortor quis vulputate. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam fermentum nibh id purus volutpat condimentum. Aenean at dignissim diam, nec lobortis orci. Morbi lacinia ipsum sed dapibus rhoncus. Vestibulum in cursus nisl."

# Called when the node enters the scene tree for the first time.
func _ready():
	var windowSize : Vector2
	if Engine.is_editor_hint():
		windowSize = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width")
							,ProjectSettings.get_setting("display/window/size/viewport_height"))
	else:
		windowSize = DisplayServer.window_get_size(0)
	Init_MonitorOverlay(windowSize, windowCoverage)
	Init_Portrait(windowSize)
	Init_DialogBox(windowSize)
	notify_property_list_changed()

#Initialize ARC_Monitor
func Init_MonitorOverlay(p_WindowSize, p_WindowCoverage) -> void:
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
func Init_Portrait(p_windowSize) -> void:
	var MC_Portrait : MarginContainer = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait")
	MC_Portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
	MC_Portrait.add_theme_constant_override("margin_left", p_windowSize[0] * l_PortraitMargin)

	var ARC_Portrait : AspectRatioContainer = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait/ARC_Portrait")
	ARC_Portrait.set_alignment_horizontal (AspectRatioContainer.ALIGNMENT_BEGIN)

	var PC_Background : Panel = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait/ARC_Portrait/PC_PortraitBackground")
	PC_Background.add_theme_stylebox_override("panel", portraitBackgroundStyle)
	
	var PC_Portrait : Panel = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_Portrait/ARC_Portrait/PC_PortraitTexture")
	portraitTextureStyle.texture = portraits[1]
	PC_Portrait.add_theme_stylebox_override("panel", portraitTextureStyle)
	
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next.
	return

#Initialize DialogBox nodes
func Init_DialogBox(p_windowSize) -> void:
	var MC_DialogBox : MarginContainer = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox")
	MC_DialogBox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var PC_Background : Panel = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground")
	PC_Background.add_theme_stylebox_override("panel", dialogBackgroundStyle)
	
	MC_DialogBox.add_theme_constant_override("margin_left", p_windowSize[0] * dialogBoxMargin)
	MC_DialogBox.add_theme_constant_override("margin_right", p_windowSize[0] * dialogBoxMargin)
	MC_DialogBox.add_theme_constant_override("margin_bottom", p_windowSize[0] * dialogBoxMargin)
	
	#Initialize MC_Name
	var  MC_Name : MarginContainer = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Name")
	var backgroundBorderMargins : Array[float] = [PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_LEFT)
											, PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_TOP)
											, PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_RIGHT)
											, PC_Background.get_theme_stylebox("panel").get_border_width(SIDE_BOTTOM)]
	MC_Name.set_anchor_and_offset(SIDE_LEFT,0,0)
	MC_Name.set_anchor_and_offset(SIDE_TOP,0,0)
	MC_Name.set_anchor_and_offset(SIDE_RIGHT,1,0)
	MC_Name.set_anchor_and_offset(SIDE_BOTTOM,0.3,0)
	MC_Name.set_h_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Name.set_v_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Name.add_theme_constant_override("margin_left", int(2 * backgroundBorderMargins[0]))
	MC_Name.add_theme_constant_override("margin_top", int(2 * backgroundBorderMargins[1]))
	MC_Name.add_theme_constant_override("margin_right", int(2 * backgroundBorderMargins[2]))
	MC_Name.add_theme_constant_override("margin_bottom", int(2 * backgroundBorderMargins[3]))
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next
	
	#Initialize MC_Dialog
	var MC_Dialog : MarginContainer = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Dialog")
	MC_Dialog.set_anchor_and_offset(SIDE_LEFT,0,0)
	MC_Dialog.set_anchor_and_offset(SIDE_TOP,0.3,0)
	MC_Dialog.set_anchor_and_offset(SIDE_RIGHT,1,0)
	MC_Dialog.set_anchor_and_offset(SIDE_BOTTOM,1,0)
	MC_Dialog.set_h_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Dialog.set_v_grow_direction(Control.GROW_DIRECTION_BOTH)
	MC_Dialog.add_theme_constant_override("margin_left", 2 * backgroundBorderMargins[0])
	MC_Dialog.add_theme_constant_override("margin_top", 2 * backgroundBorderMargins[1])
	MC_Dialog.add_theme_constant_override("margin_right", 2 * backgroundBorderMargins[2])
	MC_Dialog.add_theme_constant_override("margin_bottom", 2 * backgroundBorderMargins[3])
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next
	
	Init_DialogIndicator(MC_DialogBox)
	Init_DialogTextLabels()
	return

#Initialize the bouncing indicator
func Init_DialogIndicator(p_MC_DialogBox : MarginContainer) -> void:
	var dialogIndicator : Sprite2D = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/DialogIndicator")
	dialogIndicator.set_texture(indicatorTexture)
	var dialogBoxSize : Vector2 = p_MC_DialogBox.get_size()
	
	# set the scaling for the texture. indicator texture should be square
	var scaling : float = ( dialogBoxSize[1] * indicatorScaling) / dialogIndicator.get_rect().size[0] # scaling the indicator to about 10% of vertical size
	dialogIndicator.set_scale(Vector2(scaling,scaling))

	# set the position for the indicator
	var xPos : float = 0.97 * dialogBoxSize[0]
	var yPos : float = 0.80 * dialogBoxSize[1]
	dialogIndicator.set_position(Vector2(xPos,yPos))
	dialogIndicator.set_z_index(1) #ensures the indicator is always on top
	
	## set animation
	var indicatorAnimationPlayer : AnimationPlayer = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/DialogIndicator/IndicatorPlayer")
	var library : AnimationLibrary = load("res://Themes/DialogSystem_AnimationLibrary.res")
	var bouncingAnimation := Animation.new()
	var trackIndex : int = bouncingAnimation.add_track(Animation.TYPE_VALUE)
	var bounce : float = 0.03 * dialogBoxSize[1]
	
	bouncingAnimation.track_set_path(trackIndex, ".:position:y")
	bouncingAnimation.track_insert_key(trackIndex,0,dialogIndicator.get_position()[1],0.5)
	bouncingAnimation.track_insert_key(trackIndex,0.5,dialogIndicator.get_position()[1] + bounce,-2)
	bouncingAnimation.set_length(1)
	bouncingAnimation.set_loop_mode(Animation.LOOP_LINEAR)
	library.add_animation("bounce",bouncingAnimation) # the library still needs to be added as a resource
	indicatorAnimationPlayer.play("DialogSystem_AnimationLibrary/bounce")
	
	await get_tree().create_timer(0.05).timeout #Godot applies change in size after one frame: adding a pause here to receive the correct size next.
	return

#Initialize the text labels
func Init_DialogTextLabels() -> void:
	## Initialize TextName label
	# initial settings
	var nameLabel : RichTextLabel = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Name/TextName")
	nameLabel.scroll_active = false
	nameLabel.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
	
	# pushing initial name context
	PrintLabel(nameLabel, nameFont, nameLabel.size[1] + 10, nameText)
	
	##Initializa TextDialog label
	# initial settings
	var textLabel : RichTextLabel = get_node("ARC_MonitorOverlay/VBC_DialogBoxStructure/MC_DialogBox/PC_DialogBackground/MC_Dialog/TextDialog")
	textLabel.scroll_active = false
	textLabel.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
	
	# pushing initial dialog context
	var dialogTextSize : int = int(textLabel.size[1] / lineNumber)
	PrintLabel(textLabel, textFont, dialogTextSize, dialogText)
	
	# splitting text if too long
	var splitChar : String = "_"
	while textLabel.get_line_count() > lineNumber:
		if dialogText.contains("."):
			splitChar = "."
		elif dialogText.contains(","):
			splitChar = ","
		elif dialogText.contains(" "):
			splitChar = " "
		else:
			splitChar = ""
		dialogText = dialogText.rsplit(splitChar, false, 1)[0]
		
		PrintLabel(textLabel, textFont, dialogTextSize, dialogText)
	# printing error if clean split (on period) is not possible
	match splitChar:
		",":
			printerr("While cropping dialog text couldn't find \".\". used \",\" instead. Consider increasing number of lines or rewriting dialog")
		" ":
			printerr("While cropping dialog text couldn't find \".\" or \",\". used space instead. Consider increasing number of lines or rewriting dialog")
		"":
			printerr("impossible to split text cleanly! Final word may have been cut")
	
	return

#Util to print text to label
func PrintLabel(label:RichTextLabel, font:FontFile, size:int, text:String) -> void:
	label.clear() # altough official documentation says that clear does not clear text, it is not true, at least with add_text function; editing the text property to empty string ("") does not clear the text. did not test if AUTOWRAP fault.
	label.push_context()
	label.push_font(font, size)
	label.add_text(text)
	return
