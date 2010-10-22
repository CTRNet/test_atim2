/**
 * Script for displaying popups
 * @author: FM L'Heureux
 * @date: 2010-07-10
 * @version: 0.0.1
 * @see: http://frank-mich.com/
 **/
var closePop = true;

jQuery.fn.popup = function(options){
	if(options == "close"){
		$(".popup_outer").hide();
	}else if($(".popup_outer").length == 0){
		$("body").append("<div class='popup_outer'>"
				+ "<div class='popup_container'></div>"
				+ "<div class='popup_close'><a href='#'>X</a></div>"
				+ "</div>");
		$(".popup_outer").click(function(){
			if(closePop){
				$(".popup_outer").hide();
			}else{
				closePop = true;
			}
		});
		$(document).keyup(function(event) {
		  if(event.keyCode == 27) { // Capture Esc key
			  $(".popup_outer").hide();
		  }
		});
	}else{
		$(".popup_outer").show();
	}
	$(this).each(function(){
		$(".popup_container").children().hide();
		if(options){
			$(this).css(options);
		}
		$(this).css({
			"margin" : "auto",
			"position" : "relative"
		});
		if($(this).parent().html() != $($(".popup_container")[0]).html()){
			$(".popup_container").append($(this));
			
			$(this).click(function(){
				closePop = false;
			});
		}
		$(".popup_close").appendTo($(".popup_container")).show();
		$(this).show();
		$(".popup_container").css("left", $(window).width() / 2 - $(".popup_container").width() / 2 + "px");
		$(".popup_container").css("top", $(window).height() / 2 - $(".popup_container").height() / 2 + "px");
	});
}
