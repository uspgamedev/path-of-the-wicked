extends Node2D

const BANDIT            = preload('res://creeps/bandit/bandit.tscn')
const BEE               = preload('res://creeps/bee/bee.tscn')
const CHITINIAC         = preload('res://creeps/chitiniac/chitiniac.tscn')
const COCKROACH         = preload('res://creeps/cockroach/cockroach.tscn')
const CRAWLER           = preload('res://creeps/crawler/crawler.tscn')
const DEMON             = preload('res://creeps/demon/demon.tscn')
const DRAGON            = preload('res://creeps/dragon/dragon.tscn')
const GARGANT_BERSERKER = preload('res://creeps/gargant/berserker/gargant_berserker.tscn')
const GARGANT_BOSS      = preload('res://creeps/gargant/boss/gargant_boss.tscn')
const GARGANT_LORD      = preload('res://creeps/gargant/lord/gargant_lord.tscn')
const GARGANT_SIMPLE    = preload('res://creeps/gargant/simple/gargant_simple.tscn')
const HORNET            = preload('res://creeps/hornet/hornet.tscn')
const KLIVER            = preload('res://creeps/kliver/kliver.tscn')
const BLUE_MAGE         = preload('res://creeps/mage/blue/blue_mage.tscn')
const GREEN_MAGE        = preload('res://creeps/mage/green/green_mage.tscn')
const OGRE              = preload('res://creeps/ogre/ogre.tscn')
const OGRILLION         = preload('res://creeps/ogrillion/ogrillion.tscn')
const RAT               = preload('res://creeps/rat/rat.tscn')
const SCORPION          = preload('res://creeps/scorpion/scorpion.tscn')
const SKELETON_KNIGHT   = preload('res://creeps/skeleton/knight/skeleton_knight.tscn')
const SKELETON_MAGE     = preload('res://creeps/skeleton/mage/skeleton_mage.tscn')
const TIMBERMAN         = preload('res://creeps/timberman/timberman.tscn')
const TROLL             = preload('res://creeps/troll/troll.tscn')
const UGONOTH           = preload('res://creeps/ugonoth/ugonoth.tscn')
const WOLFBEAST         = preload('res://creeps/wolfbeast/wolfbeast.tscn')

const CREEPS = [
	RAT,
	BANDIT,
	BEE,
	SKELETON_MAGE,
	TIMBERMAN,
	SKELETON_KNIGHT,
	HORNET,
	KLIVER,
	SCORPION,
	OGRE,
	COCKROACH,
	BLUE_MAGE,
	GREEN_MAGE,
	CRAWLER,
	OGRILLION,
	TROLL,
	CHITINIAC,
	WOLFBEAST,
	UGONOTH,
	GARGANT_SIMPLE,
	GARGANT_BERSERKER,
	GARGANT_LORD,
	GARGANT_BOSS,
	DRAGON,
	DEMON,
]
