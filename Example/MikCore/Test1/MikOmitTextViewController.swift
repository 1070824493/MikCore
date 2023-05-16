//
//  MikOmitTextViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/12/10.
//

import UIKit

class MikOmitTextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let textView1 = MikOmitTextView()
        textView1.font = UIFont.systemFont(ofSize: 16.0)
        self.view.addSubview(textView1)
        textView1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.left.right.equalToSuperview().inset(24)
        }
        textView1.configure(isOpen: false, text: "时，将normalAttributedString会添加在文本后 （fold 默认= YES）")
        
        let textView2 = MikOmitTextView()
        textView2.font = UIFont.systemFont(ofSize: 16.0)
        self.view.addSubview(textView2)
        textView2.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.left.right.equalToSuperview().inset(24)
        }
        textView2.configure(isOpen: false, text: "The dichotomy solution is also a bit misleading. You may think it has something to do with the dichotomy idea we discussed earlier. In fact, it has nothing to do with half a dime. Binary search can be used because the function image of the state transition equation is monotonic and the minimum value can be found quickly.")
//        textView2.configure(isOpen: false, text: "图中左侧为工作区，右侧为版本库。在版本库中标记为 \"index\" 的区域是暂存区（stage/index），标记为 \"master\" 的是 master 分支所代表的目录树。图中我们可以看出此时 \"HEAD\" 实际是指向 master 分支的一个\"游标\"。所以图示的命令中出现 HEAD 的地方可以用 master 来替换。图中的 objects 标识的区域为 Git 的对象库，实际位于 \".git/objects\" 目录下，里面包含了创建的各种对象及内容。")
        
//        textView2.configure(isOpen: false, text: "the\n")
//        textView2.configure(isOpen: false, text: "This is my favorite yarn. It’s soft, washes well, and is fantastic for cakes. I make lots of cakes, this is the best, highly recommend! Lorem ipsum dolar a...")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
