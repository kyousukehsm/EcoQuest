# Loading.gd
extends Control

@onready var progress_bar = $ProgressBar
@onready var fact_label = $FactContainer/FactLabel
@onready var fact_timer = $FactTimer
@onready var loading_timer = $LoadingTimer

var environmental_facts = [
	# Global Environmental Facts
	"🌡️ The Earth's average temperature has increased by 1.1°C since pre-industrial times",
	"🌊 8 million tons of plastic enter our oceans every year",
	"🌳 A single tree can absorb 48 pounds of CO2 per year",
	"💧 The average American uses 82 gallons of water per day",
	"♻️ Only 9% of plastic ever produced has been recycled",
	"🐝 75% of the world's food crops depend on pollinators",
	"🌍 We lose 137 species of plants and animals every day due to deforestation",
	"⚡ LED bulbs use 90% less energy than traditional bulbs",
	"🚗 An average car emits 4.6 metric tons of CO2 per year",
	"🏭 The last seven years have been the warmest on record",
	"🌿 Rainforests absorb 30% of our CO2 emissions",
	"🗑️ The average person generates 4.4 pounds of waste per day",
	"🚰 844 million people lack access to clean water",
	"🌱 20% of the Amazon rainforest has been lost in the past 50 years",
	"💨 Air pollution causes 7 million premature deaths annually",
	
	# Agusan del Sur Environmental Facts
	"🌿 Agusan Marsh Wildlife Sanctuary covers over 14,000 hectares of wetlands",
	"🐊 Agusan Marsh is home to the Philippine crocodile, a critically endangered species",
	"🦅 Over 200 bird species can be found in Agusan del Sur's wetlands",
	"🌳 Agusan del Sur contains some of the Philippines' last old-growth forests",
	"💧 Agusan River is the third largest river basin in the Philippines",
	"🦊 The Philippine Flying Fox, found in Agusan's forests, is vital for seed dispersal",
	"🌿 Agusan Marsh acts as a natural flood retention basin for the Agusan River",
	"🐠 The Agusan River supports over 65 species of fish",
	"🌱 Peat swamp forests in Agusan Marsh store significant amounts of carbon",
	"🏞️ Lake Panlabuhan in Agusan Marsh changes size with the seasons",
	"🦜 The Philippine Eagle can sometimes be spotted in Agusan's mountain forests",
	"🌿 Sago palms in Agusan Marsh are crucial for local communities",
	"🌧️ Agusan del Sur's wetlands help prevent flooding in lower areas",
	"🦎 The Monitor Lizard (Bayawak) helps control pest populations in Agusan",
	"🌺 Many medicinal plants grow naturally in Agusan's forests",
	
	# Traditional Environmental Knowledge
	"🌿 The Manobo people traditionally practice 'uma' farming, which allows soil regeneration",
	"🌱 'Pangayaw' is a traditional practice of leaving areas untouched to preserve resources",
	"🌳 The Manobo's 'pusaka' system preserves ancient trees as sacred inheritance",
	"🌿 'Panumandon' knowledge guides sustainable wild honey harvesting practices",
	"🏺 Traditional 'binhi' seed keeping preserves local rice varieties",
	"🌱 'Pamuhat' rituals mark planting seasons and promote sustainable harvesting",
	"🌿 The 'tagbanua' calendar guides sustainable farming cycles",
	"🌳 'Pamulalakaw' traditional forest zones protect watershed areas",
	"🔮 'Baylan' shamans traditionally guide sustainable resource use",
	"🌿 'Lapat' system protects specific areas for future generations",
	"🌱 Traditional 'gaud' markers indicate protected forest areas",
	"🌳 'Batasan' customary laws include environmental protection rules",
	"🐝 Traditional beekeeping techniques preserve native bee species",
	"🌿 'Panawagtawag' ceremonies honor nature spirits and promote conservation",
	"🌱 'Tugda' seasonal indicators guide planting and harvesting times",
	"🌳 Sacred groves called 'magnanawing' protect biodiversity",
	"🐟 Traditional fishing methods like 'bungsod' prevent overfishing",
	"🌿 'Dasig' communal work system maintains ecological balance",
	"💧 Water spirit beliefs protect clean water sources",
	"🌱 'Tampuda' peace pacts include environmental protection agreements"
]

var progress = 0.0
signal loading_completed

func _ready():
	# Start randomizing facts and displaying them
	randomize()
	display_random_fact()
	fact_timer.start()  # Start fact display timer
	loading_timer.start()  # Start loading progress timer

func _on_fact_timer_timeout():
	# Display a new random fact each time the timer ticks
	display_random_fact()

func display_random_fact():
	var tween = create_tween()
	# Fade out current text
	tween.tween_property(fact_label, "modulate:a", 0, 0.3)
	await tween.finished
	# Set new fact text and fade it in
	fact_label.text = environmental_facts[randi() % environmental_facts.size()]
	tween = create_tween()
	tween.tween_property(fact_label, "modulate:a", 1, 0.3)

func _on_loading_timer_timeout():
	# Increase progress bar value
	progress += randf_range(1, 5)
	if progress >= 100:
		progress = 100
		loading_timer.stop()  # Stop timer when progress reaches 100
		emit_signal("loading_completed")  # Emit signal that loading is completed
	progress_bar.value = progress
