//
//  ViewController.swift
//  CollectionViewLayout
//
//  Created by David Perez on 1/8/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var event: EventModel!
    var events: [EventModel?] = []
    
    var gradient = CAGradientLayer()
    var on = true
    let view1 : UIView = {
        let v = UIView()
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return  v
    }()
    
    
    let button : UIButton = {
        let b = UIButton(type: UIButtonType.system)
        let image = UIImage(named: "moonIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(image, for: UIControlState.normal)
        b.addTarget(self, action: #selector(changeColor), for: UIControlEvents.touchUpInside)
        return b
    }()
    
    
    let collectionView: CollectionViewFlow = {
        let c = CollectionViewFlow(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        c.isSpringLoaded = true
        c.backgroundColor = .clear
        c.contentMode = UIViewContentMode.center
        return c
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
     //   collectionView.prefetchDataSource = self
        
    }
    override func viewDidLayoutSubviews() {
        addGradientEffect(targetView: view1)
    }
    
    func addGradientEffect(targetView: UIView){
        gradient = CAGradientLayer()
        gradient.frame = targetView.frame
        gradient.colors = [GradientColors().oceanBlue, GradientColors().lightBlue, GradientColors().lightGreen]
        gradient.startPoint = CGPoint(x: 0.0,y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0,y: 1.0)
        targetView.layer.addSublayer(gradient)
    }
    
    func createEventArray(){
        ftchJSON()
        
        //let eventData = Entity(context: Persitance)
        
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
            
            }.resume()
    }
    
    func setupView(){
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCellCollectionViewCell
        let cellEvent = events[indexPath.row]
        let imgUrl = URL(string: (cellEvent!.img))
        let data = try? Data(contentsOf: imgUrl!)
        DispatchQueue.main.async {
            cell.img.image = UIImage(data: data!)
            print(cell.img.image)
        }
       // cell.img.contentMode = UIViewContentMode.scaleAspectFill
        cell.label.text = cellEvent?.name
        return cell 
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   
    
    
    @objc
    func changeColor(){
        print("touched")
        
        if on == true {
            let animateColor = CABasicAnimation(keyPath: "colors")
            animateColor.duration = 0.5
            animateColor.toValue = [GradientColors().darkPurple, GradientColors().midPurple, GradientColors().darkBlue]
            animateColor.fillMode = kCAFillModeForwards
            animateColor.isRemovedOnCompletion = false
            gradient.add(animateColor, forKey: "hello")
            on = false
        } else if on == false {
            let animateColor = CABasicAnimation(keyPath: "colors")
            animateColor.duration = 0.5
            animateColor.fromValue = [GradientColors().darkPurple, GradientColors().midPurple, GradientColors().darkBlue]
            animateColor.toValue = [GradientColors().oceanBlue, GradientColors().lightBlue, GradientColors().lightGreen]
            animateColor.fillMode = kCAFillModeForwards
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

