var canvas;
var ctx;
var widthCanvas;
var heightCanvas;

// View parameters
var xleftView = 0;
var ytopView = 0;
var widthViewOriginal = 140.0;           		//actual width and height of zoomed and panned display
var heightViewOriginal = 100.0;
// var widthViewOriginal = 140.0;           		//actual width and height of zoomed and panned display
// var heightViewOriginal = 100.0;
var widthView = widthViewOriginal;          
var heightView = heightViewOriginal;
var Fact=100;
var FlagShape=0;
var FlagBolts=0;

window.addEventListener("load",setup,false);

function setup() {
    canvas = document.getElementById("canvas");
    ctx = canvas.getContext("2d");

    widthCanvas = canvas.width;
    heightCanvas = canvas.height;

    canvas.addEventListener("dblclick", handleDblClick, false);       	// dblclick to zoom in at point, shift dblclick to zoom out.
    canvas.addEventListener("mousedown", handleMouseDown, false); 		// click and hold to pan
    canvas.addEventListener("mousemove", handleMouseMove, false);
    canvas.addEventListener("mouseup", handleMouseUp, false);
    canvas.addEventListener("mousewheel", handleMouseWheel, false); 	// mousewheel duplicates dblclick function
    canvas.addEventListener("DOMMouseScroll", handleMouseWheel, false); // for Firefox

    draw();
}



function handleDblClick(event) {
    var X = event.clientX - this.offsetLeft - this.clientLeft + this.scrollLeft; //Canvas coordinates
    var Y = event.clientY - this.offsetTop - this.clientTop + this.scrollTop;
    var x = X/widthCanvas * widthView + xleftView;  // View coordinates
    var y = Y/heightCanvas * heightView + ytopView;

    var scale = event.shiftKey == 1 ? 1.5 : 0.5; // shrink (1.5) if shift key pressed
    widthView *= scale;
    heightView *= scale;
	
	if (widthView > widthViewOriginal || heightView > heightViewOriginal) {
	widthView = widthViewOriginal;
	heightView = heightViewOriginal;
	x = widthView/2;
	y = heightView/2;
    }

    xleftView = x - widthView/2;
    ytopView = y - heightView/2;

	Fact=widthView/scale;
    draw();

   //  draw();
}

var mouseDown = false;

function handleMouseDown(event) {
    mouseDown = true;
}

function handleMouseUp(event) {
    mouseDown = false;
}

var lastX = 0;
var lastY = 0;
function handleMouseMove(event) {

    var X = event.clientX - this.offsetLeft - this.clientLeft + this.scrollLeft;
    var Y = event.clientY - this.offsetTop - this.clientTop + this.scrollTop;

    if (mouseDown) {
        var dx = (X - lastX) / widthCanvas * widthView;
        var dy = (Y - lastY)/ heightCanvas * heightView;
	xleftView -= dx;
	ytopView -= dy;
    }
    lastX = X;
    lastY = Y;
	
	
    draw();
	// draw();
}

function handleMouseWheel(event) {
    var x = widthView/2 + xleftView;  // View coordinates
    var y = heightView/2 + ytopView;

    var scale = (event.wheelDelta < 0 || event.detail > 0) ? 1.1 : 0.9;
    widthView *= scale;
    heightView *= scale;

	if (widthView > widthViewOriginal || heightView > heightViewOriginal) {
	widthView = widthViewOriginal;
	heightView = heightViewOriginal;
	x = widthView/2;
	y = heightView/2;
    }

    // scale about center of view, rather than mouse position. This is different than dblclick behavior.
    xleftView = x - widthView/2;
    ytopView = y - heightView/2;
	
	// alert(widthView/scale + ' ' + heightView/scale);
	
	Fact=widthView/scale;
    draw();
}