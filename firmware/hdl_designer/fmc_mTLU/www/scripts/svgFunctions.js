var svgdoc;
var SVGRoot;
var svgNS = "http://www.w3.org/2000/svg";
var xlinkNS = "http://www.w3.org/2000/xlink/namespace/";
var myMapApp = new mapApp();
var myMainMap;
var myRefMapDragger;
var netlist = new Array();
var noOfNets = 0;
var myScrollButton;

// This struct holds info about transforms being applied to the SVG
// It is used to reposition elements that we dont want to be moved when the SVG is zoomed/panned
var frame = {
   x_trans: 0,
   y_trans: 0,
   zoom   : 1,
   x_scale: 1,
   y_scale: 1
};


function init(evt) {
	initNetList();
	svgdoc = evt.target.ownerDocument;

        // Get the top-most SVG element
        SVGRoot = svgdoc.documentElement;

	myMapApp.resetFactors();
	// mapWidth, the minimal zoomValue, the maximal zoomValue, and a zoomStep value (in our case 60% of the previous view).
	myMainMap = new map("mainMap",914,100,1000,0.6);

	//x=100, xmax=100, y=20, ymax=120
	myScrollButton = new dragScrollObj("myScrollButton",450,470,25,110,"ul");
	myScrollButton.showText(0);

        // when we init, zero the scale and translate
        SVGRoot.currentScale = 1;
        SVGRoot.currentTranslate.x = 0;
        SVGRoot.currentTranslate.y = 0;
        svgMoved();
}

// This function is called whenever the SVG is zoomed/moved
function svgMoved(evt) {
   // Get the current zoom and pan settings
   var trans = SVGRoot.currentTranslate;
   var scale = SVGRoot.currentScale;

   // Determine the translation needed to move the upper-left
   // corner of our tracking rectangle to the upper-left of the
   // current view.
   // The zeros are used to reinforce that we are translating
   // the origin of the rectangle to the upper-left corner of the
   // current view.
   frame.x_trans = ( 0.0 - trans.x ) / scale;
   frame.y_trans = ( 0.0 - trans.y ) / scale;

   // Now that we have moved the rectangle's corner to the
   // upper-left position, let's scale the rectangle to fit
   // the current view.  X and Y scales are maintained seperately
   // to handle possible anamorphic scaling from the viewBox
   frame.zoom = scale;
   frame.x_scale = 1 / scale;
   frame.y_scale = 1 / scale;

   // Get the current viewBox
   var vbox = SVGRoot.getAttributeNS(null, "viewBox");
   if ( vbox ) {
      // We have a viewBox so, update our translation and scale
      // to take the viewBox into account
      // Break the viewBox parameters into an array to make life easier
      var params  = vbox.split(/\s+/);

      // Determine the scaling from the viewBox
      // Note that these calculations assume that the outermost
      // SVG element has height and width attributes set to 100%.
      var h_scale = window.innerWidth  / params[2];
      var v_scale = window.innerHeight / params[3];

      // Update our previously calculated transform
      frame.x_trans = frame.x_trans / h_scale + parseFloat(params[0]);
      frame.y_trans = frame.y_trans / v_scale + parseFloat(params[0]);
      frame.x_scale = frame.x_scale / h_scale;
      frame.y_scale = frame.y_scale / v_scale;
   }

   // Apply changes to any elements we dont want to move
   updateAfterSVGMove();
}

function updateAfterSVGMove() {
   // Build the text versions of the translate and scale transformation
   var trans = "translate(" + frame.x_trans + "," + frame.y_trans + ")"
   var scale = "scale(" + 1/frame.zoom + "," + 1/frame.zoom + ")";

   // transform the titlebox so it appears not to move when the SVG does
   var tb = svgdoc.getElementById("titlebox");
   tb.setAttributeNS(null, "transform", trans + " " + scale);
}

function changeFillColour(evt,colour) {
   // reference to the currently selected object
   var element = evt.target;

   // change its colour to the supplied one
   element.setAttribute('fill',colour);
}

function changeIdFillColour(id,colour) {
   // get the supplied element via its id
   var element = svgdoc.getElementById(id);

   // change its colour to the supplied one
   element.setAttribute('fill',colour);
}

