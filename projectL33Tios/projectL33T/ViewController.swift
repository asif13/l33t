//
//  ViewController.swift
//  projectL33T
//
//  Created by Asif Junaid on 5/23/15.
//  Copyright (c) 2015 Asif Junaid. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,LineChartDelegate{
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var instanceTwo: UIButton!
    
    @IBOutlet weak var outletForFluxBtn: UIButton!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    var cpu_utils_data = [String() : [String]()]
    var dataForGraphs = [String():[CGFloat]()]
    var timestampData = [String():[String]()]
    @IBOutlet weak var StatDetailOutlet: UIView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    var lineChart: LineChart!
    var currentInstance : String!
    var modelForNumberOfTypesOfData = ["Cpu data","Heat monitor","Spike"]
    
    @IBOutlet weak var outletForFiveLabels: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.hidden = true
        addSwipeToGraph()
        outletForFluxBtn.enabled = false
        actionForCPUTime.enabled = false
        heatAction.enabled = false
        startDownloading()
     //   var timer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: Selector("startDownloading"), userInfo: nil, repeats: true)
      }
    
    func startDownloading()
    {
        var urlString = "http://52.68.237.151:8123/server"
        var url:NSURL! = NSURL(string: urlString) // put error check here LATER
        

        fetchGetUrl(url, params: nil, onSuccess: { (data) -> Void in
            //println(data)
            self.parseThatData(data)
            }) { (message) -> Void in
                println(message)
        }
    }
    var dataForBarGraph = [String() : [CGFloat]()]
    
    func downloadDataForBarGraph(name : String ,resourceId : String)
    {
        var urlString = "http://52.68.237.151:8123/stats?id=\(resourceId)&meter=disk.write.bytes"
        var url:NSURL! = NSURL(string: urlString) // put error check here LATER
        fetchGetUrl(url, params: nil, onSuccess: { (data) -> Void in
            println(data)
            let dataExt = data as! NSArray
            let avg = (dataExt[0] as! NSDictionary)["avg"] as! CGFloat
            var dataForBarGraph = [CGFloat()]
            
            dataForBarGraph[0] = (avg)
            //self.dataForBarGraph[name]?.append(avg)
            var urlString = "http://52.68.237.151:8123/stats?id=\(resourceId)&meter=disk.read.bytes"
            var url:NSURL! = NSURL(string: urlString) // put error check here LATER
            
            self.fetchGetUrl(url, params: nil, onSuccess: { (data) -> Void in
                println(data)
                let dataExt = data as! NSArray
                let avg = (dataExt[0] as! NSDictionary)["avg"] as! CGFloat
                self.dataForBarGraph[name]?.append(avg)
                self.heatAction.enabled = true
                dataForBarGraph.append(avg)
                self.dataForBarGraph[name] = dataForBarGraph

                
                }) { (message) -> Void in
                    println(message)
            }
            
            }) { (message) -> Void in
                println(message)
        }
        
    }
    
    var detailsOfInstances : [(String,String)]!
    
    @IBAction func instanceTwoAction(sender: UIButton) {
        sender.backgroundColor =  UIColor(red: 0, green: 1, blue: 0, alpha: 0.1)
        instanceOneAction.backgroundColor = UIColor.clearColor()
        currentInstance = "test"
        rightSwiped()
        rightSwiped1()
    }
    func parseThatData(data : AnyObject)
    {
        let dataExtract = data as! NSArray
        for individualData in dataExtract
        {
            println(individualData)
            let dict = individualData as! NSDictionary
            let name = dict["name"] as! String
            let resourceid = dict["resource_id"] as! String

                downloadstats(name,resourceid: resourceid,meter : "cpu_util")
                downloadDataForGraph(name,resourceid: resourceid)
                downloadDataForBarGraph(name, resourceId: resourceid)
            
        }
    }
    
    @IBOutlet weak var instanceOneAction: UIButton!
   // var currentButtonSelected
    @IBAction func instanceOne(sender: UIButton) {
        currentInstance = "InMobi_server"
        sender.backgroundColor =  UIColor(red: 0, green: 1, blue: 0, alpha: 0.1)
        instanceTwo.backgroundColor = UIColor.clearColor()
        rightSwiped()
        rightSwiped1()
    }
    func downloadDataForGraph(name : String ,resourceid : String)
    {
        let urlString = "http://52.68.237.151:8123/sample?id=\(resourceid)"
        var url:NSURL! = NSURL(string: urlString) // put error check here LATER
        
        fetchGetUrl(url, params: nil, onSuccess: { (data) -> Void in
            println(data)
            self.parseForGraph(name,data: data)
            //self.parseThatData(data)
            }) { (message) -> Void in
                println(message)
        }
    }
    func parseForGraph(name : String ,data : AnyObject)
    {
        let dataExtract = data as! NSArray
        println(dataExtract)
        var dataForGraphs1 = [CGFloat]()
        var timestampData1 = [String]()
        for dataIndi in dataExtract
        {
            let counter_volume = (dataIndi as! NSDictionary)["counter_volume"] as! CGFloat
            let timestamp = (dataIndi as! NSDictionary)["timestamp"] as! String
            dataForGraphs1.append(counter_volume)
            timestampData1.append(timestamp)
        }
        timestampData[name] = timestampData1.reverse()
        dataForGraphs[name] = dataForGraphs1.reverse()
        outletForFluxBtn.enabled = true
    }
    
    func downloadstats(name : String ,resourceid : String,meter : String)
    {
        let urlString = "http://52.68.237.151:8123/stats?id=\(resourceid)&meter=\(meter)"
        var url:NSURL! = NSURL(string: urlString) // put error check here LATER
        
        fetchGetUrl(url, params: nil, onSuccess: { (data) -> Void in
            println(data)
            self.parseResourceIDData(name,data: data)
            
            //self.parseThatData(data)
            }) { (message) -> Void in
                println(message)
        }
    }
    
    func parseResourceIDData(name : String ,data : AnyObject)
    {
        let dataExtract = data as! NSArray
        let dict = dataExtract[0] as! NSDictionary
        let avg = dict["count"] as! Int
        var cpu_utils_data1 = [String]()
        cpu_utils_data1.append("\(avg)")
        let count = dict["avg"] as! Int
        cpu_utils_data1.append("\(count)")
        let min = dict["max"] as! Int
        cpu_utils_data1.append("\(min)")
        let max = dict["min"] as! Int
        cpu_utils_data1.append("\(max)")
        cpu_utils_data[name] = cpu_utils_data1
        actionForCPUTime.enabled = true
        actionForCPUTime.setNeedsDisplay()
    }
    
    @IBAction func actionForCPUTime(sender: UIButton) {
        //drawGraph()
        drawLabels()
    }
    
    @IBOutlet weak var actionForCPUTime: UIButton!
    
    func fetchGetUrl(url:NSURL, params:[String:AnyObject]?, onSuccess:((data: AnyObject) -> Void)?, onFail:((message:String) -> Void)?){
        println(url)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.addValue("http://mobileapp.stayzilla.com/", forHTTPHeaderField: "Referer")
        
        if(params != nil){
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        }
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if error == nil{
                var err:NSError?
                if data != nil{
                    if var jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err){
                        //                        NSLog("received response..")
                        onSuccess!(data: jsonResult)
                        
                    }
                    else
                    {
                        onFail!(message: "error on parsing")
                    }
                }
                else
                {
                    onFail!(message: "No data received")
                }
            }
            else{
                onFail!(message:error.description)
            }
        }
        queue.waitUntilAllOperationsAreFinished()
    }
    
    
    func drawLineGraph()
    {
        //tableViewOutlet.hidden = true
        
        var data: [CGFloat] = dataForGraphs[currentInstance]!
        var data2: [CGFloat] = []

        for dataIn in data
        {
            if dataIn > 80
            {
                data2.append(dataIn)
            }
        }
        
        var xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let frame = graphView.frame
        lineChart = LineChart(frame: CGRect(x: 0,y: 0,width: 375,height: 200))
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        //lineChart.x.labels.values = [""]
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        //lineChart.addLine(data2)
        lineChart.delegate = self
        graphView.addSubview(lineChart)
        graphView.hidden = false
        UIView.transitionFromView(StatDetailOutlet,
            toView: graphView,
            duration: 0.3,
            options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews,
            completion: nil)
        arrayOfGraphs.append(lineChart)
    }
    @IBOutlet weak var heatAction: UIButton!
    
    @IBAction func heatAction(sender: UIButton) {
        drawBarGraph()
    }
    func toClearGraphs()
    {
        for view in arrayOfGraphs
        {
            view.removeFromSuperview()
        }
    }
    
    var arrayOfGraphs = [UIView()]
    
    @IBAction func fluxAction(sender: UIButton) {
          drawLineGraph()
    }
    
    func addSwipeToGraph()
    {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        graphView.addGestureRecognizer(swipeRight)
        let swipeRight1 = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped1"))
        swipeRight1.direction = UISwipeGestureRecognizerDirection.Right
        outletForFiveLabels.addGestureRecognizer(swipeRight1)
        //outletForFiveLabels.addGestureRecognizer(swipeRight)
        
    }
    
    func drawLabels()
    {
        let data = cpu_utils_data[currentInstance]!
        
       label5.text = data[0]
        label6.text = data[1]
        label7.text = data[2]
        label8.text = data[3]
        
        UIView.transitionFromView(StatDetailOutlet,
            toView: outletForFiveLabels,
            duration: 0.3,
            options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews,
            completion: nil)

    }
    func drawBarGraph()
    {
        var obj = PNBarChart(frame: CGRect(x: 0,y: 0,width: 400,height: 200))
        obj.xLabels = ["disk.write.bytes","disk.read.bytes"]
        obj.yValues = dataForBarGraph[currentInstance]!
        obj.strokeChart()
        graphView.addSubview(obj)
        UIView.transitionFromView(StatDetailOutlet,
            toView: graphView,
            duration: 0.3,
            options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews,
            completion: nil)
        
        arrayOfGraphs.append(obj)
    }
    func rightSwiped1()
    {
       // graphView.hidden = true
        UIView.transitionFromView(outletForFiveLabels,
            toView: StatDetailOutlet,
            duration: 0.3,
            options: UIViewAnimationOptions.TransitionFlipFromLeft
                | UIViewAnimationOptions.ShowHideTransitionViews,
            completion: nil)
        toClearGraphs()
    }
    
    func rightSwiped()
    {
        graphView.hidden = true
        UIView.transitionFromView(graphView,
            toView: StatDetailOutlet,
            duration: 0.3,
            options: UIViewAnimationOptions.TransitionFlipFromLeft
                | UIViewAnimationOptions.ShowHideTransitionViews,
            completion: nil)
        toClearGraphs()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        drawLineGraph()
        }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = modelForNumberOfTypesOfData[indexPath.row]
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
    }

}

