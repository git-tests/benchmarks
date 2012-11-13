        	var svgdoc;
		var svgNS = "http://www.w3.org/2000/svg";
		var xlinkNS = "http://www.w3.org/2000/xlink/namespace/";
		var myMapApp = new mapApp();
		var myMainMap;

		function init(evt) {


			svgdoc = evt.target.ownerDocument;
			myMapApp.resetFactors();
			// mapWidth, the minimal zoomValue, the maximal zoomValue, and a zoomStep value (in our case 60% of the previous view).
			myMainMap = new map("mainMap",912,100,1000,0.6);
			//set constraints to draggable rect in reference map
		}

		//holds data on window size
		function mapApp() {
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
			if (evt.type == "mouseup" || evt.type == "mouseout") {
				this.status = "false";
			}			
		}