function changeFillOpacity(evt,opac) {
   // reference to the currently selected object
   var element = evt.target;

   // change its colour to the supplied one
   element.setAttribute('opacity',opac);
}

function changeIdFillOpacity(id,opac) {
   // get the supplied element via its id
   var element = svgdoc.getElementById(id);

   // change its colour to the supplied one
   element.setAttribute('opacity',opac);
}

function highlightNet(element,netlistRowId,stroke,strokeWidth)
{
   if (element != "") {
      if (stroke=="rgb(0,0,0)") {
         element.setAttribute('stroke',"rgb(" + 255 + "," + 0 + "," + 0 + ")");
         var s = strokeWidth[0] - '0';
         element.setAttribute('stroke-width',s + 1 + "px");
         // set the netlist text in the scroll box
         var netText = svgdoc.getElementById(netlistRowId);
         netText.setAttribute('fill', "rgb(" + 255 + "," + 0 + "," + 0 + ")");
      }
      else {
         element.setAttribute('stroke',"rgb(" + 0 + "," + 0 + "," + 0 + ")");
         var s = strokeWidth[0] -'0';
         element.setAttribute('stroke-width',s - 1  + "px");
         // set the netlist text in the scroll box
         var netText = svgdoc.getElementById(netlistRowId);
         netText.setAttribute('fill', "rgb(" + 0 + "," + 0 + "," + 0 + ")");
      }
   }
}

function scrollTextClick(index, netlistRowId)
{
   var netElement = svgdoc.getElementById(netlist[index]+"_net");
   if (netElement != "") {
      var stroke = "";
      var strokeWidth = "";
      var groupElement = "";
      var group = netElement.getAttribute('group');
      if (group != "") {
         groupElement = svgdoc.getElementById(group+"_net");
         stroke = groupElement.getAttribute('stroke');
         strokeWidth = groupElement.getAttribute('stroke-width');
      }
      else {
         stroke = netElement.getAttribute('stroke');
         strokeWidth = netElement.getAttribute('stroke-width');
      }
      highlightNet(netElement,netlistRowId,stroke,strokeWidth);
      highlightNet(groupElement,netlistRowId,stroke,strokeWidth);
   }
}

//holds data on map
function map(mapName,origWidth,minZoom,maxZoom,zoomFact) {
	var mapSVG = svgdoc.getElementById(mapName);
	this.mapName = mapName;
	this.origWidth = origWidth;
	this.minZoom = minZoom;
	this.maxZoom = maxZoom;
	this.zoomFact = zoomFact;
	this.pixXOffset = parseFloat(mapSVG.getAttributeNS(null,"x"));
	this.pixYOffset = parseFloat(mapSVG.getAttributeNS(null,"y"));
	viewBoxArray = mapSVG.getAttributeNS(null,"viewBox").split(" ");
	this.curxOrig = parseFloat(viewBoxArray[0]);
	this.curyOrig = parseFloat(viewBoxArray[1]);
	this.curWidth = parseFloat(viewBoxArray[2]);
	this.curHeight = parseFloat(viewBoxArray[3]);
	this.pixWidth = parseFloat(mapSVG.getAttributeNS(null,"width"));
	this.pixHeight = parseFloat(mapSVG.getAttributeNS(null,"height"));
	this.pixXOrig = parseFloat(mapSVG.getAttributeNS(null,"x"));
	this.pixYOrig = parseFloat(mapSVG.getAttributeNS(null,"y"));
	this.pixSize = this.curWidth / this.pixWidth;
	this.zoomVal = this.origWidth / this.curWidth * 100;
}

