extends RichTextLabel

func menu_text():
	self.parse_bbcode("[center][wave amp=50 freq=2]" + text + "[/wave][/center]")
func menu_text_off():
	self.parse_bbcode("[center][wave amp=10 freq=1]" + text + "[/wave][/center]")

func drop_text():
	self.parse_bbcode("[center][wave amp=30 freq=1.5][rainbow freq=0.75 sat=10 val=20]" + text + 
	"[/rainbow][/wave][/center]")
func drop_text_off():
	self.parse_bbcode("[center][wave amp=15 freq=1.5]" + text + "[/wave][/center]")

