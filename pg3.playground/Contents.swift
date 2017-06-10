print("HI")
//: Playground - noun: a place where people can play


class Element {
    var contents: [String]
    var width : Int
    var height : Int
    //let empty_char: Character = ("".characters)[0]
    let empty_char: String = " "
    
    /*init(){
        self.contents = []
        width = 0
        height = 0
    }*/
    
    init(contents : [String] ){
        //print(self.empty_char.characters.count)
        self.contents = contents
        self.width = contents[0].characters.count
        self.height = contents.count
    }
    
    func above(_ that : Element)-> Element  {
        
        let this1 = self.widen(w:that.width) //this widen that.width
        let that1 = that.widen(w:self.width)    //that widen this.width
       // print("in above")
       // print((this1.contents + that1.contents).joined(separator: ""))
        
        return elem(this1.contents + that1.contents)
    }
    
    func beside(_ that : Element)->Element  {
        //print("in beside")
        let this1 = self.heighten(h:that.height)
        let that1 = that.heighten(h:self.height)
        
        var combined_line = [String]()
        
        for (l1, l2) in zip(this1.contents, that1.contents)
        {
            combined_line.append(l1+l2)
        }
        //print(combined_line.joined(separator: " , "))
        return elem(combined_line)
    }
    
    func widen( w : Int) -> Element {
        if (w <= width) {
            return self
            
        }
        else {
           // print("width ", w)
            let left = elem(empty_char, width : (w - width) / 2, height : height)
            //print(left.width ,  " ", left.height)
            let right = elem(empty_char, width : w - width - left.width,height : height)
            //print(right.width, " ", right.height)
            return left.beside(self.beside(right))
            //left beside this beside right
        }
    }
    
    func heighten(h: Int) -> Element {
        if (h <= height) {
            return self
        }
            
        else {
            //print("height, ", h)
            let top = elem(empty_char, width : width, height : ((h - height) / 2))
            //print(top.height)
            let bot = elem(empty_char, width : width, height : h - height - top.height)
            //print(bot.height)
            return top.above(self.above(bot))
           
        }
    }
    
   public var description: String { return self.contents.joined(separator: "\n") }
 
}
extension Element {
    fileprivate class ArrayElement : Element {
        init(contents_self : [String]) {
            
            super.init(contents : contents_self)
        }
        
    }
    
    fileprivate class LineElement : Element {
        
        init(line : String){
            super.init(contents : [line])
            self.width = line.characters.count
            self.height = 1
        }
        //let contents = Array(s)
        
    }
    
    fileprivate class UniformElement : Element {
        
        init(ch:String , width: Int , height : Int) {
            let contents : [String]
            if height == 0 {
                 //print("in 0", " ch ", ch, " width ", width , " height ", height)
                 contents = [ch]
                
            }
            else {
            
            let line   =  String(repeating: ch, count: width)
            //print(line)
            //let contents = Array.fill(height)(line)
            //print(height)
                 contents  = Array(repeating: line , count : height)
            }
            //print(contents)
            super.init(contents : contents)
            
            self.width = width
            self.height = height
                
            
            
        }
    }
    
    
    func elem(_ contents: [String] ) -> Element
    {
        return  ArrayElement(contents_self : contents)
    }
    
    func elem(_ chr: String, width: Int, height: Int) -> Element
    {
        
        return UniformElement(ch: chr, width: width, height: height)
    }
    
    func elem(_ line: String) -> Element {
        return LineElement(line :line)
    }
    
    
}

var element = Element(contents : [","])
let space = element.elem(" ")
let corner = element.elem("+")
//let verticalBar = element.elem("|", width : 1, height : 6)
//let horizontalBar = element.elem("-", width : 6, height : 1)
//print(horizontalBar.description)

func spiral(_ nEdges: Int, direction: Int) ->Element {
    if nEdges == 1{
        let e : Element = element.elem( "+")
        return e
    }
    else {
        //let space = element.elem(" ")
        //let corner = element.elem("+")
        
        let sp = spiral(nEdges-1, direction : ((direction + 3) % 4))
        
        let verticalBar = element.elem("|", width : 1, height : sp.height)
        let horizontalBar = element.elem("-", width : sp.width, height : 1)
        if direction == 0
        {
            //(corner beside horizontalBar) above (sp beside space)
            return (corner.beside (horizontalBar)).above(sp.beside( space))
        }
        else if direction == 1
        {
            return (sp.above ( space )).beside(corner.above(verticalBar ))
            
        }
        else if direction == 2 {
            return (space.beside ( sp )).above(horizontalBar.beside(corner ))
            
        }
        else{
            return (verticalBar.above (corner )).beside( space.above(sp ))
            
        }
    }
}


var nSides = 6 //args(0).toInt
print(spiral(nSides, direction: 0).description)

 nSides = 11 //args(0).toInt
print(spiral(nSides, direction: 0).description)


 nSides = 17 //args(0).toInt
print(spiral(nSides, direction: 0).description)