map.prototype.newViewBox = function(refRectId,refMapId) {
	var myRefRect = svgdoc.getElementById(refRectId);
	var myRefMapSVG = svgdoc.getElementById(refMapId);
	var viewBoxArray = myRefMapSVG.getAttributeNS(null,"viewBox").split(" ");
	var refPixSize = viewBoxArray[2] / myRefMapSVG.getAttributeNS(null,"width");
	this.curxOrig = parseFloat(viewBoxArray[0]) + (myRefRect.getAttributeNS(null,"x") - myRefMapSVG.getAttributeNS(null,"x")) * refPixSize;
	this.curyOrig = parseFloat(viewBoxArray[1]) + (myRefRect.getAttributeNS(null,"y") - myRefMapSVG.getAttributeNS(null,"y")) * refPixSize;
	this.curWidth = myRefRect.getAttributeNS(null,"width") * refPixSize;
	this.curHeight = myRefRect.getAttributeNS(null,"height") * refPixSize;
	var myViewBoxString = this.curxOrig + " " + this.curyOrig + " " + this.curWidth + " " + this.curHeight;						
	this.pixSize = this.curWidth / this.pixWidth;
	this.zoomVal = this.origWidth / this.curWidth * 100;
	svgdoc.getElementById(this.mapName).setAttributeNS(null,"viewBox",myViewBoxString);
}

//holds data on window size
function mapApp() {
}

//calculate ratio and offset values of app window
mapApp.prototype.resetFactors = function() {
	var svgroot = svgdoc.documentElement;
	if (!svgroot.getScreenCTM) {
		//case for ASV3 and Corel
		var viewBoxArray = svgroot.getAttributeNS(null,"viewBox").split(" ");
		var myRatio = viewBoxArray[2]/viewBoxArray[3];
		if ((window.innerWidth/window.innerHeight) > myRatio) { //case window is more wide than myRatio
			this.scaleFactor = viewBoxArray[3] / window.innerHeight;
		}
		else { //case window is more tall than myRatio
			this.scaleFactor = viewBoxArray[2] / window.innerWidth;		
		}
		this.offsetX = (window.innerWidth - viewBoxArray[2] * 1 / this.scaleFactor) / 2;
		this.offsetY = (window.innerHeight - viewBoxArray[3] * 1 / this.scaleFactor) / 2;
	}
}
mapApp.prototype.calcCoord = function(coordx,coordy) {
	var svgroot = svgdoc.documentElement;
	var coords = new Array();
	if (!svgroot.getScreenCTM) {
		//case ASV3 a. Corel
		coords["x"] = (coordx  - this.offsetX) * this.scaleFactor;
		coords["y"] = (coordy - this.offsetY) * this.scaleFactor;
	}
	else {
		matrix=svgroot.getScreenCTM();
		coords["x"]= matrix.inverse().a*coordx+matrix.inverse().c*coordy+matrix.inverse().e;
		coords["y"]= matrix.inverse().b*coordx+matrix.inverse().d*coordy+matrix.inverse().f;
	}
	return coords;
}

