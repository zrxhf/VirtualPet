//
//  Pet.swift
//  VirtualPet
//
//  Created by Ruxin Zhang on 9/23/17.
//  Copyright © 2017 Ruxin Zhang. All rights reserved.
//

import Foundation

class Pet{
	
	enum PetType {
		case dog
		case cat
		case bird
		case fish
		case bunny
	}
	
	private var happiness:Float
	private var foodLevel:Float
	private var type:PetType
	private var playTimes = 0
	private var feedTimes = 0
	private var maximum = 10
	private var RGB:[Int];
	
	init(_happiness:Float,_feed:Float,_type:String) {
		self.happiness = _happiness
		self.foodLevel = _feed
		switch _type {
			case "dog":
				type = PetType.dog
				RGB = [255,0,0]
			case "cat":
				type = PetType.cat
			    RGB = [0,255,0]
			case "fish":
				type = PetType.fish
				RGB = [0,0,255]
			case "bunny":
				type = PetType.bunny
				RGB = [0,82,45]
			case "bird":
				type = PetType.bird
				RGB = [78,128,122]
			default:
				type = PetType.fish
				RGB = [0,0,255]
			
		}
	}
	
	func getType()->PetType {
		return type
	}
	

	func getPlayTimes()->Int {
		return self.playTimes
	}
	func getFeedTimes()->Int {
		return self.feedTimes
	}
	
	func getMax()->Float {
		return Float(self.maximum)
	}
	
	func getHappiness()->Float {
		return happiness
	}
	
	func getFoodLevel() -> Float {
		return foodLevel
	}
	func feedPet() {
		if foodLevel < Float(maximum) {
			foodLevel += 1
		}
		self.feedTimes += 1
	}
	
	func playPet() {
		if foodLevel > 0 {
			if happiness < Float(maximum) {
				happiness += 1
			}
			foodLevel -= 1
			self.playTimes += 1
		}
	}
	
	func setFullFoodLevel() {
		foodLevel = Float(self.maximum)
	}
	func getRGB()->[Int] {
		return RGB
	}
	func notHappy() {
		if happiness >= 5 {
			happiness -= 5
		}
	}
}
