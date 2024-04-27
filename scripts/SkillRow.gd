extends Control

var skill_name: String


func get_skill_name() -> String:
	return skill_name


func set_skill_name(new_skill_name: String):
	skill_name = new_skill_name
	$SkillName.set_text(new_skill_name)


func set_skill_points(skill_points):
	$HairPoints.set_text(str(skill_points.get(str(ArmorData.Category.HAIR), "")))
	$BodyPoints.set_text(str(skill_points.get(str(ArmorData.Category.BODY), "")))
	$ArmsPoints.set_text(str(skill_points.get(str(ArmorData.Category.ARMS), "")))
	$WaistPoints.set_text(str(skill_points.get(str(ArmorData.Category.WAIST), "")))
	$LegsPoints.set_text(str(skill_points.get(str(ArmorData.Category.LEGS), "")))
	$TotalPoints.set_text(str(skill_points.total))