//////////////////////////////////////////////////////////////////////////////////////////////
//scrollable Map
//////////////////////////////////////////////////////////////////////////////////////////////
//make an element draggable with constraints
function dragObj(dragId,constrXmin,constrXmax,constrYmin,constrYmax,refPoint) {
	this.dragId = dragId;
	this.constrXmin = constrXmin;
	this.constrXmax = constrXmax;
	this.constrYmin = constrYmin;
	this.constrYmax = constrYmax;
	this.refPoint = refPoint;
	this.status = "false";
}
dragObj.prototype.drag = function(evt) {
	//works only for rect and use-elements
	var myDragElement = evt.target;
	if (evt.type == "mousedown") {
		var coords = myMapApp.calcCoord(evt.clientX,evt.clientY);
		this.curX = coords["x"];
		this.curY = coords["y"];
		this.status = "true";
	}
	if (evt.type == "mousemove" && this.status == "true") {
		var coords = myMapApp.calcCoord(evt.clientX,evt.clientY);
		var newEvtX = coords["x"];
		var newEvtY = coords["y"];
		var bBox = myDragElement.getBBox();
		if (this.refPoint == "ul") {
			var toMoveX = bBox.x + newEvtX - this.curX;
			var toMoveY = bBox.y + newEvtY - this.curY;
		}
		else {
			//refPoint = center
			var toMoveX = bBox.x + bBox.width / 2 + newEvtX - this.curX;
			var toMoveY = bBox.y + bBox.height / 2 + newEvtY - this.curY;
		}
		if ((bBox.x + newEvtX - this.curX) < this.constrXmin) {
			if(this.refPoint == "ul") {
				toMoveX = this.constrXmin;
			}
			else {
				toMoveX = this.constrXmin + bBox.width / 2;
			}
		}
		if ((bBox.x + newEvtX - this.curX + bBox.width) > this.constrXmax) {
			if(this.refPoint == "ul") {
				toMoveX = this.constrXmax - bBox.width;
			}
			else {
				toMoveX = this.constrXmax - bBox.width / 2;
			}					
		}
		if ((bBox.y + newEvtY - this.curY) < this.constrYmin) {
			if(this.refPoint == "ul") {
				toMoveY = this.constrYmin;
			}
			else {
				toMoveY = this.constrYmin + bBox.height / 2;
			}
		}
		if ((bBox.y + bBox.height + newEvtY - this.curY) > this.constrYmax) {
			if(this.refPoint == "ul") {
				toMoveY = this.constrYmax - bBox.height;
			}
			else {
				toMoveY = this.constrYmax - bBox.height / 2;
			}					
		}
		myDragElement.setAttributeNS(null,"x",toMoveX); 
		myDragElement.setAttributeNS(null,"y",toMoveY);
		this.curX = newEvtX;
		this.curY = newEvtY;
	}
	if (evt.type == "mouseup" || evt.type == "mouseout") {
		this.status = "false";
	}
}
dragObj.prototype.zoom = function(inOrOut) {
	var myDragElement = svgdoc.getElementById(this.dragId);
	var myOldX = myDragElement.getAttributeNS(null,"x");
	var myOldY = myDragElement.getAttributeNS(null,"y");
	var myOldWidth = myDragElement.getAttributeNS(null,"width");
	var myOldHeight = myDragElement.getAttributeNS(null,"height");
	switch (inOrOut) {
		case "in":
			var myNewX = parseFloat(myOldX) + myOldWidth / 2 - (myOldWidth * myMainMap.zoomFact * 0.5);
			var myNewY = parseFloat(myOldY) + myOldHeight / 2 - (myOldHeight * myMainMap.zoomFact * 0.5);
			var myNewWidth = myOldWidth * myMainMap.zoomFact;
			var myNewHeight = myOldHeight * myMainMap.zoomFact;
			break;
		case "out":
			var myNewX = parseFloat(myOldX) + myOldWidth / 2 - (myOldWidth * (1 + myMainMap.zoomFact) * 0.5);
			var myNewY = parseFloat(myOldY) + myOldHeight / 2 - (myOldHeight * (1 + myMainMap.zoomFact) * 0.5);
			var myNewWidth = myOldWidth * (1 + myMainMap.zoomFact);
			var myNewHeight = myOldHeight * (1 + myMainMap.zoomFact);
			break;
		default:
			var myNewX = this.constrXmin;
			var myNewY = this.constrYmin;
			var myNewWidth = this.constrXmax - this.constrXmin;
			var myNewHeight = this.constrYmax - this.constrYmin;
			break;
	}
	if (myNewWidth > (this.constrXmax - this.constrXmin)) {
		myNewWidth = this.constrXmax - this.constrXmin;
	}
	if (myNewHeight > (this.constrYmax - this.constrYmin)) {
		myNewHeight = this.constrYmax - this.constrYmin;
	}
	if (myNewX < this.constrXmin) {
		myNewX = this.constrXmin;
	}
	if (myNewY < this.constrYmin) {
		myNewY = this.constrYmin;
	}
	if ((myNewX + myNewWidth) > this.constrXmax) {
		myNewX = this.constrXmax - myNewWidth;
	}
	if ((myNewY + myNewHeight) > this.constrYmax) {
		myNewY = this.constrYmax - myNewHeight;
	}
	myDragElement.setAttributeNS(null,"x",myNewX);
	myDragElement.setAttributeNS(null,"y",myNewY);
	myDragElement.setAttributeNS(null,"width",myNewWidth);
	myDragElement.setAttributeNS(null,"height",myNewHeight);
	myMainMap.newViewBox(this.dragId,"referenceMap");
}

//function for status Bar
function statusChange(statusText) {
	svgdoc.getElementById("statusText").firstChild.nodeValue = "Statusbar: " + statusText;
}

