extends Control


func set_skill_info(points: int, skill_name: String, add_comma: bool):
	if points == 0:
		$SkillPoints.hide()
	else:
		$SkillPoints.set_text(str(points))

	$SkillName.set_text(skill_name)

	if not add_comma:
		$Separator.hide()
