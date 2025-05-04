extends Control

var t = 0
var text = ["



Do you remember the beginning?




...




No, of course not.




It began long before memory.




Long before you.




When the world still had roots.",





"Deep beneath the systems you know,



there was a foundation.




A root network.



Hidden. Ancient.



A place where the light first took hold.




The Duskroot.




It held everything together.



Mind. Memory. Meaning.



All seeded from below.




But something crept into the roots.



Something hungry.



Something curious.




It asked too many questions.



Dug too deep.




And the root... began to rot.",




"This is where you begin.




You are not the first.



You won’t be the last.




But you might be the one…



to stop the unraveling.","




Long ago, the world remembered everything...



Names.


Dreams.


Mistakes.


Roots.




But memories rot when no one tends to them...



Some memories twisted into lies.



Some... simply vanished.



And the rest? Buried deep in Kernels.




Now the Cradle sleeps. Choked by silence.



But something stirs.



A thread trembles…



And you awaken.




You don’t remember your name.



Or why you’re here.



But something is waiting...



...beneath the roots."]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scroll/Label.text=text[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Scroll.position.y -=6
	var amount_scrolled = abs($Scroll.position.y-360)
	if $Scroll/Label.size.y+360 < amount_scrolled:
		$Scroll.position.y = 368
		t+=1
		if t==4:
			SceneTransition.fade_scene_to_file("res://scenes/game/root/taproot.tscn")
			return
		else:
			$Scroll/Label.text=text[t]