//scale an object
function scaleObject(evt,factor) {
//reference to the currently selected object
var element = evt.currentTarget;
	var myX = element.getAttributeNS(null,"x");
	var myY = element.getAttributeNS(null,"y");
var newtransform = "scale(" + factor + ") translate(" + (myX * 1 / factor - myX) + " " + (myY * 1 / factor - myY) +")";
element.setAttributeNS(null,'transform', newtransform);
}
function zoomIt(inOrOut) {
	if (inOrOut == "in") {
		if (myMainMap.zoomVal < myMainMap.maxZoom) {
			myRefMapDragger.zoom("in");
		}
		else {
			statusChange("maximum zoom factor reached! cannot zoom in any more!");
		}
	}
	if (inOrOut == "out") {
		if (myMainMap.zoomVal > myMainMap.minZoom) {
			myRefMapDragger.zoom("out");
		}
		else {
			statusChange("minimum zoom factor reached! cannot zoom out any more!");			
		}		
	}
	if (inOrOut == "full") {
		if (myMainMap.zoomVal > myMainMap.minZoom) {
			myRefMapDragger.zoom("full");				
		}
		else {
			statusChange("Full view already reached!");			
		}		
	}
}


function checkBoxScript(evt,myLayer) { //checkBox for toggling layers an contextMenue
	var myLayerObj = svgdoc.getElementById(myLayer);
	var myCheckCrossObj = svgdoc.getElementById("checkCross"+myLayer);
	var myCheckCrossVisibility = myCheckCrossObj.getAttributeNS(null,"visibility");
	if (evt.type == "click") {
		if (myCheckCrossVisibility == "visible") {
			myLayerObj.setAttributeNS(null,"stroke","rgb(255,0,0)");
			myLayerObj.setAttributeNS(null,"stroke-width","2px");
			myCheckCrossObj.setAttributeNS(null,"visibility","hidden");
		}
		else {
			myLayerObj.setAttributeNS(null,"stroke","rgb(0,0,0)");		
			myLayerObj.setAttributeNS(null,"stroke-width","1px");
			myCheckCrossObj.setAttributeNS(null,"visibility","visible");
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////
//scrollable text object
//////////////////////////////////////////////////////////////////////////////////////////////

function dragScrollObj(dragId,constrXmin,constrXmax,constrYmin,constrYmax,refPoint) {
	this.dragId = dragId;
	this.constrXmin = constrXmin;
	this.constrXmax = constrXmax;
	this.constrYmin = constrYmin;
	this.constrYmax = constrYmax;
	this.refPoint = refPoint;
	this.status = "false";
}


dragScrollObj.prototype.addText = function(x, y, index, str) {
   if (noOfNets == 0) {
      return;
   }

   var groupElement= svgdoc.getElementById("group");
   var TXT=svgDocument.createElement('text');
   TXT.setAttribute('id',str);
   TXT.setAttribute('x',x);
   TXT.setAttribute('y',y);
   TXT.setAttribute('onclick',"scrollTextClick(" + index + ",'" + str + "')");
   
   // set the highlight box to highlight when moving mouse over text
   TXT.setAttribute('onmouseover',"changeIdFillColour('" + str + "_box','rgb(200,230,240)'); changeIdFillOpacity('" + str + "_box',0.4)");
   TXT.setAttribute('onmouseout',"changeIdFillColour('" + str + "_box','rgb(255,255,255)'); changeIdFillOpacity('" + str + "_box',0)");
   // also set the box to select the text when clicked
   var highlightBox= svgdoc.getElementById(str + "_box");
   highlightBox.setAttribute('onclick',"scrollTextClick(" + index + ",'" + str + "')");
 
   var val = "";
   if (index < noOfNets) {
        var myNetElement= svgdoc.getElementById(netlist[index]+"_net");
        var stroke = myNetElement.getAttribute('stroke');
        if (stroke=="rgb(0,0,0)") {
           TXT.setAttribute('fill',"rgb(" + 0 + "," + 0 + "," + 0 + ")");
        } else {
           TXT.setAttribute('fill',"rgb(" + 255 + "," + 0 + "," + 0 + ")");
        }

	val = index + ": " + netlist[index] ;
	if (val.length>27) {
	   val = val.substr(0,25);
	   val += "...";
	}
   }

   TXT.appendChild(svgDocument.createTextNode(val));
   groupElement.appendChild(TXT);
}


dragScrollObj.prototype.showText = function(index) {
   if (noOfNets == 0) {
      return;
   }

   var groupElement= svgdoc.getElementById("group");
   var myNetElement= svgdoc.getElementById("netlist0");
   groupElement.removeChild(myNetElement);
   var myNetElement= svgdoc.getElementById("netlist1");
   groupElement.removeChild(myNetElement);
   var myNetElement= svgdoc.getElementById("netlist2");
   groupElement.removeChild(myNetElement);
   var myNetElement= svgdoc.getElementById("netlist3");
   groupElement.removeChild(myNetElement);

   this.addText(this.constrXmin-185,this.constrYmin+15,index,"netlist0");
   this.addText(this.constrXmin-185,this.constrYmin+35,index+1,"netlist1");
   this.addText(this.constrXmin-185,this.constrYmin+55,index+2,"netlist2");
   this.addText(this.constrXmin-185,this.constrYmin+75,index+3,"netlist3");
}


dragScrollObj.prototype.calculateScroll = function(evt) {
   var elementH = 20;
   var scrollHeight = 85;
   var noOfRows = Math.round(scrollHeight/20);
   var noOfPixels = (noOfNets)/noOfRows;
   var multiplier = 1;
   while(noOfPixels>scrollHeight) {
	multiplier++;
	noOfPixels = noOfPixels / 2;
   }
   var position = evt.clientY - this.constrYmin
   var index = Math.round(((scrollHeight/noOfPixels)*position)*multiplier);
   index = index * 2;


   var pix = noOfNets/scrollHeight;
   index = Math.round(pix*position);

   //alert(index);

   this.showText(index);
}

dragScrollObj.prototype.drag = function(evt) {
	//works only for rect and use-elements
	var myDragElement = evt.target;
	if (evt.type == "mousedown") {
		this.curX = evt.clientX;
		this.curY = evt.clientY;
		this.status = "true";				
		var val = 0;
		this.calculateScroll(evt);

	}
	if (evt.type == "mousemove" && this.status == "true") {
		var newEvtX = evt.clientX;
		var newEvtY = evt.clientY;
		var bBox = myDragElement.getBBox();
		if (this.refPoint == "ul") {
			var toMoveX = bBox.x + newEvtX - this.curX;
			var toMoveY = bBox.y + newEvtY - this.curY;
		}
		else {
			//refPoint = center
			var toMoveX = bBox.x + bBox.width / 2 + newEvtX - this.curX;
			var toMoveY = bBox.y + bBox.height / 2 + newEvtY - this.curY;
		}
		if ((bBox.x + newEvtX - this.curX) < this.constrXmin) {
			if(this.refPoint == "ul") {
				toMoveX = this.constrXmin;
			}
			else {
				toMoveX = this.constrXmin + bBox.width / 2;
			}
		}
		if ((bBox.x + newEvtX - this.curX + bBox.width) > this.constrXmax) {
			if(this.refPoint == "ul") {
				toMoveX = this.constrXmax - bBox.width;
			}
			else {
				toMoveX = this.constrXmax - bBox.width / 2;
			}					
		}
		if ((bBox.y + newEvtY - this.curY) < this.constrYmin) {
			if(this.refPoint == "ul") {
				toMoveY = this.constrYmin;
			}
			else {
				toMoveY = this.constrYmin + bBox.height / 2;
			}
		}
		if ((bBox.y + bBox.height + newEvtY - this.curY) > this.constrYmax) {
			if(this.refPoint == "ul") {
				toMoveY = this.constrYmax - bBox.height;
			}
			else {
				toMoveY = this.constrYmax - bBox.height / 2;
			}					
		}
		myDragElement.setAttributeNS(null,"x",toMoveX);
		myDragElement.setAttributeNS(null,"y",toMoveY);
		this.curX = newEvtX;
		this.curY = newEvtY;
		this.calculateScroll(evt);

	}
	if (evt.type == "mouseup" || evt.type == "mouseout") {
		this.status = "false";
	}			
}


