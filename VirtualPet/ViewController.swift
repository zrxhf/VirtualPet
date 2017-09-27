//
//  ViewController.swift
//  VirtualPet
//
//  Created by Ruxin Zhang on 9/23/17.
//  Copyright © 2017 Ruxin Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		//hide the label and button if user has not started to do task
		taskLabel.isHidden = true
		trueButton.isHidden = true
		falseButton.isHidden = true
		
		//default page information
		currentPet = Pet(_happiness: Float(0), _feed: Float(0),_type: "fish")
		petDic["fish"] = currentPet
		updateBackground(currentPet!)
		animate = false
		updateBar()
		updateLevel()
		updateImg("fish")
		playLabel.text = "Play:" + "0"
		feedLabel.text = "Feed:" + "0"
	
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	/*Mark: IBOutlet*/
	@IBOutlet weak var happinessBar: DisplayView!
	@IBOutlet weak var foodLevelBar: DisplayView!
	
	@IBOutlet weak var backgroudView: UIView!
	@IBOutlet weak var taskView: UIView!
	
	//pet level 🌞=64 🌛=16 🌟=4
	@IBOutlet weak var level: UILabel!
	
	//play/feed times
	@IBOutlet weak var playLabel: UILabel!
	@IBOutlet weak var feedLabel: UILabel!
	
	//start a task
	@IBOutlet weak var taskLabel: UILabel!
	
	//task problem options
	@IBOutlet weak var trueButton: UIButton!
	@IBOutlet weak var falseButton: UIButton!
	
	@IBOutlet weak var img: UIImageView!
	
	/*Mark variables*/
	var currentPet:Pet? //? all value should have initialization otherwise will cause uicontroller has not initailization.
	
	//use dictionary to save pet status
	var question = Question();
	
	//save status of all pets
	var petDic=[String:Pet]()
	
	//task problem index
	var index = 0
	
	//task time 5s count down if flag = 0 you can do a task
	var flag = 0
	//use to control updating when swich between pets
	var animate = false
	
	//select pet
	@IBAction func selectPetType(_ sender: UIButton) {
		if let temp = sender.currentTitle{
			if let pet = petDic[temp] {
				currentPet = pet
			} else {
				currentPet = Pet(_happiness: Float(0), _feed: Float(0),_type: temp)
				petDic[temp] = currentPet
			}
			updateBackground(currentPet!)
			animate = false
			updateBar()
			updateLevel()
			updateImg(temp)
		}
	}
	
	//feed the pet
	@IBAction func feed(_ sender: Any) {
		currentPet?.feedPet()
		feedLabel.text = "Feed:" + String(Int((currentPet?.getFeedTimes())!))
		animate = true
		updateBar()
		updateLevel()
		
	}
	
	//play the pet
	@IBAction func play(_ sender: Any) {
		currentPet?.playPet()
		playLabel.text = "Play:" + String(Int((currentPet?.getPlayTimes())!))
		feedLabel.text = "Feed:" + String(Int((currentPet?.getFeedTimes())!))
		animate = true
		updateBar()
		updateLevel()
	}
	
	//update pet image
	private func updateImg(_ type: String) {
		img.image = UIImage(named: "./pet_images/"+type)
	}
	
	//update background color
	private func updateBackground(_ currentPet:Pet) {
		
		let rgb = currentPet.getRGB()
		let temp = UIColor(red: CGFloat(rgb[0]), green: CGFloat(rgb[1]), blue: CGFloat(rgb[2]), alpha: 60)
		backgroudView.backgroundColor = temp
		happinessBar.color = temp
		foodLevelBar.color = temp
		
	}
	
	//update happinessvalue/foodlevelvaule bar
	public func updateBar() {
		
		let happinessValue = CGFloat((currentPet?.getHappiness())! / (currentPet?.getMax())!)
		let foodLevelValue = CGFloat((currentPet?.getFoodLevel())! / (currentPet?.getMax())!)
		if animate {
			happinessBar.animateValue(to: happinessValue)
			foodLevelBar.animateValue(to: foodLevelValue)
		}else{
			happinessBar.value = happinessValue
			foodLevelBar.value = foodLevelValue
		}
	}

	//update pet level 🌞=64 🌛=16 🌟=4
	func updateLevel() {
		var times = (currentPet?.getPlayTimes())!
		var levelString = ""
		for _ in stride(from: 0, to: times/64, by: 1) {
			levelString += "🌞"
		}
		times %= 64
		for _ in stride(from: 0, to: times/16, by: 1) {
			
			levelString += "🌛"
		}
		times %= 16
		for _ in stride(from: 0, to: times/4, by: 1){
			levelString += "🌟"
		}
		level.text = levelString
	}
	
	//it time count down hide the task related label and button
	func dismissAlert(){
		flag = 0
		taskLabel.isHidden = true
		trueButton.isHidden = true
		falseButton.isHidden = true
	}

	//have 5s to answer a true/false question
	@IBAction func answer(_ sender: UIButton) {
		//if answer correctly, get full food level
		if sender.currentTitle == question.answer[index] {
			trueButton.isHidden = true
			falseButton.isHidden = true
			taskLabel.textColor = UIColor.red
			taskLabel.text = "✅ Cong! Your pet got full enery!"
			currentPet?.setFullFoodLevel()
			updateBar()
		} else {
			//if answer wrongly, reduce happiness
			trueButton.isHidden = true
			falseButton.isHidden = true
			taskLabel.textColor = UIColor.blue
			taskLabel.text = "Oops! Try it again after 5s."
			currentPet?.notHappy()
			updateBar()
		}
	}
	
	//start a true/flase problem task to win full food level
	@IBAction func doTask(_ sender: Any) {
		if flag == 0 {
			flag = 1
			//randomly select question from question database
			index = Int(arc4random_uniform(9))
			taskLabel.textColor = UIColor.black
			taskLabel.text = question.question[index]
			
			taskLabel.isHidden = false
			trueButton.isHidden = false
			falseButton.isHidden = false
			//5s time count down
			Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)

		}else {
			trueButton.isHidden = true
			falseButton.isHidden = true
			taskLabel.textColor = UIColor.red
			taskLabel.text = "Please try it after 5s!"
		}
		
	}
	
}

