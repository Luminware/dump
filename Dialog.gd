extends ColorRect

export(float) var textSpeed = 0.05

var dialog
export var dialogPath = ""
var phraseNum = 0
var finished = false

func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
	
func _process(delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept") :
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
	
func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), "File path does not exist.")
	
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
		get_parent().queue_free()
		get_tree().paused = false
		Globals.dialogActive = false
		Globals.summonUNITY = true
		return
		
	finished = false
	
	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	var f = File.new()
	var img = dialog[phraseNum]["Name"] + dialog[phraseNum]["Emotion"] + ".PNG"
	if f.file_exists(img):
		$Portrait.texture = load(img)
	else:
		$Portrait.texture = null
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
		
	finished = true
	phraseNum += 1
	return
