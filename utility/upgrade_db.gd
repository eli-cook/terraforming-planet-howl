extends Node

const ICON_PATH = "res://assets/attack/"
const WEAPON_PATH = "res://assets/attack/"
const ITEMS_PATH = "res://assets/items/"

const UPGRADES = {
	"missile1": {
		"icon": WEAPON_PATH + "fridge.png",
		"displayname": "Wayfair Appliances",
		"details": "Free installation! A fridge is thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"missile2": {
		"icon": WEAPON_PATH + "fridge.png",
		"displayname": "Wayfair Appliances",
		"details": "An additional Fridge is thrown, Buy one get one!",
		"level": "Level: 2",
		"prerequisite": ["missile1"],
		"type": "weapon"
	},
	"missile3": {
		"icon": WEAPON_PATH + "fridge.png",
		"displayname": "Wayfair Appliances",
		"details": "Fridges now pass through another enemy and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["missile2"],
		"type": "weapon"
	},
	"missile4": {
		"icon": WEAPON_PATH + "fridge.png",
		"displayname": "Wayfair Appliances",
		"details": "An additional 2 fridges are thrown, Clearance Sale!",
		"level": "Level: 4",
		"prerequisite": ["missile3"],
		"type": "weapon"
	},
	"lipstick1": {
		"icon": WEAPON_PATH + "lipstick.png",
		"displayname": "Ulta Lipstick",
		"details": "Bullet shaped lipstick, shot at a random enemy!",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"lipstick2": {
		"icon": WEAPON_PATH + "lipstick.png",
		"displayname": "Ulta Lipstick",
		"details": "An additional lipstick is thrown, buy one get one!",
		"level": "Level: 2",
		"prerequisite": ["lipstick1"],
		"type": "weapon"
	},
	"lipstick3": {
		"icon": WEAPON_PATH + "lipstick.png",
		"displayname": "Ulta Lipstick",
		"details": "Increased lipstick shooting speed and +4 damage!",
		"level": "Level: 3",
		"prerequisite": ["lipstick2"],
		"type": "weapon"
	},
	"lipstick4": {
		"icon": WEAPON_PATH + "lipstick.png",
		"displayname": "Ulta Lipstick",
		"details": "An additional 2 bullet lipsticks and insane speed!",
		"level": "Level: 4",
		"prerequisite": ["lipstick3"],
		"type": "weapon"
	},
	"orbit1": {
		"icon": WEAPON_PATH + "phone.png",
		"displayname": "Samsung Phone Plan",
		"details": "A shiny S24 Ultra orbits you",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"orbit2": {
		"icon": WEAPON_PATH + "phone.png",
		"displayname": "Samsung Phone Plan",
		"details": "Add an additional phone to your plan",
		"level": "Level: 2",
		"prerequisite": ["orbit1"],
		"type": "weapon"
	},
	"orbit3": {
		"icon": WEAPON_PATH + "phone.png",
		"displayname": "Samsung Phone Plan",
		"details": "Add an additional phone to your plan",
		"level": "Level: 3",
		"prerequisite": ["orbit2"],
		"type": "weapon"
	},
	"orbit4": {
		"icon": WEAPON_PATH + "phone.png",
		"displayname": "Samsung Phone Plan",
		"details": "Add additional phone to your plan",
		"level": "Level: 4",
		"prerequisite": ["orbit3"],
		"type": "weapon"
	},
	"blast1": {
		"icon": WEAPON_PATH + "blast.png",
		"displayname": "Howl Gun",
		"details": "An additional Blast is thrown",
		"level": "Level: 1",
		"prerequisite": ["blast1"],
		"type": "weapon"
	},
	"blast2": {
		"icon": WEAPON_PATH + "blast.png",
		"displayname": "Howl Gun",
		"details": "An additional Blast is thrown",
		"level": "Level: 2",
		"prerequisite": ["blast1"],
		"type": "weapon"
	},
	"blast3": {
		"icon": WEAPON_PATH + "blast.png",
		"displayname": "Howl Gun",
		"details": "Blasts now pass through another enemy and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["blast2"],
		"type": "weapon"
	},
	"blast4": {
		"icon": WEAPON_PATH + "blast.png",
		"displayname": "Howl Gun",
		"details": "An additional 2 blasts are thrown",
		"level": "Level: 4",
		"prerequisite": ["blast3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ITEMS_PATH + "makeuppalette.png",
		"displayname": "Sephora Makeup Palette",
		"details": "Charm everyone with the Wake Up With Me Morning kit. Reduces damage",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ITEMS_PATH + "makeuppalette.png",
		"displayname": "Sephora Makeup Palette",
		"details": "Try our facial cleansers! Further reduces damage",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ITEMS_PATH + "makeuppalette.png",
		"displayname": "Sephora Makeup Palette",
		"details": "Supplement with our Glowy Lip Balm! Further reduces damage",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ITEMS_PATH + "makeuppalette.png",
		"displayname": "Sephora Makeup Palette",
		"details": "Complete your look with our Goof Proof Eyebrow Pencil! Further reduces damage",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ITEMS_PATH + "highheel.png",
		"displayname": "Revolve Footwear",
		"details": "Glide away on Revolve's Ariella Heel. Move Speed +30%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ITEMS_PATH + "highheel.png",
		"displayname": "Revolve Footwear",
		"details": "Practice makes perfect! Move Speed +30%",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ITEMS_PATH + "highheel.png",
		"displayname": "Revolve Footwear",
		"details": "Nailing that model walk! Move Speed +30%",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ITEMS_PATH + "highheel.png",
		"displayname": "Revolve Footwear",
		"details": "You are basically floating now. Move Speed +30%",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ITEMS_PATH + "scroll.png",
		"displayname": "Best Buy Trade in Program",
		"details": "Trade in for a bigger one! +50% spell size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ITEMS_PATH + "scroll.png",
		"displayname": "Best Buy Trade in Program",
		"details": "Only with eligible plan/warranty purchase. +50% spell size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ITEMS_PATH + "scroll.png",
		"displayname": "Best Buy Trade in Program",
		"details": "Get $300 when you trade in your old iphone. +50% spell size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ITEMS_PATH + "scroll.png",
		"displayname": "Best Buy Trade in Program",
		"details": "Only applies towards eligible trade ins. +50% spell size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ITEMS_PATH + "potion.png",
		"displayname": "iHerb Wellness Shop",
		"details": "Take 2 times a day, morning and night. +20% reduced global cooldown",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ITEMS_PATH + "potion.png",
		"displayname": "iHerb Wellness Shop",
		"details": "Noticeable improvements after 30 day, or your money back. +20% reduced global cooldown",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ITEMS_PATH + "potion.png",
		"displayname": "iHerb Wellness Shop",
		"details": "+20% reduced global cooldown",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ITEMS_PATH + "potion.png",
		"displayname": "iHerb Wellness Shop",
		"details": "+20% reduced global cooldown",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ITEMS_PATH + "ring1.png",
		"displayname": "Macy's Jewelry (Cheap)",
		"details": "Sterling Silver with Cubic Zirconia. +1 Projectile",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ITEMS_PATH + "ring2.png",
		"displayname": "Macy's Jewelry (Regular)",
		"details": "Rose Gold with Peridot. +1 Projectile",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"ring3": {
		"icon": ITEMS_PATH + "ring3.png",
		"displayname": "Macy's Jewelry (Luxury)",
		"details": "14k Gold with Diamond. +1 Projectile",
		"level": "Level: 3",
		"prerequisite": ["ring2"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}

}
