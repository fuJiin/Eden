$(document).ready(
	function() {
		
		$(".interactive").live("mouseover",
		function(){
			$(this)
			.resizable({
				handle: 'se'
			})
			.draggable({
				containment: 'parent'
			});
		}
		)
		
		$(".element").live("click",
			function() {
				addElementToContents($(this), $("#content_container"));
			});
			
		$("form").live('submit',
			function() {
				var items = $('#page_content').html();
				$('#staging_area').append(items);
				$('#staging_area').find('.interactive').removeClass('interactive ui-resizable ui-draggable');
				$('#staging_area').find('.ui-resizable-handle').remove()
				var stuff = $('#staging_area').html();
				$('#page_html').val(stuff);
			});
		
	}
)

function addElementToContents(item, content) {
	var element = item.attr("id");
	var text = item.html();
	content.append("<" + element + " class='new_item interactive bordered'>" + "</" + element + ">");
	$(".new_item").html(text);
	$(".new_item").height(40).width(40);
	$(".new_item").removeClass("new_item");
}
