//
//  FakeVCs.swift
//  SpeakNow
//
//  Created by CYC on 2016/10/25.
//  Copyright © 2016年 cccfl. All rights reserved.
//

import Foundation
import KVNProgress

class mywordViweController:UITableViewController{
    
    override func viewDidLoad() {
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("111")
        let vc = getVC("webview") as! dictViewCOntroller
        switch indexPath.row {
        case 0:
            vc.url = "discount"
        case 1:
            vc.url = "complain"
        default:
            vc.url = "protest"
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class myrecoardviewcontroller:UITableViewController{
    override func viewDidLoad() {

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = getVC("selectTogo") as! ListenDataDetailViewController
        vc.isoral = false
        vc.listen_id = "1"
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

class dictViewCOntroller:UIViewController,UIWebViewDelegate{
    @IBOutlet var webview: UIWebView!
    var url:String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        title = url
        webview.loadRequest(NSURLRequest(URL: NSURL(string: "http://m.youdao.com/dict?le=eng&q="+self.url)!))
    }
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        if (request.URLString == "http://m.youdao.com/dict?le=eng&q="+self.url){return true}
        return false
    }
    func webViewDidStartLoad(webView: UIWebView){
//        KVNProgress.showWithStatus("查询中")
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        KVNProgress.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError){
        KVNProgress.showErrorWithStatus("查询失败")
    }

}
