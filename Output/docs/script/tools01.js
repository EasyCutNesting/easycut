	function openWindow(url, width, height, top, left, id) {
		window.open(url, id,
					'width='  + width  +','+
					'height=' + height +','+
					'top='    + top    +','+
					'left=' + (window.innerWidth - (width + left))
					).focus();
	}

	function myFunction() {
		window.print();
	}
    function generateBarcode(id_div, value, btype, renderer){
	
        //   "ean8"
        //   "ean13"
        //   "std25"
        //   "int25"
        //   "code11"
        //   "code39"
        //   "code93"
        //   "code128"
        //   "codabar"
		//   var value = "andrea";
        //   var btype = "code39";
        //   var renderer = "css";
        
		//   alert(value);
		//   alert(btype);
		//   alert(renderer);
		//   alert(id_div);
		
        var settings = {
          output:renderer,
          bgColor: $("#bgColor").val(),
          color: $("#color").val(),
          barWidth: $("#barWidth").val(),
          barHeight: $("#barHeight").val(),
          moduleSize: $("#moduleSize").val(),
          posX: $("#posX").val(),
          posY: $("#posY").val(),
          addQuietZone: $("#quietZoneSize").val()
        };
		
		$("#"+id_div).html("").show().barcode(value, btype, settings);
      }
