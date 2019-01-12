//
//  ViewController.swift
//  CollectionViewLayout
//
//  Created by David Perez on 1/8/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//

import UIKit
import CoreData

final class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private  var savedEvents: [EventEntity] = []
    private  var events: [EventModel?] = []
    
    private   var gradient = CAGradientLayer()
    private  var on = true
    private   let view1 : UIView = {
        let v = UIView()
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return  v
    }()
    
    
    private  let button : UIButton = {
        let b = UIButton(type: UIButton.ButtonType.system)
        let image = UIImage(named: "moonIcon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(image, for: UIControl.State.normal)
        b.addTarget(self, action: #selector(changeColor), for: UIControl.Event.touchUpInside)
        return b
    }()
    
    
    private  let collectionView: CollectionViewFlow = {
        let c = CollectionViewFlow(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        c.isSpringLoaded = true
        c.backgroundColor = .clear
        c.contentMode = UIView.ContentMode.center
        return c
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
        ftchJSON()
        
        let ftchRequest: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        
        do {
            let savedEvents = try PersitanceService.context.fetch(ftchRequest)
            print(savedEvents)
            // savedEvents = savedEvents
            collectionView.reloadData()
        } catch {
            print("fetch error")
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        addGradientEffect(targetView: view1)
    }
    
    fileprivate  func addGradientEffect(targetView: UIView){
        gradient = CAGradientLayer()
        gradient.frame = targetView.frame
        gradient.colors = [GradientColors().oceanBlue, GradientColors().lightBlue, GradientColors().lightGreen]
        gradient.startPoint = CGPoint(x: 0.0,y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0,y: 1.0)
        targetView.layer.addSublayer(gradient)
    }
    
    fileprivate   func createEventArray(){
       
        
        let eventData = EventEntity(context: PersitanceService.context)
        
        for evnts in events {
            let imgFromURl = URL(string: evnts!.img)
            let data = try? Data(contentsOf: imgFromURl!)
            eventData.entityImage = NSData(data: data!)
            eventData.entityCost = evnts!.cost
            eventData.entityTime = evnts!.time
            eventData.entityNameString = evnts!.name
            PersitanceService.saveContext()
            savedEvents.append(eventData)
            print(savedEvents)
            collectionView.reloadData()
        }
    }
    
    fileprivate func ftchJSON(){
        
        let urlString = "https://my-json-server.typicode.com/DavidPerezP124/EventJSON/posts"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("URL fecth error", err)
                    return
                }
                guard let data = data else {return}
                do {
                    let decoder = JSONDecoder()
                    self.events = try decoder.decode([EventModel].self, from: data)
                    // self.events = [self.event]
                    self.collectionView.reloadData()
                } catch let jsonError {
                    print("Decode failure", jsonError)
                }
            }
            self.createEventArray()
            }.resume()
        
    }
    
    fileprivate func setupView(){
        view.addSubview(view1)
        view.addSubview(button)
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/3).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.dataSource = self
        
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.register(MyCellCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        view1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        view1.widthAnchor.constraint(equalToConstant: view.frame.width ).isActive = true
        view1.heightAnchor.constraint(equalToConstant: view.frame.height ).isActive = true
        view1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width*0.2).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.frame.width*0.2).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
    }
    
    fileprivate func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: 120)
    }
    
    fileprivate func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    fileprivate  func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCellCollectionViewCell
//        DispatchQueue.main.async {
//            let cellEvent = self.savedEvents[indexPath.row]
//
//            //        let imgUrl = URL(string: (cellEvent.img))
//            //        let data = try? Data(contentsOf: imgUrl!)
//
//            cell.img.image = UIImage(data: cellEvent.entityImage! as Data)
//            cell.label.text = cellEvent.entityNameString
//        }
        // cell.img.contentMode = UIViewContentMode.scaleAspectFill
        
        return cell 
    }
    fileprivate func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
    fileprivate func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    @objc
    fileprivate  func changeColor(){
        print("touched")
        
        if on == true {
            let animateColor = CABasicAnimation(keyPath: "colors")
            animateColor.duration = 0.5
            animateColor.toValue = [GradientColors().darkPurple, GradientColors().midPurple, GradientColors().darkBlue]
            animateColor.fillMode = CAMediaTimingFillMode.forwards
            animateColor.isRemovedOnCompletion = false
            gradient.add(animateColor, forKey: "hello")
            on = false
        } else if on == false {
            let animateColor = CABasicAnimation(keyPath: "colors")
            animateColor.duration = 0.5
            animateColor.fromValue = [GradientColors().darkPurple, GradientColors().midPurple, GradientColors().darkBlue]
            animateColor.toValue = [GradientColors().oceanBlue, GradientColors().lightBlue, GradientColors().lightGreen]
            animateColor.fillMode = CAMediaTimingFillMode.forwards
            animateColor.isRemovedOnCompletion = false
            gradient.add(animateColor, forKey: "hello")
            on = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

